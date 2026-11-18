Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040697;
	b=SdElMbL6uAXCJ394RDKy8sovgxyjwhenavpnBe2Frjbjg6Sod+iVWYBMdlWk7TCxgiBk
	 Pju0nrcV7vh3oz8PeqjwEE1IE1kfqkLUaLpp7UE5uFJM8yu+RV5aM18comB7krLTV7lwm
	 Md/LOkRPqOw/UrqfAE35o1tpBnqHBDsRkazjNEiaTqtJH2STArplqK+LO5bTVySaAzLYf
	 yPUozb4VokeKkdUWq2gMsAi0SW6bPAeYw6Akc62w+b9Fnw96A9iHrFrVqSuWmJxAviKW9
	 cJFWTTi2LZIlaz0OfhBNQsp3lRo9Ir0hLOP+OF4UNL2ahUBOlYQ3S1HRVCR0qEK8VKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c16cFNPsnlf+EEF2mx7t0481Q7+E1VycPY94vy5xk2Q=;
	b=R6sKLbp4YGxR7dZGNP+TAxNu79X6h+dK4FEHOVeuVhllhxgNyvxeXSr6En7IhQIJ7VYl
	 3yhmjRgz2oOVoX4gYr/4YwDvagtEV/7bN78/ZlD7mvoPeN6IscJsIGpzUdsOAoGHo6A3D
	 L5FnYr3z/gvlPbfREqiCmmG2aiJZ1u2om8amd+2nnHJ1AC+1ekktzW0WvUDqPJRLet9Yw
	 ha5GDApNduMzlSUd6jjF2Ofbt6ri29RDaCKOoDChP7V7J0eRLSMcbyCXkAZgFw+PqRwjf
	 ahgIhA31CPdTE74I9WaCyzJhbFxa0BV8mAelabZOeKVgxRICwJtimiCBgpUuvJ5CLyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="luyBkat/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59629606A32A;
	Wed, 18 Nov 2026 22:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luyBkat/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB37C1F000C4;
	Wed, 18 Nov 2026 22:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040697;
	bh=c16cFNPsnlf+EEF2mx7t0481Q7+E1VycPY94vy5xk2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luyBkat/eCKIIFEGBpBZP0aKWDxAbuoLPkjPZ8DmQgoE+pr9rPv8Y5fTmApSNC32K
	 k7c3YHOyWjui8ykZkBMWk1408oJteVOKd+LqdhoDLcuW9f4Lkv4lcXFqiOkNFZ47NN
	 oofO0xztNVkItG7nlfKzxc9fupP2YI02Jqzy4TbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2550/3318] perf/cxl: Clear stale overflow status before using a counter
Date: Wed, 18 Nov 2026 15:52:52 +0100
Message-ID: <20261118150437.789775499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 05d82cf377f706d0b566b572bc66e3a2057bd68e ]

cxl_pmu_event_stop() leaves the counter's bit set in the overflow status
register and only cxl_pmu_irq() ever clears it, so a counter handed from
one event to the next starts with the previous owner's overflow pending.
The perf core stops and starts back to back with interrupts off, so an
interrupt latched over the handover lands on the new event. prev_count is 0
by then, so the read path adds a full period: 2^counter_width phantom
counts.

Clear the bit in cxl_pmu_event_start(), before the config write arms
Interrupt on Overflow. Clear the whole register at probe too, for counters
no event ever owns - the driver never touched it, so firmware or a previous
kernel can leave a bit set there.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: Richard Cheng <icheng@nvidia.com>
Closes: https://lore.kernel.org/linux-cxl/anAVpO--i5heVfz9@MWDK4CY14F/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 5d69ed4f706e3..a7070cc8a0be9 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -690,6 +690,15 @@ static void cxl_pmu_event_start(struct perf_event *event, int flags)
 	 */
 	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_THRESHOLD_MSK,
 			  cxl_pmu_config1_get_threshold(event));
+
+	/*
+	 * Drop any overflow the previous owner of this counter left pending;
+	 * cxl_pmu_event_stop() does not. Otherwise an interrupt latched over
+	 * the handover gets charged to this event. Do it before arming Interrupt
+	 * on Overflow below, and note RW1C leaves the other counters alone.
+	 */
+	writeq(BIT_ULL(hwc->idx), base + CXL_PMU_OVERFLOW_REG);
+
 	writeq(cfg, base + CXL_PMU_COUNTER_CFG_REG(hwc->idx));
 
 	local64_set(&hwc->prev_count, 0);
@@ -921,6 +930,14 @@ static int cxl_pmu_probe(struct device *dev)
 	if (!irq_name)
 		return -ENOMEM;
 
+	/*
+	 * Same for counters no event owns yet: clear whatever firmware or a
+	 * previous kernel left set before the handler goes live. Bits above the
+	 * implemented counters are reserved, so only write those.
+	 */
+	writeq(GENMASK_ULL(info->num_counters - 1, 0),
+	       info->base + CXL_PMU_OVERFLOW_REG);
+
 	/*
 	 * The handler must run on info->on_cpu, so the interrupt cannot be
 	 * shared - IRQF_NOBALANCING is only honoured for the first action on a
-- 
2.53.0



