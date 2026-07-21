Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BFC43C7C8;
	Tue, 21 Jul 2026 22:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671220; cv=none; b=n6RJ3wZ2Pkv58CrEUa/z1jgCBCks/tM25TvjYJXolRzd4ovRR/0It2MHO9TEKTJ//ot12g8CmT14R9Mvmkrt3WTmrPOwYJvaWE+PlhuaxMp3KxIGIfUSgjAg9yQOhQzc0bT8kRkLfwp8Esm1Cwioh38qEAjdEiIzyhq0ePjiStY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671220; c=relaxed/simple;
	bh=Z47uUF6+ZsNkh6aU5tmRynt9DJR8wv96MfWlybQpS5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFCJWmekRKVpWnSk7e9KxQORYc6F4LwE5nXjXMecWVkStEHmfvecujjzqX/CMAKFv4wCv/8R1q7zZx/XXW42ZAh3NoMcaKMB47SjEy4Tvunp89tmg38lW5CEghvA0DuX/xWttpawmc3fY9vesXuxPW5tlz+qZ0qfL4vnwto+K1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz+bAG8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz+bAG8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44A41F000E9;
	Tue, 21 Jul 2026 22:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671218;
	bh=7Mk6OViX+9Fc9B0TwZj2RR6xM/LCb5MRCBTy2CvwZVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zz+bAG8ettoVNfVzj5uAHokCNBwsukk36XCRLqhUwLDyZ2c1t10sPY5hfKs2/o4TY
	 XpbrQevZlqKAOq9JEb1BcdoPC6/LgnNwA8lzgzUeNeZwiupjwt79W3AaTB3JVinC0e
	 Y0XuJJlHCvxXY8bYKwGSLkZI3he5lAKwKIvlfKLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 162/843] isofs: bound Rock Ridge symlink components to the SL record
Date: Tue, 21 Jul 2026 17:16:37 +0200
Message-ID: <20260721152409.658229789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -464,6 +464,9 @@ repeat:
 				inode->i_size = symlink_len;
 				while (slen > 1) {
 					rootflag = 0;
+					/* keep the component within the SL record */
+					if (slp->len + 2 > slen)
+						goto eio;
 					switch (slp->flags & ~1) {
 					case 0:
 						inode->i_size +=
@@ -619,6 +622,14 @@ static char *get_symlink_chunk(char *rpn
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


