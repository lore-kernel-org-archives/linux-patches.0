Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5325D1DA60B;
	Mon,  6 Jan 2025 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179219; cv=none; b=NBbHDWq+Dk5HM1H1jtxmORJcmRaX/GIQmvoGfrHnDtsjRuw2ZF5RpLwiRlBGw+8OK91DRA0aKPEITYBrTFAzIcRGIUn8aHAuIAcF1bkK8HkaQ3v4PJ4qjbmg1f0Jp57uNvww56kRYeCGGLEUHsfNlDb8V/54pLhbssfEFbDB6aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179219; c=relaxed/simple;
	bh=zoHGGAQlsYmwpz1tGPZjKJuIF8WzITW2/JT+xyt4uu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntVUdBZVoZ94zP/taAgBERY4SjjCd0rNojJNLGj04OEHXuS1jgFbaqEk29Z9/LgHvCjdJHSTtrkZEgNvtN4lCC0TwhMm8ARK6dtYHCIQlZoOpJW1mGOHMA7DjtT+aU7rP7bA8S/hnT/SoZEehkjK/CcJnQYVhQELYD97THHBTdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wl5awdd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wl5awdd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E3CC4CED2;
	Mon,  6 Jan 2025 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179219;
	bh=zoHGGAQlsYmwpz1tGPZjKJuIF8WzITW2/JT+xyt4uu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wl5awdd7LReM+2hi5MgHnyMtf85gtkhI0LMIrIaQJgLWfkGaQPYnuWF9/A9LK3oTU
	 Go7W7ziCPUqVk6VzzzDwUlcCoTlTiNLSNzdsZPa+UqfpFUjBuQo8MtAWAXbJnTUdKz
	 bhkqjKwHpGHf1S6Ru44+hOFBSbPgsqbTfiJQ5JoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 66/93] RDMA/mlx5: Enforce same type port association for multiport RoCE
Date: Mon,  6 Jan 2025 16:17:42 +0100
Message-ID: <20250106151131.195024699@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit e05feab22fd7dabcd6d272c4e2401ec1acdfdb9b ]

Different core device types such as PFs and VFs shouldn't be affiliated
together since they have different capabilities, fix that by enforcing
type check before doing the affiliation.

Fixes: 32f69e4be269 ("{net, IB}/mlx5: Manage port association for multiport RoCE")
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://patch.msgid.link/88699500f690dff1c1852c1ddb71f8a1cc8b956e.1733233480.git.leonro@nvidia.com
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 6 ++++--
 include/linux/mlx5/driver.h       | 6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5e00acb9bb31..fb5a1b4abcbc 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5980,7 +5980,8 @@ static int mlx5_ib_init_multiport_master(struct mlx5_ib_dev *dev)
 		list_for_each_entry(mpi, &mlx5_ib_unaffiliated_port_list,
 				    list) {
 			if (dev->sys_image_guid == mpi->sys_image_guid &&
-			    (mlx5_core_native_port_num(mpi->mdev) - 1) == i) {
+			    (mlx5_core_native_port_num(mpi->mdev) - 1) == i &&
+			    mlx5_core_same_coredev_type(dev->mdev, mpi->mdev)) {
 				bound = mlx5_ib_bind_slave_port(dev, mpi);
 			}
 
@@ -6874,7 +6875,8 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev)
 
 	mutex_lock(&mlx5_ib_multiport_mutex);
 	list_for_each_entry(dev, &mlx5_ib_dev_list, ib_dev_list) {
-		if (dev->sys_image_guid == mpi->sys_image_guid)
+		if (dev->sys_image_guid == mpi->sys_image_guid &&
+		    mlx5_core_same_coredev_type(dev->mdev, mpi->mdev))
 			bound = mlx5_ib_bind_slave_port(dev, mpi);
 
 		if (bound) {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 882197037654..ddcbc910d909 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1137,6 +1137,12 @@ static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
 	return dev->coredev_type == MLX5_COREDEV_VF;
 }
 
+static inline bool mlx5_core_same_coredev_type(const struct mlx5_core_dev *dev1,
+					       const struct mlx5_core_dev *dev2)
+{
+	return dev1->coredev_type == dev2->coredev_type;
+}
+
 static inline bool mlx5_core_is_ecpf(const struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
-- 
2.39.5



