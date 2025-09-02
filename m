Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4EC305E2D;
	Tue,  2 Sep 2025 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820427; cv=none; b=CokOIWkox6zhzcMtJq+BPhW1CMzkqoKWOCw7ItZ2eCoDP7PNcwTXuEQ1fKOyGyhWljA2MHrNHsoGwmfunKKOneWylMbbaKO2Fpifhy81lerpvwx/MmnzMGMJKn0F/6s3p1eFa7W58FJqC2TIMJ6m/AEZ0jyDRCT/Cz+fWQ/L65w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820427; c=relaxed/simple;
	bh=8x/OQOHJNzVgZ+EbR6n3Aa4nQyvcuXX34ctsAsMIyhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkjlN0Ogp99h5G9QO2b2zwFcCQlQUhldb6/0EanyL9I+lFKtyBcW0Rumg3vGrGis9cmljZhP6Ed91vSuAcnVSIhML1a8QsVd2jSj96hJYFNyA81opC+8BfoaHCDNauFVGOrx9XndpyTn4Xx/nbV04SaWMF3iuyfO/D1gcTwZ5iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGc5igv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGc5igv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9957DC4CEED;
	Tue,  2 Sep 2025 13:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820427;
	bh=8x/OQOHJNzVgZ+EbR6n3Aa4nQyvcuXX34ctsAsMIyhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGc5igv97WlmK6bkVob9Y/835MK7H/1r03VwA2aOosEzKKUDw0ePjJRk0jK2bAtOx
	 dfLtlqwvP+W4FcXxVW8eyTHDhuoRBD6bxEupZwXSK66myqfiRKsxWDcemaFuvelVhc
	 yVC0oK6EHxbSRCk4RxERVxlZIMpNd33sBSJuOkZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/50] net/mlx5: Reload auxiliary drivers on fw_activate
Date: Tue,  2 Sep 2025 15:21:16 +0200
Message-ID: <20250902131931.524754538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 34cc6a54914f478c93e176450fae6313404f9f74 ]

The devlink reload fw_activate command performs firmware activation
followed by driver reload, while devlink reload driver_reinit triggers
only driver reload. However, the driver reload logic differs between the
two modes, as on driver_reinit mode mlx5 also reloads auxiliary drivers,
while in fw_activate mode the auxiliary drivers are suspended where
applicable.

Additionally, following the cited commit, if the device has multiple PFs,
the behavior during fw_activate may vary between PFs: one PF may suspend
auxiliary drivers, while another reloads them.

Align devlink dev reload fw_activate behavior with devlink dev reload
driver_reinit, to reload all auxiliary drivers.

Fixes: 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in case of PCI device suspend")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-6-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 3749eb83d9e53..64dcfac9ce724 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -108,7 +108,7 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	if (err)
 		return err;
 
-	mlx5_unload_one_devl_locked(dev, true);
+	mlx5_unload_one_devl_locked(dev, false);
 	err = mlx5_health_wait_pci_up(dev);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "FW activate aborted, PCI reads fail after reset");
-- 
2.50.1



