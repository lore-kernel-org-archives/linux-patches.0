Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FC9330B04;
	Fri, 17 Oct 2025 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716178; cv=none; b=IqcStgVkdwN+MdjWPUO1eX32i3UrIG/wygjZqWZ+N05qB8LtSGRdVTGZZONdl4toGfwSgeYp0VvDCBBHV+PSeCot9AtY8rOyv8BGc3defCV8YEBPUbf30EamljLDltThQYyru9yUoZ7/Iphps/OQCkfnYs0/CdoGagRBmvn/biw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716178; c=relaxed/simple;
	bh=HSbTm++3YfoDtobZio3duJ+lXAIRIdWtuEKDkOgt3gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSmoqurv7vnQGuVbJdPGudeIMtnIMMUJqzFpTrVpZlqgKXwXO00eOyyO+JAHGP/f9QbE2Gw6mtYAjWZM1sNzIOLyVTGn1mDLEsKcXquGmuAQkKJUSp95SLMKHrO3Sow4sr6PjosD+QTIygo9rdDrXrDh1eEol5FCea+kVQ4Brcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5Nc2Qhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5Nc2Qhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD059C4CEE7;
	Fri, 17 Oct 2025 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716178;
	bh=HSbTm++3YfoDtobZio3duJ+lXAIRIdWtuEKDkOgt3gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5Nc2QhzNLlybc1pQg+6e0AZv83OakF85jtttYO+45fRZeciV+uKznvI4avrTRuh8
	 +vbAgJaNZWdj1zuDQCuCXFgC6SxILanYrpOjpoW7v8g6Tc06CnzTemGa2QsiM4ZUf8
	 6x5Scv/eJ/jKVTtYJZwcNiERYdQydZoduBD3ELUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/276] hwrng: ks-sa - fix division by zero in ks_sa_rng_init
Date: Fri, 17 Oct 2025 16:53:13 +0200
Message-ID: <20251017145146.134446983@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2f2f21f1b659e..d7b42888f25c2 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -240,6 +240,10 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	ks_sa_rng->clk = devm_clk_get_enabled(dev, NULL);
+	if (IS_ERR(ks_sa_rng->clk))
+		return dev_err_probe(dev, PTR_ERR(ks_sa_rng->clk), "Failed to get clock\n");
+
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-- 
2.51.0



