Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CD134404F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301629; cv=none; b=h1BpuJeZ94L6/EMF2aYRq3xvXzqn/z/7I5BYhmmCCf+lzoooPAhcCvptMfgYpoYzyBi7B0Gy/Pjd58MwjWJbua48/Xy35pY0A+vHYLBqpUKkI2C+mr7rQiUvYviry94nNqfMuHXfV/aetSh2X2nNtc/wUyxI20uWjBj3Rr3JmAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301629; c=relaxed/simple;
	bh=VaZnK+z7KiNdnZ1qgJyaddTkDMZN3V12anOZbpeB/LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2bRF51pxwYM50PytMovasjAxPSrjnNtDIqZJGGS6UbrmQFFdGLhd4K8lteA9Y+5Itxhe9Y/uz/aqkdP0V5010TKvuRXifkjwTjtKPss19mVQ361+nAfnte8qzPrMaB8Us4N5NtGw3pYUWaO8H1Ed8WiUqZEH9WFB9TU75utKio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRAohyLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRAohyLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2774C116D0;
	Sat, 28 Feb 2026 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301629;
	bh=VaZnK+z7KiNdnZ1qgJyaddTkDMZN3V12anOZbpeB/LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRAohyLbQJWOZYtPAp1Zt+28Uv0m49hAeboceA5avp4/WmGZQMVODD2i2VJQIXMKo
	 mEMGJuH9rvUoT41FFaXQvv3PpfFK1Sgh0QZgF+ckOcfW7YVi+Fh5+SwxbMDLZDO3iB
	 oEXB2MuTRCmdOLjToQr/zRJPE8/brMYWZhhpbaVG32e/akxVfUP2xhMpuC0URsXf77
	 XJZtWKxO9Ax514+XP0FB2gdap3EjgVugmPkqG/8+mZ6JCLVfMqhC1GUDfaZrOAEa5a
	 5TlYUjpatIXWJDVbvUscPQeBY7BIP9UGmQnUC9tJxklxBpOw/Vx+GgohDnhN2p3xUa
	 miFjL80YXXKHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/385] btrfs: qgroup: return correct error when deleting qgroup relation item
Date: Sat, 28 Feb 2026 12:54:03 -0500
Message-ID: <20260228180011.1568201-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 51b1fcf71c88c3c89e7dcf07869c5de837b1f428 ]

If we fail to delete the second qgroup relation item, we end up returning
success or -ENOENT in case the first item does not exist, instead of
returning the error from the second item deletion.

Fixes: 73798c465b66 ("btrfs: qgroup: Try our best to delete qgroup relations")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 029017afaf344..4df0ba100f9de 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1673,8 +1673,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	if (ret < 0 && ret != -ENOENT)
 		goto out;
 	ret2 = del_qgroup_relation_item(trans, dst, src);
-	if (ret2 < 0 && ret2 != -ENOENT)
+	if (ret2 < 0 && ret2 != -ENOENT) {
+		ret = ret2;
 		goto out;
+	}
 
 	/* At least one deletion succeeded, return 0 */
 	if (!ret || !ret2)
-- 
2.51.0

