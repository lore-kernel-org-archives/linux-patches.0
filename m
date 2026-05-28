Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1E5282F17;
	Thu, 28 May 2026 20:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999334; cv=none; b=EsFO2HTeEYeQGA+UQLzRITpIDT9R+sZJByf2y5oixe3Wk6WYRh7Xuebe+6Ihu14yX+T/F2xmw+GyoO/R22DYLiD9ZCo1PdEh+8nuVj4yFUMMdAVbMHvxnQRg1mKDz6Jkei71EYptHiHq2OO++GDmwRf7SLLqW2LoIkSUJmzJrlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999334; c=relaxed/simple;
	bh=b8aVmvjCLxtYQUTnOBYGGfQ/zRi+KSL2/Yl1hyld2HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/7LXlwBkyb5o/mF+Ta3p6UgqVc75lZRc4DT/YJOH2atCN3WvnNFQCUO9hc4PVnYujsAUK3iSdb7UknPZlkwn0kWbbrc7qf3kLfgfYLXYwis6GZYfQBSL4hU0bqhHSpG3C9W/Gj162ehEile6LKLtXx4p/cJjCnFCvM6RbAJM9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHQysBtM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHQysBtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751591F000E9;
	Thu, 28 May 2026 20:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999333;
	bh=BjV1DKFYxiCwBDgCaIVmQsHkjSsq2T1N8OSdabgUPbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHQysBtMWki/Ja/Dhr9RsNPeaCCi5mndap2pxrLzN6HbFbuXwKYjWsVGi2J0/dceF
	 clqkSVtE2JtOG+A6W5Ll3jNSZmBWjjQ4/36ZtMw2Hzsn+Br5eC/DKmQG1FVd2k5dQO
	 kLrfrhtFXfwEEW3NhRbT8dVrSIw31oiKtB8q66kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Meng <mengferry@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 029/377] ksmbd: fix SID memory leak in set_posix_acl_entries_dacl() on overflow
Date: Thu, 28 May 2026 21:44:27 +0200
Message-ID: <20260528194639.230031378@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


