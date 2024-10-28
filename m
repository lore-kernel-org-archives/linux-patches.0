Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F392E18A922;
	Mon, 28 Oct 2024 06:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098187; cv=none; b=hdXY7gZ2EFbriLWeRR4UeR3UxHWPgB0X7IpgvihJcDJLFK+HgVtqHzz07fxEvho3NmCCA47lQbRL7S+4m7RqxhfTSh72gwLVKtAgDSlF38k1l9sN3ayxf/E0+rsbm2AehKyCBunPL6kSEY2aRbg1IbDEZnuFaD2uzGICL1WF2UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098187; c=relaxed/simple;
	bh=CbgIcgyhUDY49IDNYM0cT5k7Rp43ZyN/Lvz5oTzT9Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWcU57B6DlDw9/5r2yfaaJnSoiP0fKK6OJztkFo2ESjf+GBaRw5FdYQ13XhPXRPRP6wCOuI2kWy7CUoWWPBrArWo+Q8imBwvRcY2isa88bEak1MlhcbZFUhvBqvdd3p5McnV63L7z/Fi+lHJX9ut9qUlm3b8PLXwJ+n547c4K8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pv6h0zeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pv6h0zeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B45C4CEC3;
	Mon, 28 Oct 2024 06:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098186;
	bh=CbgIcgyhUDY49IDNYM0cT5k7Rp43ZyN/Lvz5oTzT9Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pv6h0zeVAyUIGvm4Aoh2FV6mUJsoa3FKaJFV4jGoDG/sNJPx9TJCpA/S7Or0dMB9e
	 2nk6lvTEsNZma8i9bAnqSWW5SaHVflCN2FxbEPDp0YW3cvcTn+lnxq4Vc0liTqfUnk
	 /CtY0py4F1OdDccI91IFjnQfEAD4CguwTCUZhiUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 098/261] net/mlx5: Check for invalid vector index on EQ creation
Date: Mon, 28 Oct 2024 07:24:00 +0100
Message-ID: <20241028062314.486835281@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit d4f25be27e3ef7e23998fbd3dd4bff0602de7ae5 ]

Currently, mlx5 driver does not enforce vector index to be lower than
the maximum number of supported completion vectors when requesting a
new completion EQ. Thus, mlx5_comp_eqn_get() fails when trying to
acquire an IRQ with an improper vector index.

To prevent the case above, enforce that vector index value is
valid and lower than maximum in mlx5_comp_eqn_get() before handling the
request.

Fixes: f14c1a14e632 ("net/mlx5: Allocate completion EQs dynamically")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index cb7e7e4104aff..99d9e8863bfd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1080,6 +1080,12 @@ int mlx5_comp_eqn_get(struct mlx5_core_dev *dev, u16 vecidx, int *eqn)
 	struct mlx5_eq_comp *eq;
 	int ret = 0;
 
+	if (vecidx >= table->max_comp_eqs) {
+		mlx5_core_dbg(dev, "Requested vector index %u should be less than %u",
+			      vecidx, table->max_comp_eqs);
+		return -EINVAL;
+	}
+
 	mutex_lock(&table->comp_lock);
 	eq = xa_load(&table->comp_eqs, vecidx);
 	if (eq) {
-- 
2.43.0



