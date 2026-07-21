Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155D93B0AC6;
	Tue, 21 Jul 2026 20:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666812; cv=none; b=O0FhRnCt3cjfeVenDB+O31sOT50ddJQK2w9S0qHfBz0dCBpAt2uBj7UzwbL8ODofDQNJiFxXMM3tKBhbp/freh6mK8ngCOmiqPdCI2UpwqjQNvwxOVvELRT1JAmxQpJFnoQnD+Uu3uhG1cNAPyfAhDp9s4zOsUU5cOZuryjoBJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666812; c=relaxed/simple;
	bh=1ywbwLgaxtp4qZ6ZjuHATXNlQcJ2IehMr4nyOt1y+Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApHURKa0u2mhmwlCyr9XHvAAMvE+9ufeC73V1YG8FVXYi49bCLiJX5GzzYd/Y+QRMTIdbds4pMa0BPs58wdXcBYm0AhmA/JRXpaxiU3GMxLieAKcH4UAINR55zDto0zAKSX40PaM//Q3U5StqPy87RVTuGXWF3Wv6mneP8WmvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8/XvbD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8/XvbD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4249C1F000E9;
	Tue, 21 Jul 2026 20:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666810;
	bh=438fkMEYp0MmKccwXQ+1uJ+IKFVQeJGChqzAZqPMYmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8/XvbD+I9su7mH+cDdD7k+X6KkZX9hpQN4ZoR8nCyxLu7hcNLGrMN1hCevSvODiR
	 /BzHD2zzOD/yVST4YCAOedGXD8nAaqgsS9oJTVmaiYDpMn9RVhrOWJudEwH/LdDW0P
	 xz8iOm3Ixn4rl88lhJNpHeIzA9Ac+dBL+6ARHHKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0822/1266] ksmbd: reject undersized DACLs before parsing ACEs
Date: Tue, 21 Jul 2026 17:20:59 +0200
Message-ID: <20260721152500.252217059@linuxfoundation.org>
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
index cd6c72fa1960c4..420d4e0733e5f1 100644
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



