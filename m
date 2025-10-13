Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912043081A8;
	Mon, 13 Oct 2025 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367397; cv=none; b=gmWqMABlhHl4B1LSUZlLaeg72i98Xkyqs/7wS4Cxdv/YKZ6Zj7DDmHws3PuFTkf0BUMRm7WPXoXsMKdpjkJw/6t+JmooNDA5Gw0P7Ms9auYT2KCKSgA5C+/SxfvPOZ9ppu2h1ntsBUNLp6RR45p/tCQk4S4Dm1omGtWNmfiq9DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367397; c=relaxed/simple;
	bh=nqyeynbYbjUzr9Yt2+quL04I73r0tVUTSMp9x5MfnlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUnvChFPfw3ppUdjLT0xt1vhapDTQdnYvvuqaxV1T3mvc+/KMhDvOhq6OGnZgbnq5bPVxYMd24OWxHfJHialWnEH0ON+R4D+sKTQ1C0d+zSmHSPOvDNGv3nmGvLbjU446dnJuN8OBvV+Ppsj3d/wCXMXW7Kd0yIsL8AGDGyaoBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULp+uVDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULp+uVDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181FAC4CEE7;
	Mon, 13 Oct 2025 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367397;
	bh=nqyeynbYbjUzr9Yt2+quL04I73r0tVUTSMp9x5MfnlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULp+uVDZ/yNLlP9QGmbM4NGLoutlSE9XKBHGwxgHVOw802TBQxz9BDpZJ6One2Pdl
	 7Hi8ZOXLz0OKQXcIfGxOcmfqQ0e+JSzItQOvILVpZAJbqY3Y/q29VkjiBc+rnKfn3p
	 K0mVYjF0Ez5DTfPlE6MZIkBnJ9jYHNRMVLSJqJAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/196] hwrng: ks-sa - fix division by zero in ks_sa_rng_init
Date: Mon, 13 Oct 2025 16:45:34 +0200
Message-ID: <20251013144320.523234431@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



