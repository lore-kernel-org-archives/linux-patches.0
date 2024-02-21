Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5BE69D38;
	Wed, 21 Feb 2024 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525022; cv=none; b=dzHfOvr0dIUUH4igeQ/uazoLXLQfEFp0TpPD0l4Cx6uTlzdDj8KiPSqpXYSCvSXo8hmIcbSa8K+i/zPlB28EO/wZ47YF9XkdqJqZLIiW4EGghQPFN0KnJc7AeDkLOM0PRa/orR17Q3N10eKquNXAB5RSqfDJenWwW+jV9dYsqAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525022; c=relaxed/simple;
	bh=QZSFHEQq13aKVCkhyxgqpopDNdgSDnoR9PGQxabO6Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OASQTpxXJ9QuKf5/73tzxk5Kt5C0LAxt3uZ4V5Tb4mIkIYDL4DJQBM5x9VOijUxRXzlut6jH3JmAMH4jBwTIOm38nVARunwsG273AXzMP+Pa4svY0KBGRlnFpvzxGZmoUmWHFVJSE37t8y/M7UN7Qbk+yYnJRCAEmSut87459Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRhgxT3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRhgxT3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6C6C433F1;
	Wed, 21 Feb 2024 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525022;
	bh=QZSFHEQq13aKVCkhyxgqpopDNdgSDnoR9PGQxabO6Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRhgxT3BBXUV/EqdiNaLhgB1tE/aDth4vwdAVfaEiQg41BXM4EBMh6PflykG92HmS
	 CBjs/Mq2JNp92sm1Q0y8F2v3a91gb2SvYuSnDANxnLqBn+FRcLSzf2inVUvNH7l9NW
	 /YWqKnCNd7sFWk2TVfcLg53XuvfKsUAEmEEbsSZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Efremov <efremov@linux.com>,
	Saeed Mahameed <saeedm@mellanox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/267] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
Date: Wed, 21 Feb 2024 14:06:17 +0100
Message-ID: <20240221125941.161295325@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov <efremov@linux.com>

[ Upstream commit 360000b26e37a75b3000bf0585b263809d96ffd3 ]

Use kfree() instead of kvfree() on ft->g in arfs_create_groups() because
the memory is allocated with kcalloc().

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Stable-dep-of: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 2c75b2752f58..b75074d8d22b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -229,7 +229,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 			sizeof(*ft->g), GFP_KERNEL);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
-		kvfree(ft->g);
+		kfree(ft->g);
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.43.0



