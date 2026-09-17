Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE65949D58C;
	Thu, 17 Sep 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667832; cv=none; b=oBbPL34DWtaQQ/ES/CUMO2l1KES7FrzCZNyzpnsdpHz5WCRWe6mIp6N9rUEaJRPSOPO3SpPfXvtR4X3V0hG6NaVwTUZiMBZxoX7AQRcGPU1u2QZ3Zu1a9In0+MI4y5oFJVddirxjnvL15TR836jpwtZpgY/En8SHICerPQ6cIC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667832; c=relaxed/simple;
	bh=rTTX3CPTti3wdHcRiDUuyXYkIMP+39wdADoIS/KSRE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDbMX5ICJDvQOI3laAHgQ8drQ7wAnbdEq2dzdDWBOjCcJWrAzH0pMBCsQypUt12EDwXcaV44U+oDLvFD/g73znCXuM1Z1SUYWH6+tdxeTRYHTzZQDL5pPIcCNeZwa+im7N2RTZmMPp3vSQivUTJzoeSw04e1mjpLiCXvlv2NJ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtgdG+q9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtgdG+q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDD81F000FF;
	Thu, 17 Sep 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667831;
	bh=Y+NQmYbKKgf6gs8L2Qqp3ojzx6F4WkYCelSh4dVDBlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtgdG+q9HtpWunGwL4uLSdpTgTeKVlUYZC/AzLpC33d77U+EMtufSMpNtrqq/7fSb
	 pJDoMrU42JxHDH9zZcFB6z22HzwPgEzqhDi78I93SY2tmv97JUlcgFZt7p002AIrPo
	 cq8qKWVzAN9zc7CftzejYpPnS88QTilwb7rZBda8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0225/1102] net/mlx5e: Verify unique vhca_id count instead of range
Date: Thu, 17 Sep 2026 16:02:48 +0100
Message-ID: <20260917151545.229093833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 0b1c4495aa007932e9cbd7b45a8037e7b4fe34b0 ]

Change verify_num_vhca_ids() to count the number of unique vhca_ids
and verify this count doesn't exceed max_num_vhca_id, rather than
validating individual vhca_id values are within a specific range.

The previous implementation checked if each vhca_id was in the range
[0, max_num_vhca_id - 1], which is overly restrictive. The hardware
capability max_rqt_vhca_id represents the maximum number of unique
vhca_ids that can be used, not a range constraint on individual IDs.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260531113954.395443-14-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/rqt.c  | 27 ++++++++++++++-----
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
index 8d9a3b5ec973b..c845ed8f9ebfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
@@ -8,13 +8,28 @@ static bool verify_num_vhca_ids(struct mlx5_core_dev *mdev, u32 *vhca_ids,
 				unsigned int size)
 {
 	unsigned int max_num_vhca_id = MLX5_CAP_GEN_2(mdev, max_rqt_vhca_id);
-	int i;
+	unsigned int unique_count = 0;
+	int i, j;
+
+	/* Count unique vhca_ids */
+	for (i = 0; i < size; i++) {
+		bool is_unique = true;
+
+		/* Check if vhca_ids[i] was already seen */
+		for (j = 0; j < i; j++) {
+			if (vhca_ids[j] == vhca_ids[i]) {
+				is_unique = false;
+				break;
+			}
+		}
+		if (is_unique)
+			unique_count++;
+	}
 
-	/* Verify that all vhca_ids are in range [0, max_num_vhca_ids - 1] */
-	for (i = 0; i < size; i++)
-		if (vhca_ids[i] >= max_num_vhca_id)
-			return false;
-	return true;
+	/* Verify that number of unique vhca_ids doesn't exceed
+	 * max_num_vhca_id
+	 */
+	return unique_count <= max_num_vhca_id;
 }
 
 static bool rqt_verify_vhca_ids(struct mlx5_core_dev *mdev, u32 *vhca_ids,
-- 
2.53.0



