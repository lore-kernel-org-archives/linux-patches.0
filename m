Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CBA1E98E3;
	Sun,  7 Jun 2026 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830156; cv=none; b=uSp/HCRWX/j8+B+Z74MGK6vEVu7yiRVEMTSm4GPvQ+j3vCrAIN0bf65E5QeG7WZTuVWrV1K68Ml3Ps3Vz2pr09q0KFZQCdCyRQlkQw+52RGbUVpH0XfMdWxU5E2NQb3voEIlXVTGcevXit/q9wybUqRwNdA2LI6p/hRjunwWUus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830156; c=relaxed/simple;
	bh=yQudyhAqKS02hrdiBIwqFxJTKpxNcHbioWc9T/mKbpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxPvUn0DhpGQz0xURwRLzU49Ds4u2hTB/s6pqZ9bLfm+qA0SvVENott8Qhj9TDGPWsb+EiBpVJgymvd1LveK+2kBIQDDX4wgUmvmL6FVHFanN3PC67+CaGrUOIljCs++pij3qF/T3k1A7QOtFjeDvWYbkMKCXjO0iLLh/emvRS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFEpcdld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFEpcdld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A050E1F00893;
	Sun,  7 Jun 2026 11:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830155;
	bh=KY7WZoqpnOXRm4oC2twvWevNb8qM86xpBeo2elnNG9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFEpcdld6IHRbbWfEZdJtCDeGz9k6StY6JCN86h6nmY964040syi9aiRxKE5HY/qd
	 K2E9a/XeF/Kd/aVi/XoeWMEhaK35P3e+mNnXrZW1O0ks/XsfSAt+LDqMGE7Inj8Dbz
	 3hSuOQfscTq0whEBgNhxDgkrtVXLEuO3SY2B+uMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Sachidanand <sauravsc@amazon.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 326/332] i2c: tegra: make tegra_i2c_mutex_unlock() return void
Date: Sun,  7 Jun 2026 12:01:35 +0200
Message-ID: <20260607095740.107078591@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Sachidanand <sauravsc@amazon.com>

[ Upstream commit 30792d12842901f5276f466a960962d5bfa15cc8 ]

tegra_i2c_mutex_unlock() returning an error that overwrites the transfer
result causes silent loss of I2C transfer errors. If the transfer failed
but the unlock succeeded, the error was lost and the function incorrectly
reported success.

Rather than propagating the unlock error (which is not actionable by the
caller - the I2C message may have been sent regardless), convert the
function to return void and WARN on the unexpected condition. If the
unlock fails, subsequent lock attempts will fail anyway, making the error
visible on the next transfer.

Fixes: 6077cfd716fb ("i2c: tegra: Add support for SW mutex register")
Signed-off-by: Saurav Sachidanand <sauravsc@amazon.com>
Cc: <stable@vger.kernel.org> # v7.0+
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260507221145.62183-3-sauravsc@amazon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-tegra.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -445,25 +445,22 @@ static int tegra_i2c_mutex_lock(struct t
 	return ret;
 }
 
-static int tegra_i2c_mutex_unlock(struct tegra_i2c_dev *i2c_dev)
+static void tegra_i2c_mutex_unlock(struct tegra_i2c_dev *i2c_dev)
 {
 	unsigned int reg = tegra_i2c_reg_addr(i2c_dev, I2C_SW_MUTEX);
 	u32 val, id;
 
 	if (!i2c_dev->hw->has_mutex)
-		return 0;
+		return;
 
 	val = readl(i2c_dev->base + reg);
 
 	id = FIELD_GET(I2C_SW_MUTEX_GRANT, val);
-	if (id && id != I2C_SW_MUTEX_ID_CCPLEX) {
-		dev_warn(i2c_dev->dev, "unable to unlock mutex, mutex is owned by: %u\n", id);
-		return -EPERM;
-	}
+	if (WARN(id && id != I2C_SW_MUTEX_ID_CCPLEX,
+		 "unable to unlock mutex, mutex is owned by: %u\n", id))
+		return;
 
 	writel(0, i2c_dev->base + reg);
-
-	return 0;
 }
 
 static void tegra_i2c_mask_irq(struct tegra_i2c_dev *i2c_dev, u32 mask)
@@ -1556,7 +1553,7 @@ static int tegra_i2c_xfer(struct i2c_ada
 			break;
 	}
 
-	ret = tegra_i2c_mutex_unlock(i2c_dev);
+	tegra_i2c_mutex_unlock(i2c_dev);
 	pm_runtime_put(i2c_dev->dev);
 
 	return ret ?: i;


