Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D7F26E6F4;
	Wed, 25 Feb 2026 01:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983587; cv=none; b=HeupnIOYFjcCCyxLnSbsmsocjaEbCjYh0kv4JE8SxOKB9kIfC/vIK3lolZuhDpCRItF5L99KRLwJ3KDhZjsiuh7fIlzar0VC/wfB26NZ6jzqgmKkyBX8w+At3i3WfpDd2B/cvJpmW91pn6vKt3zehHHxwjZ42GMp1ABQaxpdpes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983587; c=relaxed/simple;
	bh=CyltqcXjIMiIfskTzjmrf8IY8W8EddvQUUNE8QfW9rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJSnY3vHn/+60+9SOiDo3lrfiypvxh2uGHmv2pNLzrP7BlJZgOn+uvgrmIcU6t/uIdHoDrd4jjWZLoBQRxm1XCUEpMaL7AcwJDPsk3K5dkUWt8VKRTALk6cIv0rR22fqgQeMsWDNm8Iac4gfoOXILh8rOtn8Moe1jcoAKoV7VL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkwUXgHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkwUXgHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97470C116D0;
	Wed, 25 Feb 2026 01:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983586;
	bh=CyltqcXjIMiIfskTzjmrf8IY8W8EddvQUUNE8QfW9rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkwUXgHhbIb5wff+yD3cwmz+Q5HzcF5ta99SJ8/8Xp25inyRQRr/bukFzVRmP0yq2
	 7jIfp465uSHolWdww/0YqIGTFusH4OXcp7B2NXiefk8EFPJNEcw7FT+7qT9846cz87
	 NfVcZFApPyNXr+AmzRxbrMdGLmZSKxhOeE39KNaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jacob Keller <Jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 685/781] net/mlx5: Fix multiport device check over light SFs
Date: Tue, 24 Feb 2026 17:23:14 -0800
Message-ID: <20260225012416.574909661@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 47bf2e813817159f4d195be83a9b5a640ee6baec ]

Driver is using num_vhca_ports capability to distinguish between
multiport master device and multiport slave device. num_vhca_ports is a
capability the driver sets according to the MAX num_vhca_ports
capability reported by FW. On the other hand, light SFs doesn't set the
above capbility.

This leads to wrong results whenever light SFs is checking whether he is
a multiport master or slave.

Therefore, use the MAX capability to distinguish between master and
slave devices.

Fixes: e71383fb9cd1 ("net/mlx5: Light probe local SFs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <Jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260218072904.1764634-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/driver.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1c54aa6f74fbc..1967d1c79139b 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1281,12 +1281,12 @@ static inline bool mlx5_rl_is_supported(struct mlx5_core_dev *dev)
 static inline int mlx5_core_is_mp_slave(struct mlx5_core_dev *dev)
 {
 	return MLX5_CAP_GEN(dev, affiliate_nic_vport_criteria) &&
-	       MLX5_CAP_GEN(dev, num_vhca_ports) <= 1;
+	       MLX5_CAP_GEN_MAX(dev, num_vhca_ports) <= 1;
 }
 
 static inline int mlx5_core_is_mp_master(struct mlx5_core_dev *dev)
 {
-	return MLX5_CAP_GEN(dev, num_vhca_ports) > 1;
+	return MLX5_CAP_GEN_MAX(dev, num_vhca_ports) > 1;
 }
 
 static inline int mlx5_core_mp_enabled(struct mlx5_core_dev *dev)
-- 
2.51.0



