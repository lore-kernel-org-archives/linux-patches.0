Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5330C313550;
	Thu, 28 May 2026 20:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000442; cv=none; b=R1MMv5WxYXHnl3U1zHO/aV3h72n0pOVe5gA+u6HfIAct/H0MpmF76HPhL+BPve8GQk/4T3RRIQoksHmkcyrgElcnIJmI1EYY2a0sU1fC5pXp6/2eVru8RRwadV0F3oOIHa1ahuXq3oDaWloQLjyK6/ibKsXdSE0eDDspeFqPbxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000442; c=relaxed/simple;
	bh=2UgYJQjfIU7hGbCgwP400YlkyjnJHWNn4JvYccZ1Pwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVBg+8svxXwS6gh7BUXGBO/nLt9e+c53YrtHU5mTYCWEz/k81UC+peC3hZiapa5I/D9vQgQ6j6vQCNElL7MzDCIuf53Xm77Bo8DGx0GetvJmDRwyMHFXLiglnpvP16mPF+PNQeS2ajo75Bq1DPbiTe5h+LQLhnwhiToJUcEaAL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6uwdZno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6uwdZno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14FC1F000E9;
	Thu, 28 May 2026 20:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000441;
	bh=kmMQb3AqNhjjVUNETrcrR1h9bUW5rWoNZJNO/ZCE0Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6uwdZno8dN86qoCNT/BIYW+yHJ72OjBp/VFDIRFqgWQE6ypP7F+LdUqReH9EuG12
	 BDxkpY85vrbJUmgzYI0YUfOO92tYR4FHaE3tv5PoxXpJPlqwXZMDExxlLFMr1379nI
	 Z5ZvDtsSji85yLfnN4uxRe3oiwn81fn7WZCAzSz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Meng <mengferry@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 045/272] ksmbd: fix SID memory leak in set_posix_acl_entries_dacl() on overflow
Date: Thu, 28 May 2026 21:46:59 +0200
Message-ID: <20260528194630.642578624@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ferry Meng <mengferry@linux.alibaba.com>

commit af92ee994cc7f7e83a41c2025f32257a2f82a7ef upstream.

Commit 299f962c0b02 ("ksmbd: use check_add_overflow() to prevent u16
DACL size overflow") added check_add_overflow() guards that break out
of the ACE-building loops in set_posix_acl_entries_dacl() when the
accumulated DACL size would wrap past 65535.

However, each iteration allocates a struct smb_sid via kmalloc_obj()
at the top of the loop and relies on the kfree(sid) call at the end
of the loop body (the 'pass_same_sid' label in the first loop, and
the explicit kfree at the tail of the second loop) to release it.
The newly introduced 'break' statements bypass those kfree() calls,
leaking the sid buffer every time an overflow is detected.

A malicious or malformed file with enough POSIX ACL entries to trip
the overflow check will leak one or more struct smb_sid allocations
on every request that touches the file's DACL, providing a trivial
kernel memory exhaustion vector.

Free sid before breaking out of the loops to plug the leak.

Fixes: 299f962c0b02 ("ksmbd: use check_add_overflow() to prevent u16 DACL size overflow")
Cc: stable@vger.kernel.org
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -643,8 +643,10 @@ static void set_posix_acl_entries_dacl(s
 		ntace = (struct smb_ace *)((char *)pndace + *size);
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, flags,
 				pace->e_perm, 0777);
-		if (check_add_overflow(*size, ace_sz, size))
+		if (check_add_overflow(*size, ace_sz, size)) {
+			kfree(sid);
 			break;
+		}
 		(*num_aces)++;
 		if (pace->e_tag == ACL_USER)
 			ntace->access_req |=
@@ -655,8 +657,10 @@ static void set_posix_acl_entries_dacl(s
 			ntace = (struct smb_ace *)((char *)pndace + *size);
 			ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED,
 					0x03, pace->e_perm, 0777);
-			if (check_add_overflow(*size, ace_sz, size))
+			if (check_add_overflow(*size, ace_sz, size)) {
+				kfree(sid);
 				break;
+			}
 			(*num_aces)++;
 			if (pace->e_tag == ACL_USER)
 				ntace->access_req |=
@@ -698,8 +702,10 @@ posix_default_acl:
 		ntace = (struct smb_ace *)((char *)pndace + *size);
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, 0x0b,
 				pace->e_perm, 0777);
-		if (check_add_overflow(*size, ace_sz, size))
+		if (check_add_overflow(*size, ace_sz, size)) {
+			kfree(sid);
 			break;
+		}
 		(*num_aces)++;
 		if (pace->e_tag == ACL_USER)
 			ntace->access_req |=


