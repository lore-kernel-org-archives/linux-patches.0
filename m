Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E0146A614;
	Tue, 21 Jul 2026 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648898; cv=none; b=Ld8M7txdoiR8aSLTvdTole+gqnCoZaCmE1QTQ4LpMSuannHAo1WgHAyCML7hj5kYR9IrsB3hUib8f7n8XCAFgSFeM6Bkt/3i30TSYhoQ4i//Kdj70RwAfU5Zx17kWvkJvtCCr3GpGk6uUlRNYdcPW0rdYvMLKSD4Yn1tcPriVV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648898; c=relaxed/simple;
	bh=CBOSUZSxTHVrVZrW+Tx7e0LVmOb24GNZU88Yu+1+Bm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRKc1SQ8kUZ/ZRnR+mBX1aHCgqzdSbDQIT9ccgCcRiGXuLPOh+ITVBHQLo+a2T2vhuarHFSPBdpNxY7dUranPVC544B/dRrOnZD3i6HGQgluzMqmt9b+R7cwDw9GS91KrIwGuYtKxnoM0jxWLt/VkeBjxR5sKI6wXoOzWxGH5AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yo3mKPWE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yo3mKPWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEED1F000E9;
	Tue, 21 Jul 2026 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648897;
	bh=B01vRi4MLgI9sVpNhNW5vgPaMt14iLJi2gMAQzdtTAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yo3mKPWELeqsdYbij1Tf/TLthf30kgpOqVbUZgcfVxhm5dGf3v5isUseVQIFEfv0L
	 K+gsyOq/J8iKEkoCMWhwol7+kdAJoT69Vw38tsjZocVrAnWAFps8Dx4Ep1fnl9mW8r
	 rxONCkpP+OKr1u2bKozVbuaKuiNkASwh8+LjMGCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0374/2077] firmware: samsung: acpm: remove compile-testing stubs
Date: Tue, 21 Jul 2026 17:00:47 +0200
Message-ID: <20260721152601.509737376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7b661285aa7507eab79efff0a418445157db4141 ]

Sashiko reported an inconsistent use of NULL vs ERR_PTR()
returns in the stub helpers in xynos-acpm-protocol.h.

Since this only happens on dead code for COMPILE_TEST=y, this is not
really a bug though.  Having stub functions that return NULL is a common
way to define optional interfaces, where callers still work when the
feature is disabled, though this clearly does not work for acpm because
some callers have a NULL pointer dereference when compile testing.

Since CONFIG_EXYNOS_ACPM_PROTOCOL already supports compile-testing itself,
and all (both) drivers using it clearly require the support, so this
just simplifies the option space without losing any build coverage.

Remove the stub functions entirely and adjust the one Kconfig
dependency to require EXYNOS_ACPM_PROTOCOL unconditionally.

Fixes: 6837c006d4e7 ("firmware: exynos-acpm: add empty method to allow compile test")
Closes: https://sashiko.dev/#/patchset/20260420-acpm-tmu-v3-0-3dc8e93f0b26%40linaro.org
Link: https://lore.kernel.org/all/a7994860-24a3-4f87-84bf-109ed653dda4@linaro.org/
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260529134454.2147446-1-arnd@kernel.org
[krzk: Rebase on difference in devm_acpm_get_by_node()]
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/Kconfig                        |  2 +-
 .../linux/firmware/samsung/exynos-acpm-protocol.h  | 14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/clk/samsung/Kconfig b/drivers/clk/samsung/Kconfig
index 70a8b82a0136b4..198d8b62128931 100644
--- a/drivers/clk/samsung/Kconfig
+++ b/drivers/clk/samsung/Kconfig
@@ -97,7 +97,7 @@ config EXYNOS_CLKOUT
 
 config EXYNOS_ACPM_CLK
 	tristate "Clock driver controlled via ACPM interface"
-	depends on EXYNOS_ACPM_PROTOCOL || (COMPILE_TEST && !EXYNOS_ACPM_PROTOCOL)
+	depends on EXYNOS_ACPM_PROTOCOL
 	help
 	  This driver provides support for clocks that are controlled by
 	  firmware that implements the ACPM interface.
diff --git a/include/linux/firmware/samsung/exynos-acpm-protocol.h b/include/linux/firmware/samsung/exynos-acpm-protocol.h
index 596d17f0384f43..24eacc7c16d25c 100644
--- a/include/linux/firmware/samsung/exynos-acpm-protocol.h
+++ b/include/linux/firmware/samsung/exynos-acpm-protocol.h
@@ -49,22 +49,8 @@ struct acpm_handle {
 
 struct device;
 
-#if IS_ENABLED(CONFIG_EXYNOS_ACPM_PROTOCOL)
 struct acpm_handle *devm_acpm_get_by_node(struct device *dev,
 					  struct device_node *np);
 struct acpm_handle *devm_acpm_get_by_phandle(struct device *dev);
-#else
-
-static inline struct acpm_handle *devm_acpm_get_by_node(struct device *dev,
-							struct device_node *np)
-{
-	return NULL;
-}
-
-static inline struct acpm_handle *devm_acpm_get_by_phandle(struct device *dev)
-{
-	return ERR_PTR(-ENODEV);
-}
-#endif
 
 #endif /* __EXYNOS_ACPM_PROTOCOL_H */
-- 
2.53.0



