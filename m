Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062959;
	b=MgoBkg/lJRMf8ODu8pavTCHNM6AWrdjHoR5SXM0ZhZ6vdQTUwN1twVjIFWFwv28WIXoc
	 azoguBxPyMjNB5vmMc9KxLA3WA0lzCXOVy696xSsULLqJdMFjtgNQBVXH5cc3Fcxqlyzl
	 nibjnd2dyiM7W02UJeQwIOavw4COyv8o/DjhnwVBgWNE72FRE2b/aCB+PM4P0uLQ+A4lw
	 Rzxvvfx5LR6Mzopqrf3JKo6VBULg1hMm9huIdqVMVKpOnh0lcLWM6h+zOJCr3xpopI9mR
	 IfZuOeG5cWLKttocJaPnGHLx9qeY6mXPae4Lde/R52rAste1V2uPbTmImbKqcICT/5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7GttJ2GIxlal8s1lzkLXa9UUa80lv4aRKZcNkQPqYSc=;
	b=oPyT+mKUHHIv6Wq1dppbld5s7cT1Ij56IbNs4kMdMukiuYAbKwYdi8LYtGX8A4w9oX+r
	 u6gYX5h4+yPycpTiaCXn20k03LDYt1QHop2bK4pGU4V9jrALFY72zzgLoYgwt/D2bAoc/
	 H3y0SOzNjfs5EyKd7RKfMUPO24doaNhDuG9jfjOs9XE5DzhAVR9bjnhoHw5XY9jDtMq07
	 negIainOmO86b2b8QSHxDgWFjTA5AeoL1o5mOm0cGSr1OkOUdpmMlJzkkS1mHQYnzqJHF
	 eq+0u21m/Al/Z1AhcWQR86gqI0pShRF3Z4M67p/gHnD+h6J70jnnFqzLurUlmPzeSpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNW9uWeK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E6606D812;
	Sat,  7 Nov 2026 14:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNW9uWeK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52D11F008A2;
	Sat,  7 Nov 2026 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062959;
	bh=7GttJ2GIxlal8s1lzkLXa9UUa80lv4aRKZcNkQPqYSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNW9uWeKNverZ157eYA046SFCZhz18H2MYXM7CCLCjQZ0JbuKCiSl6RViwsAMRbUF
	 G+yHLP9HeKKaKmmd4F08DfmgKuZVlKBZdglbv1+LLgjZMXIjjnIqtr/c03vd+uhNmQ
	 wbTVSofSIZLwojInNZMwEdTp4/Lsx7U3O+L1jMTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 221/869] memory: stm32_omm: fix child clock leak on set_amcr() error path
Date: Sat,  7 Nov 2026 08:48:23 -0500
Message-ID: <20261107134859.395463428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>

[ Upstream commit a22355280361d2a376a2020059a2bae11e6cea10 ]

When the mux is enabled, stm32_omm_configure() enables the two OSPI
child clocks via stm32_omm_toggle_child_clock(dev, true); they are meant
to stay enabled for the device's lifetime and are disabled again in
stm32_omm_remove() and on the devm_of_platform_populate() error path.

However, if the subsequent stm32_omm_set_amcr() call fails, the function
jumps to the "error:" label which only calls pm_runtime_put_sync_suspend()
before returning, leaving the two child clocks enabled. As this happens
during probe, the error is propagated and .remove() is never called, so
the clock enable references are leaked. devm_clk_bulk_get() only releases
the clock handles on unwind, it does not undo clk_prepare_enable().

Disable the child clocks on the set_amcr() error path, mirroring the
cleanup already done on the devm_of_platform_populate() failure path.

Fixes: 8181d061dcff ("memory: Add STM32 Octo Memory Manager driver")
Cc: stable@vger.kernel.org
Signed-off-by: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
Link: https://patch.msgid.link/20260917235925.44185-1-diegomancera.dev@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/stm32_omm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/stm32_omm.c b/drivers/memory/stm32_omm.c
index 2a1af229d2444..faef903342495 100644
--- a/drivers/memory/stm32_omm.c
+++ b/drivers/memory/stm32_omm.c
@@ -275,6 +275,8 @@ static int stm32_omm_configure(struct device *dev)
 	writel_relaxed(omm->cr, omm->io_base + OMM_CR);
 
 	ret = stm32_omm_set_amcr(dev, true);
+	if (ret && (mux & CR_MUXEN))
+		stm32_omm_toggle_child_clock(dev, false);
 
 error:
 	pm_runtime_put_sync_suspend(dev);
-- 
2.53.0



