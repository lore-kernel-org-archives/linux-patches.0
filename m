Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC767471421;
	Tue, 21 Jul 2026 20:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665349; cv=none; b=fKuQvZxQ8fHTOF+GJ9bYxQ4y/60EY/hcGnUn42QdH/JBKsY561tVpEA8eMoTpEreh1sfA2OlhLt+2O4GYs8yWhlF0WwPV3lmCzu351Ncy8HKxUysW8tLx94nS94r9Wp/TdvsRh5WklHF/QfHKrPKwRAthsKBeEjTFI4BI4I4xLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665349; c=relaxed/simple;
	bh=B7ogZ7K3XYJMjvylrcM7bBMqSlz48okF+97HZhydSKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGYBLPUBXZdyRwrWc2h5xJ+MaqSpZD7Of4ns1bHba5b6S5Zgw+I1LlB/TF/mC0ELi48TjCmiKM61uwpi0uy2qkWRbyXrmS02nlQmkUSjWM2CJbL949ukXgUSy+E5dhuqeJWexvo36whiDqOCo9rz/f8Kyxos6cuFMrpGSIEVxqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldVnYdkq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldVnYdkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D72B1F000E9;
	Tue, 21 Jul 2026 20:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665347;
	bh=/O6I2FnrB6XQXI3Jw+OiT0UIom1hV+rZbgMGzuuUTyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldVnYdkqoCvVfh8DtjVnOk1w7Maj7jsFJkwcrP4xx1OVK7dNr6NwMni4TzVDo816Y
	 P9D5CSsFVNeeU8ZjbvECfsZIzZacwLO5zhWpz3n8ZG7utLv/lRVzZQzcNqwzrUNcKB
	 +ddGWNUkheQqZcev68Yt2OmiNvrRRwhHp7NQ++B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.6 0268/1266] isofs: bound Rock Ridge symlink components to the SL record
Date: Tue, 21 Jul 2026 17:11:45 +0200
Message-ID: <20260721152447.819218568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 5fa1d6a5ec2356d2107dead614437c66fa7138b1 upstream.

get_symlink_chunk() and the SL handling in
parse_rock_ridge_inode_internal() walk the variable-length components of
a Rock Ridge "SL" (symbolic link) record.  Each component is a two-byte
header (flags, len) followed by len bytes of text, so it occupies
slp->len + 2 bytes.  Both loops read slp->len and advance to the next
component, and get_symlink_chunk() additionally does
memcpy(rpnt, slp->text, slp->len), but neither checks that the component
lies within the SL record before dereferencing it.

A crafted SL record whose component declares a len that runs past the
record (rr->len) therefore triggers an out-of-bounds read of up to 255
bytes.  When the record sits at the tail of its backing buffer - for
example a small kmalloc()ed continuation block reached through a CE
record - the read crosses the allocation; get_symlink_chunk() then
copies the out-of-bounds bytes into the symlink body returned to user
space by readlink(), disclosing adjacent kernel memory.

ISO 9660 images are routinely mounted from untrusted removable media -
desktop environments auto-mount them (e.g. via udisks2) without
CAP_SYS_ADMIN - so the record contents are attacker-controlled.

Reject any component that does not fit in the remaining record bytes
before using it.  In get_symlink_chunk() return NULL, like the existing
output-buffer (plimit) checks, so a malformed record makes readlink()
fail with -EIO rather than silently returning a truncated target; in
parse_rock_ridge_inode_internal() stop the inode-size walk.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Suggested-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260607011823.217748-1-hexlabsecurity@proton.me
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/isofs/rock.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -462,6 +462,9 @@ repeat:
 				inode->i_size = symlink_len;
 				while (slen > 1) {
 					rootflag = 0;
+					/* keep the component within the SL record */
+					if (slp->len + 2 > slen)
+						goto eio;
 					switch (slp->flags & ~1) {
 					case 0:
 						inode->i_size +=
@@ -617,6 +620,14 @@ static char *get_symlink_chunk(char *rpn
 	slp = &rr->u.SL.link;
 	while (slen > 1) {
 		rootflag = 0;
+		/*
+		 * A component is slp->len + 2 bytes (a two-byte header plus
+		 * len bytes of text).  If it does not fit in the bytes left in
+		 * the SL record the record is malformed: fail like the plimit
+		 * checks below so readlink() returns -EIO, not a truncated path.
+		 */
+		if (slp->len + 2 > slen)
+			return NULL;
 		switch (slp->flags & ~1) {
 		case 0:
 			if (slp->len > plimit - rpnt)


