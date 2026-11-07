Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064116;
	b=gCDdIYmho50nhZQkrbskvrW0hVsBjeB77vpg6CL2SRczqy9eXEWT+CRrL1DuY3werws1
	 gVxqZrrKMTPxVtRnwJERF9iI4xQ6r3KruTFHjWqYhqBezpTzb+1nvN3DD/y+YoFUMwGNK
	 HPMUpVqDoWCvYpGXpdnf7nmr1XfZTh5VhukhRvWN5Vg458SzYlzbyspXFkkXVudyLaO9Q
	 6PBSqYLak96WENIEvyvc8FRBMOEGZH5JoKKdUa/dcUPX0f/rGSki//b3pW7srecrwnZZ9
	 ss8VJy663ZWW+aH96mB9WT1ZHPXDUAX9cI58hSDL2eqqJk7tXeAwDm23Fw8tQIhzhMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=okalbK3JG3zwmbiIMnW52UNAVFbWcALi9BCyey9UsDU=;
	b=ZxCqyW26hzNOeDwoOvPlVI6AGBMIZVlyYJKEJoQeJeJuIZSZJjdYeLbnof25H35s7Ah7
	 BzHvUp5n2yEKl1Z5c57ZOZROgDHDp7ZIUkBhwkrBT2mtNJCCZOt6ZTfFTUeylH714FvPx
	 C5YLkNmb1qgfLHQZQze6MKLY5GyV3+wZxRUtTND2QSLmAUUewO0708O5MwlgIi9Hr3Kni
	 MFZq0eud4AHc/3ceZMRmurshYZn+VK1wDYb5IKxuu2lnSpJuEck0R8pcReZuRH02P/SqU
	 s048omZDrySvkqWvt4ickfgrm4fuX05ypkk6fonzbXXssUzhGA4tJSQqpsTLqQMFR2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdPq6Xha;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9078C606A33E;
	Sat,  7 Nov 2026 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdPq6Xha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9751F0089F;
	Sat,  7 Nov 2026 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064116;
	bh=okalbK3JG3zwmbiIMnW52UNAVFbWcALi9BCyey9UsDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdPq6XhasF3H+9SgL3b7qmVzQIwMVq1dokvty2+/VFUjQcZM/aQg2xsLmwvhcPNKP
	 EfIXUEfM1+/clwsAK8b7PLbemsctVGfiNIgroS0Q1vh4o15AND3DvvUcX73KUX1QJ3
	 +P/aoa8JSQ8FEUZpr4HaaUOVGH2wfdQND8yyKmIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0273/1257] memory: stm32_omm: fix child clock leak on set_amcr() error path
Date: Sat,  7 Nov 2026 08:42:49 -0500
Message-ID: <20261107134947.025738728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 84eb23c824f5b..3599683ab04ac 100644
--- a/drivers/memory/stm32_omm.c
+++ b/drivers/memory/stm32_omm.c
@@ -274,6 +274,8 @@ static int stm32_omm_configure(struct device *dev)
 	writel_relaxed(omm->cr, omm->io_base + OMM_CR);
 
 	ret = stm32_omm_set_amcr(dev, true);
+	if (ret && (mux & CR_MUXEN))
+		stm32_omm_toggle_child_clock(dev, false);
 
 error:
 	pm_runtime_put_sync_suspend(dev);
-- 
2.53.0



