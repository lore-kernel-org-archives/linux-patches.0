Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAF6309DB1;
	Mon, 13 Oct 2025 15:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370055; cv=none; b=aPeFJSzkdLCDLrBmGrmif3NyjDWeM/gHcTNvsjFQTC+j60qyiMSBMSJoB5YCgxsaSs3wCXugsBw26tU6L+d6Y4O65JKMBXj/g61GOtVQPAGegScI4o9oVL4uepA4lR3gFTn/s0+CS2wQ0SOFHpOX1U/K1x6IZxj611UJNC/Kti4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370055; c=relaxed/simple;
	bh=zPYV66mS7tlXCF7pzFMhB6IL8MR5DHrwhtND5FWHOvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prd8vAaaOrFygZEFrgbN45X1gFkqYi7xPf7QoJXedvCA+BrUsiE36RVSg4klRCnuiAYjebW6m8d9wimhqM7q+yVDXIpwY3utl9LbjHr0X/s8R1hmb1KCr6TZZWmGUXc6RolvsuNosJqadfMDAg+lqv8m3SOqyF7KIfDdwXqLkT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moGhovak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moGhovak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A532C4CEE7;
	Mon, 13 Oct 2025 15:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370055;
	bh=zPYV66mS7tlXCF7pzFMhB6IL8MR5DHrwhtND5FWHOvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moGhovakGqLWMOXaGGzm1Out98oNY+8heFmKkzWc1RDyijfVcZJeYxX7K7fV3rUQ/
	 6vP9PaN+B5NwQF+VGTxbTj2C7Q1jFnKe8szDgBUeck3ekHQmzxnXZDSGdTXt2YgqO5
	 aG+XbUDgH7nEwxctJjke2TzE6sN5J9kNFPo3ekGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 463/563] hwrng: ks-sa - fix division by zero in ks_sa_rng_init
Date: Mon, 13 Oct 2025 16:45:24 +0200
Message-ID: <20251013144428.056692839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 612b1dfeb414dfa780a6316014ceddf9a74ff5c0 ]

Fix division by zero in ks_sa_rng_init caused by missing clock
pointer initialization. The clk_get_rate() call is performed on
an uninitialized clk pointer, resulting in division by zero when
calculating delay values.

Add clock initialization code before using the clock.

Fixes: 6d01d8511dce ("hwrng: ks-sa - Add minimum sleep time before ready-polling")
Signed-off-by: Nishanth Menon <nm@ti.com>

 drivers/char/hw_random/ks-sa-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/ks-sa-rng.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index d8fd8a3544828..9e408144a10c1 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -231,6 +231,10 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(ks_sa_rng->regmap_cfg))
 		return dev_err_probe(dev, -EINVAL, "syscon_node_to_regmap failed\n");
 
+	ks_sa_rng->clk = devm_clk_get_enabled(dev, NULL);
+	if (IS_ERR(ks_sa_rng->clk))
+		return dev_err_probe(dev, PTR_ERR(ks_sa_rng->clk), "Failed to get clock\n");
+
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-- 
2.51.0



