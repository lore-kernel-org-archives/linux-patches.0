Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08A13537DF;
	Fri, 24 Apr 2026 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038153; cv=none; b=EP9vEi3nVNoonSmTXXvfACEIbU7NDFIgrlYyS+9tK4jVaHmlnzGx4E1Hw8Vq29CqjTBOlf8qW9BBBIuPFAoIxKqqexO2is/oKhEoqwSQXFv8rJHGGTDfbav1Lm9CcGOrWt1sQuZfOoww6FNYLdf1Bmgw7a5qXyhOXSZGAEvKCNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038153; c=relaxed/simple;
	bh=2xnFGBNalMVhKeld9z2uTo7Q/dp8Hmk0NEbBEOZFkA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxkhGAqKRQZsZ3o5RKSpWs76ibnp/wQ6PEwnqGI0j+vXqqVx6sBtpjZ8APebMrF6DZWIwUvukw7WH5dHN5MPFPP1aV+1jDtKwVXKB1MuWTuy+z+XoWi7DfCpOnuVCRRWB81bvfQ45jrid0YTb73fW86zNG2CZcZ3tmSwZZSlVjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFOVbRDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFOVbRDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F08C19425;
	Fri, 24 Apr 2026 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038153;
	bh=2xnFGBNalMVhKeld9z2uTo7Q/dp8Hmk0NEbBEOZFkA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFOVbRDsD8Sseq+76u20WYj6y2uGE8AkxqkYtfd+IcMKEIiuL/bfvfRozhueQuoCp
	 UwMqBTadRMjp5u38eUd7VKEEYeyGc7JFFlw5qmM6OHUHiBzvSKiRpz5wi1rlgV0pti
	 v0MzSc38bRxmx/eOZLNCYZjWgrF+ZuPl+Hyy/sig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 44/55] ksmbd: use check_add_overflow() to prevent u16 DACL size overflow
Date: Fri, 24 Apr 2026 15:31:23 +0200
Message-ID: <20260424132439.186781723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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
@@ -728,7 +735,8 @@ static void set_ntacl_dacl(struct mnt_id
 				break;
 
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
-			size += nt_ace_size;
+			if (check_add_overflow(size, nt_ace_size, &size))
+				break;
 			aces_size -= nt_ace_size;
 			ntace = (struct smb_ace *)((char *)ntace + nt_ace_size);
 			num_aces++;


