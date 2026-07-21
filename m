Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E083646D08A;
	Tue, 21 Jul 2026 18:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658036; cv=none; b=dxN8tfUmvpshbG9QGhKaLZT+SVkVFEKLT3EdnjicXbDijUJkG5iw1B2+APEY0k+gnZijEpghqHFCyTWiNp8B77VPAoVfKr4uPcPdlb3rpNYYOrkP9K+5ZmWLJorJ6l5lNtuUNcRTQNPLjZ41hOE98Q2jzAf43kYlwh6nKecJV/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658036; c=relaxed/simple;
	bh=5XZsV/byJaSK4vRVsaOioNUXKlwvfMqmyJlDEFS3XrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlWO93PBAv4DKOzYI3az8W6xo1rqqbseEdzQm+BiARAzF3O/t5QEvSEBMuv/Q9wub6W+0l9gGOwrA++NVsFWWVvowgoKaDuJR0ni29KNJWjHgPB34ZXky5UP7LL+DfMW9u3bPgUhUhjFE2stZF/HWwgKLxK9Sn40rJXxfdD12xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CH6W9T7G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CH6W9T7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D66D1F000E9;
	Tue, 21 Jul 2026 18:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658034;
	bh=N58fbumthOLLA6dS/svQARN0n6GVG2Cgpacj4bdr4uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CH6W9T7GvkseTghunjT266Vzvi6k3Gwa2wAPm1Fejvy+hyFzjyM8ehY+ed4h3dGgt
	 JSEo/NwCOFWbRI9gDoQLTxKYdKZObpYKNFWTQT1Euh4suOp4H5g+jzNbKN6B85oPPG
	 XJrR9HQDhH3o+Z//2YvYy05dvfWMBM1YVi185T7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0992/1611] ksmbd: reject undersized DACLs before parsing ACEs
Date: Tue, 21 Jul 2026 17:18:28 +0200
Message-ID: <20260721152537.704470403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Haofeng Li <lihaofeng@kylinos.cn>

[ Upstream commit 60908f7ebcd9b6cde74ad5711fab0f49c7970949 ]

parse_dacl() limits the attacker-controlled ACE count by comparing it
with the number of minimal ACEs that fit in the DACL size. The DACL size
field is 16 bits, but the expression subtracts sizeof(struct smb_acl).
Because sizeof() is unsigned, a DACL size smaller than the ACL header
underflows to a large size_t.

A malicious client can reach this with:

SMB2_SET_INFO (InfoType=SMB2_O_INFO_SECURITY)
  -> smb2_set_info_sec()
  -> set_info_sec()
  -> parse_sec_desc()
  -> parse_dacl()
     -> init_acl_state(..., 0xffff)
     -> init_acl_state(..., 0xffff)
     -> kmalloc_objs(..., 0xffff)

Thus a malformed security descriptor can make num_aces pass the guard
and drive large temporary ACL state and pointer-array allocations.

Reject DACLs smaller than struct smb_acl before doing the subtraction,
so the ACE count check cannot be bypassed by the underflow.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index f5864dd1dd5f1d..b09bc8d9389a2a 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -374,6 +374,7 @@ static void parse_dacl(struct mnt_idmap *idmap,
 {
 	int i, ret;
 	u16 num_aces = 0;
+	u16 dacl_size;
 	unsigned int acl_size;
 	char *acl_base;
 	struct smb_ace **ppace;
@@ -403,7 +404,11 @@ static void parse_dacl(struct mnt_idmap *idmap,
 	if (num_aces <= 0)
 		return;
 
-	if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
+	dacl_size = le16_to_cpu(pdacl->size);
+	if (dacl_size < sizeof(struct smb_acl))
+		return;
+
+	if (num_aces > (dacl_size - sizeof(struct smb_acl)) /
 			(offsetof(struct smb_ace, sid) +
 			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 		return;
-- 
2.53.0



