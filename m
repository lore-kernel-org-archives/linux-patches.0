Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D727332EA7;
	Sat, 30 May 2026 16:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159750; cv=none; b=QkC8pUlEuPcDstvFtCY0K+enFeNsENTQuNrK+zISMFbDisBaO3llhROybS1N07KXrBsXw26WWMzt74mxLt/HezMKBw/1WONDYFbu6l7YT1KuorzDlZOc7HqRCvQAfuoCSt6GBXRtCQMRqT7ghFripGmxyNjhuv2IzSiFfGzuIWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159750; c=relaxed/simple;
	bh=aA0kr3S/RcIwaF7Sd2KKy7QCTn4rIa/X6LDFRHki2ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJavq27Ab6RIOl35o2JwLzcGstUXPzC0cgyl5T2STC6qxvaZ1ghGvJnrY4WiIZt/ID88auN6BQqvNzAVySll41wDj2Q+ecvuMV0vbhUiEbknrB0Frk2AIuCCA0dTs4E9UJBiWvLbWNHzWleFeaaeFTM6PJ8zfgFBl9gf2EsP5hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJKxJOGu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJKxJOGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806B81F00893;
	Sat, 30 May 2026 16:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159749;
	bh=7egytk1miRcxqoz/0dSZma4HhKipi7UAALsGBm8NFO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJKxJOGuK0kFNRXiyVulKDcBcMR9+4KKs69LOkhvD+4vy5m139UJyT3+PpY4rZt5Q
	 7WQ5uBNBm8aKHdmS004Twpv3doVD8zCZ4kNkzxkzVAEANd+rpCKJLuyuUfWHqnFnUg
	 xqjVJ4FrvTIXIRDVDJJ3pbwfaJCte77ALfViko28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 151/969] ksmbd: use check_add_overflow() to prevent u16 DACL size overflow
Date: Sat, 30 May 2026 17:54:35 +0200
Message-ID: <20260530160304.717754465@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 299f962c0b02d048fb45d248b4da493d03f3175d upstream.

set_posix_acl_entries_dacl() and set_ntacl_dacl() accumulate ACE sizes
in u16 variables. When a file has many POSIX ACL entries, the
accumulated size can wrap past 65535, causing the pointer arithmetic
(char *)pndace + *size to land within already-written ACEs. Subsequent
writes then overwrite earlier entries, and pndacl->size gets a
truncated value.

Use check_add_overflow() at each accumulation point to detect the
wrap before it corrupts the buffer, consistent with existing
check_mul_overflow() usage elsewhere in smbacl.c.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -596,6 +596,7 @@ static void set_posix_acl_entries_dacl(s
 	struct smb_sid *sid;
 	struct smb_ace *ntace;
 	int i, j;
+	u16 ace_sz;
 
 	if (!fattr->cf_acls)
 		goto posix_default_acl;
@@ -640,8 +641,10 @@ static void set_posix_acl_entries_dacl(s
 			flags = 0x03;
 
 		ntace = (struct smb_ace *)((char *)pndace + *size);
-		*size += fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, flags,
+		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, flags,
 				pace->e_perm, 0777);
+		if (check_add_overflow(*size, ace_sz, size))
+			break;
 		(*num_aces)++;
 		if (pace->e_tag == ACL_USER)
 			ntace->access_req |=
@@ -650,8 +653,10 @@ static void set_posix_acl_entries_dacl(s
 		if (S_ISDIR(fattr->cf_mode) &&
 		    (pace->e_tag == ACL_USER || pace->e_tag == ACL_GROUP)) {
 			ntace = (struct smb_ace *)((char *)pndace + *size);
-			*size += fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED,
+			ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED,
 					0x03, pace->e_perm, 0777);
+			if (check_add_overflow(*size, ace_sz, size))
+				break;
 			(*num_aces)++;
 			if (pace->e_tag == ACL_USER)
 				ntace->access_req |=
@@ -691,8 +696,10 @@ posix_default_acl:
 		}
 
 		ntace = (struct smb_ace *)((char *)pndace + *size);
-		*size += fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, 0x0b,
+		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, 0x0b,
 				pace->e_perm, 0777);
+		if (check_add_overflow(*size, ace_sz, size))
+			break;
 		(*num_aces)++;
 		if (pace->e_tag == ACL_USER)
 			ntace->access_req |=
@@ -728,7 +735,8 @@ static void set_ntacl_dacl(struct user_n
 				break;
 
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
-			size += nt_ace_size;
+			if (check_add_overflow(size, nt_ace_size, &size))
+				break;
 			aces_size -= nt_ace_size;
 			ntace = (struct smb_ace *)((char *)ntace + nt_ace_size);
 			num_aces++;


