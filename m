Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD352D6E64;
	Thu, 16 Jul 2026 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210011; cv=none; b=fGP+5IH2BI4zPxpMB9IsYwRKQrOPLNbLrYxnG2Vj24pQXFjxjlA7ZHQIcz0T0FMAH9gre8xUe8nc4KutV94gEP5HBcBQLXt3P89/q/HdGNHEw1TveOleY0QPNUWIBOfrQsjPv18noqH30lmF+rb0k3j1MEBSOue41HOoYgeWgdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210011; c=relaxed/simple;
	bh=UL1J+DBQLMnZeaiuTFV//soKM/8xOyr4D/vVQop+DhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiG2hEpGXafRh9OBXqsjO9GTO7zR5sbr76JM+blQ65tjhXVtUPA1l+XWFmGw4TyeYkewgxOMJhsLIstQYpgLpjYMXqjgMMlrZSvssxm6pAoF2C9pvieLSnTDgKpiO44DDxoJ/4H3uWLcJw6HKbCdSjjsj+r7DFlFqApAc1SRkm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2DvOpQT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2DvOpQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A2B1F000E9;
	Thu, 16 Jul 2026 13:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210009;
	bh=VIMQnjURBFtH9UZexyOcZT4J/hMqA1vYNXYCEKUtdU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2DvOpQT2VVRV/RnWP+EPwXry4GuuLE40sE8QfYQCfwUz46cGx68JayesspA2BRCu
	 TPiaKl3MHQ4sDrzxYN5c/dN0NQqVmSxWllvvqai0jHKfPh2JklM6wcsLI2le8Q8udb
	 3quw0CIxod7q+VH29BFGqk3TnHRYxbrYkrfI0+80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7.1 359/518] isofs: bound Rock Ridge symlink components to the SL record
Date: Thu, 16 Jul 2026 15:30:27 +0200
Message-ID: <20260716133055.684469440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -466,6 +466,9 @@ repeat:
 				inode->i_size = symlink_len;
 				while (slen > 1) {
 					rootflag = 0;
+					/* keep the component within the SL record */
+					if (slp->len + 2 > slen)
+						goto eio;
 					switch (slp->flags & ~1) {
 					case 0:
 						inode->i_size +=
@@ -621,6 +624,14 @@ static char *get_symlink_chunk(char *rpn
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


