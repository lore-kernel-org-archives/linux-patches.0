Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49AC1BDF1;
	Wed,  3 Jan 2024 17:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTco/nFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A49C433C8;
	Wed,  3 Jan 2024 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301363;
	bh=a1d6g6X/v/IC/xifijQ1GPOtqg4bxaZwsZ+mlKI9DKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTco/nFIJTbRbd5Qa4nzhBjjpqYoFbwgP0kRmbUKD63EEQY1yk9F3KaokbZrtOXqr
	 s2C5NK6buBayJ0QUTkOSU3aexY29XkEWSTiUX4Ov1xJv50HnTBbzPrijoxfbA2KKvn
	 HALiyHjiHwSa5bd++mUejWY3m++xym4VNOOM991o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/95] net/mlx5e: Correct snprintf truncation handling for fw_version buffer used by representors
Date: Wed,  3 Jan 2024 17:54:20 +0100
Message-ID: <20240103164855.959930175@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit b13559b76157de9d74f04d3ca0e49d69de3b5675 ]

snprintf returns the length of the formatted string, excluding the trailing
null, without accounting for truncation. This means that is the return
value is greater than or equal to the size parameter, the fw_version string
was truncated.

Link: https://docs.kernel.org/core-api/kernel-api.html#c.snprintf
Fixes: 1b2bd0c0264f ("net/mlx5e: Check return value of snprintf writing to fw_version buffer for representors")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 7a00faa62d993..de168d8cf33f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -73,7 +73,7 @@ static void mlx5e_rep_get_drvinfo(struct net_device *dev,
 	count = snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 			 "%d.%d.%04d (%.16s)", fw_rev_maj(mdev),
 			 fw_rev_min(mdev), fw_rev_sub(mdev), mdev->board_id);
-	if (count == sizeof(drvinfo->fw_version))
+	if (count >= sizeof(drvinfo->fw_version))
 		snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 			 "%d.%d.%04d", fw_rev_maj(mdev),
 			 fw_rev_min(mdev), fw_rev_sub(mdev));
-- 
2.43.0



