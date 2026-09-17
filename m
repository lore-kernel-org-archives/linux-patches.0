Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE755172ED;
	Thu, 17 Sep 2026 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664286; cv=none; b=gmC+dFv4yKI6qx0/8hJqrOBsKSi1/37WNMOGdMAo3UthEOngootQGQHjZ7ZP7V6aZ8zHmyzrYC0OPFbrmnmWrzVhOz+YX5VD//u5qnfBoeJHYPcUTFOFCR2ry7wo67XjTrnJoBevi9oKS7gK7c5AqWYIcAWw8pXeCfrP6JB6b9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664286; c=relaxed/simple;
	bh=CDow917Rt2MyaWjgj4y/SHrOd6U1jxW8Wpd8Do1S0dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ejt8P3gYa6MmTEp/eQYLkAvYJAe/W1kRD6GdDofhNaB8SprKs3hb5vDWkZsflDUbT27q1psri0U8QUYo1Jx0MXzTVXna4XqJY0ynnY2wC/L2ISyxEqNJrVwWK5O7HjsgcTbAAWQRcs19oO9ruRh/zEnKJVEACvG/iCeZWesJZcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTDSnN8k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTDSnN8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8401F00899;
	Thu, 17 Sep 2026 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664285;
	bh=StwnKHbXJYBULfBrZToQG8LA2aCL6ym8SPTcxXZS07w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTDSnN8kJi/iZquI2NnS+rjUYVoZxyO1OlzNjRg2+SiyqufAHWMGCdoKOyqUSNq7T
	 kG89DD0jlekSTTKgZh1rLbfrFm2Y8992Vh2WSNqoPyTYIAzfYpKSVKANiLvc3B4d+n
	 oaqr3FhIJoBIKh6kAGo1xGNQMNeHmGF4itTOar/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0321/1250] net/mlx5e: Verify unique vhca_id count instead of range
Date: Thu, 17 Sep 2026 16:01:56 +0100
Message-ID: <20260917151600.799832242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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



