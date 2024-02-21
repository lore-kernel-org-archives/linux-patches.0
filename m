Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A13973161;
	Wed, 21 Feb 2024 13:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522140; cv=none; b=Hyv9qNF2e5SmvpfHdWRa6mXIer69k2Q6OBQX9Obd6cr+faQA/I4c+lpXs37dt+wl9XSsL2Y4wWrL/GMBdR0fdzcjgYXmkc0cITo+B9quyKppgP20hrMmPg1+qVO8hn5ZxfBV3FmE316WzZbCNbOkLU1tQzaLLZYIdg0Wsi1aGnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522140; c=relaxed/simple;
	bh=AsUr1qpPW/OWQBc1PV7+HxaVGMmW2DiV/OzzoNbGiSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cv2mhX0RwUtRIlfH1i0RV/6PeA9cYDAhEUZLs7s/+fmp0siXeXTE2BrOxJi3VvB3rKwau4ESiSZNHctBtSdmwsmJfCC2fmwh4KOfKGdA4Aq5W6IX4IvVz2HQkXuWREp9D7FsFBBCUbnvZeJOHFinheoefMON491iSNrFurBWKis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNw1P4Bk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNw1P4Bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEA7C433C7;
	Wed, 21 Feb 2024 13:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522140;
	bh=AsUr1qpPW/OWQBc1PV7+HxaVGMmW2DiV/OzzoNbGiSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNw1P4BkhpzpV7lRXMpCRsBg+ZVEi4ID923ibdYE4Ko0eZWoc+XVHWyRDoE/xYq3K
	 jtWzD3COSbwAeP4n7QPJGJpHDPjy1oJtQTf5IkNKGpccZUrDUoAKTo5Mls4BSZj9FP
	 WD5JVFrX48u+Xf1fQokyPpr7PI0mjJWurS5V2WBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/476] net/mlx5e: fix a potential double-free in fs_any_create_groups
Date: Wed, 21 Feb 2024 14:01:53 +0100
Message-ID: <20240221130010.224239262@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit aef855df7e1bbd5aa4484851561211500b22707e ]

When kcalloc() for ft->g succeeds but kvzalloc() for in fails,
fs_any_create_groups() will free ft->g. However, its caller
fs_any_create_table() will free ft->g again through calling
mlx5e_destroy_flow_table(), which will lead to a double-free.
Fix this by setting ft->g to NULL in fs_any_create_groups().

Fixes: 0f575c20bf06 ("net/mlx5e: Introduce Flow Steering ANY API")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
index b26edbc53cad..05905e988431 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
@@ -435,6 +435,7 @@ static int fs_any_create_groups(struct mlx5e_flow_table *ft)
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
 		kfree(ft->g);
+		ft->g = NULL;
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.43.0



