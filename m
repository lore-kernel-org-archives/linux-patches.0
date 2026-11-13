Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590682;
	b=nLayYRBYSQNSYbaj6lQFcwJGVX2TFMK9NjpKxCEV99yYj59cBpuFjqNAoNv2gUEE+7/p
	 Fry2piufBhpCZLRtZNN7r5vmE7kNumy8dOfuYzY557ze2KeKPJcFp5H1z2vm+t1D43L4Y
	 33PIGPYv4N52g+t8jqIR4JPwBBZbH04RRoWIGRFovLIt6Imroe256/p3kdLL+pR0HVfny
	 YoRwDlUB7CyZKB1RiJphC4Ty8cYDUnUCN1BY1hrkDgsClGuIpES9ugQMxnVHkHVDRUVQ8
	 YyRPF+6FDtHrIk6g8ZC0KbOzHaBqI5cXwTGL+dp6FerODUKROBisnHUXnLBmAiOnMiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NZt58ZLMurAg97KXRueZ3TS1D34vwQx7Pcs6Ick4Xcg=;
	b=ZuMm49f4U4tWIK/77ALdi4jQ/SdBlAlH87APxrj9GnNqsMtxxMAuwjEKJ9f55LSi3cel
	 gCYpeeBYF7wUtfzRTIOFSISg5MDndEYdQfPlhuvq7fSAXuf/8GLct/8fQNrzLcKIedRb+
	 A3EUtkes1gG7bBIVzn9718JLx9zT5oiY8FpoNLBA07z2m/6EqwjGWH9fZwMMjYl001Qv5
	 Iv03c1xEQl9OB2wEHDJcE0FO6Ad7PnExKjB3ugkMPsu7Vl2x3nWxsJuMn5Xl8Rk27qdwy
	 GVM29eFD4wuURZ1boIq7zVl7T/+snGHisk5oGbRgtIPCCBc8Bg1BbZL3qrGpCaiEGHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIjVgODg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B39606CED3;
	Fri, 13 Nov 2026 17:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIjVgODg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFDA1F000C4;
	Fri, 13 Nov 2026 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590682;
	bh=NZt58ZLMurAg97KXRueZ3TS1D34vwQx7Pcs6Ick4Xcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIjVgODgrZqLA8o6tHV/wDkcX1qRwgUDl0XBots9iJpZTbroS8k7kN1bGQX1Rm1aV
	 JnfhhZD441kVjMkpGn9Cg0FUYp0Vze9bXmh0c8R0NW1hiljvtpOzUZ3aj3FYE7eJ2S
	 3YYXPnfVWCrhLSZ2Z1rWk5q4R/D2bQebT1SbhFt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 594/686] media: iris: Fix power-off ordering to disable power domain after clocks
Date: Fri, 13 Nov 2026 10:52:07 -0500
Message-ID: <20261113153842.076244003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

[ Upstream commit 9cfae7726a9a9f526e8905dbddde355be2674e3d ]

In iris_vpu_power_off_hw(), iris_disable_power_domains() was called
before the associated clocks (IRIS_BSE_HW_CLK, IRIS_HW_AHB_CLK,
IRIS_HW_CLK) were disabled and unprepared. This reverses the correct
power-down sequence: with the power domain already removed, the
subsequent clk_disable_unprepare() calls end up operating on
clock-controller hardware that is no longer powered, which can hang
or behave unpredictably.

Reorder the calls so iris_disable_power_domains() runs after all
three clocks are disabled, ensuring clocks are always turned off
while their power domain is still active, and mirroring the reverse
of the power-on sequence.

Fixes: bb8a95aa038e ("media: iris: implement power management")
Cc: stable@vger.kernel.org
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
[ sashal: Adjusted context to account for absent IRIS_HW_AHB_CLK and IRIS_BSE_HW_CLK clock-disable calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vpu_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vpu_common.c b/drivers/media/platform/qcom/iris/iris_vpu_common.c
index 6839e293d9b50..a20565abef6a6 100644
--- a/drivers/media/platform/qcom/iris/iris_vpu_common.c
+++ b/drivers/media/platform/qcom/iris/iris_vpu_common.c
@@ -260,8 +260,8 @@ int iris_vpu_power_off_controller(struct iris_core *core)
 void iris_vpu_power_off_hw(struct iris_core *core)
 {
 	dev_pm_genpd_set_hwmode(core->pmdomain_tbl->pd_devs[IRIS_HW_POWER_DOMAIN], false);
-	iris_disable_power_domains(core, core->pmdomain_tbl->pd_devs[IRIS_HW_POWER_DOMAIN]);
 	iris_disable_unprepare_clock(core, IRIS_HW_CLK);
+	iris_disable_power_domains(core, core->pmdomain_tbl->pd_devs[IRIS_HW_POWER_DOMAIN]);
 }
 
 void iris_vpu_power_off(struct iris_core *core)
-- 
2.53.0



