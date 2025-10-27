Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A07328639;
	Mon, 27 Oct 2025 18:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591133; cv=none; b=ifAjpPB/Xj59ObT6mRS7JaUlBJDK0eBJotZhMp/bhB6ll9Az7jF98O51aLXLqaTeDsc5Ced9IXNb7zouDWASnAP7xoF8cVwrgh4CGflckkKZENqQrdGVaWnco2wdizfJitg2Tvqa87G97M3d5kpu95XhgQ5AoEbJdiUKYFODRlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591133; c=relaxed/simple;
	bh=FI/fR5x5Hux4KWQtcc78ljw869A/ALsj0SgYiIEvseM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1Upt0pz9cDNtBrhW4jDkidX8oY9wk/JGQKA0+Z+EFmNcWxA5OSVuhfEOr6FjgJICpexpYBnnkYKetM4+EmRa4GGDcz4AXbCeVejZOGuyqjw48vyPGNzXxK0hV2jpKZHNutLsSt6/p5vnZ0+Agnk0Kuldb0NDk32LA5cTBFaWaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFx/PbUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFx/PbUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F61C4CEF1;
	Mon, 27 Oct 2025 18:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591133;
	bh=FI/fR5x5Hux4KWQtcc78ljw869A/ALsj0SgYiIEvseM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFx/PbUC6Rr2pl/fJK+t55NBLKtnWZpo2DD/GlqohkbRp9mjiFZC8Nwx3c9oWMdtN
	 WkC8ScMtSKfyAekxH8mxDQHfsTxYFLPmYwGcCPeFlprZ7Y6vjd4zmrjqlLNs3qbXHp
	 qARTCCeIjXNxUiRZThaVCR1RDYdpq+e53ldt8kdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/332] hwrng: ks-sa - fix division by zero in ks_sa_rng_init
Date: Mon, 27 Oct 2025 19:32:14 +0100
Message-ID: <20251027183526.758531146@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8f1d47ff97996..994cfdf346e15 100644
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
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
-- 
2.51.0



