Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A1F39FC6;
	Fri, 24 Nov 2023 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lc0H2DKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E77EC433C8;
	Fri, 24 Nov 2023 18:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848885;
	bh=OSBJtRypN8KI+sjRAlh8sND2cBjaXhaSUDFiogs7i0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lc0H2DKAAMXYGuQdM91hAHrYEkRJeQTKBpb8gpHhs4+Msc4ScqDM9lX9vNW0/T4Bu
	 7AIKS/J+zRaF8wqTr04Cnh4QbolJRpCZwy2clqCZ8Dr7ZYDbrwox4VoCUE9oa2qZkx
	 CgkoggSLvUc3/aFRR+xh3Oh5ubHSf6QnG4hOgLN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Wahl <ronald.wahl@raritan.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/57] clocksource/drivers/timer-atmel-tcb: Fix initialization on SAM9 hardware
Date: Fri, 24 Nov 2023 17:50:27 +0000
Message-ID: <20231124171930.399827279@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Wahl <ronald.wahl@raritan.com>

[ Upstream commit 6d3bc4c02d59996d1d3180d8ed409a9d7d5900e0 ]

On SAM9 hardware two cascaded 16 bit timers are used to form a 32 bit
high resolution timer that is used as scheduler clock when the kernel
has been configured that way (CONFIG_ATMEL_CLOCKSOURCE_TCB).

The driver initially triggers a reset-to-zero of the two timers but this
reset is only performed on the next rising clock. For the first timer
this is ok - it will be in the next 60ns (16MHz clock). For the chained
second timer this will only happen after the first timer overflows, i.e.
after 2^16 clocks (~4ms with a 16MHz clock). So with other words the
scheduler clock resets to 0 after the first 2^16 clock cycles.

It looks like that the scheduler does not like this and behaves wrongly
over its lifetime, e.g. some tasks are scheduled with a long delay. Why
that is and if there are additional requirements for this behaviour has
not been further analysed.

There is a simple fix for resetting the second timer as well when the
first timer is reset and this is to set the ATMEL_TC_ASWTRG_SET bit in
the Channel Mode register (CMR) of the first timer. This will also rise
the TIOA line (clock input of the second timer) when a software trigger
respective SYNC is issued.

Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20231007161803.31342-1-rwahl@gmx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/tcb_clksrc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 9de47d4d2d9ef..e489730331a23 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -294,6 +294,7 @@ static void __init tcb_setup_dual_chan(struct atmel_tc *tc, int mck_divisor_idx)
 	writel(mck_divisor_idx			/* likely divide-by-8 */
 			| ATMEL_TC_WAVE
 			| ATMEL_TC_WAVESEL_UP		/* free-run */
+			| ATMEL_TC_ASWTRG_SET		/* TIOA0 rises at software trigger */
 			| ATMEL_TC_ACPA_SET		/* TIOA0 rises at 0 */
 			| ATMEL_TC_ACPC_CLEAR,		/* (duty cycle 50%) */
 			tcaddr + ATMEL_TC_REG(0, CMR));
-- 
2.42.0



