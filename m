Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7782D3A69;
	Sun,  7 Jun 2026 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828473; cv=none; b=V9PUBsg0CT1vvwK7d0Z/UMJF50aCta0JT3QCSygh31zh78zX9GQ+bTnmGxJ/9b4U5UgUS8aRrb78lV2PpnTSxdUsO6KgzJIxKHioIWbV56terTbaH7wAimljKrRil9TxN8/cIDGZTrRbGQJ7y4RwQFfF1L1kvFfB61Rjs+OK9wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828473; c=relaxed/simple;
	bh=zuRei42meaVO2eOD19O9V33gRpMm0J0JDhtQ9n8h1/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdH8JqrxjGuvS6MQ0ImgTr22+gMDb1Ex5xeGHLwffnGPIt0UHQoN+ywJDbv+9xncf7sfgYxpw9DV+FWvhQwmMnOKtl4CH6VL4atMWwnWSSzMmbpPEsRI+KVPVRUe+dauWWI1Sc0aQA/69xsjvjtm19YRHULIJUT7ouUgEABHFNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZRzxqgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZRzxqgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7253A1F00899;
	Sun,  7 Jun 2026 10:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828472;
	bh=dsc4H21x3RzBDtQ/3bsiwMc6PT+f6NPIq7ecBw3epbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZRzxqgIvsu0rIonw2e7U0neiXgmhSSMrOEI14zUm8Fg/IJKgQaJUUYajTMfk4YJ5
	 mkIgzLTOJhXCoWaUIRgBzdThYFbm907WbZLrYjQfYQmSo+BGywKUHKfHDk++LcQy/e
	 14UloXD8of0J/EvqHCIPCvHXTe49pV8sO97fco0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 186/332] iio: adc: nxp-sar-adc: Avoid division by zero
Date: Sun,  7 Jun 2026 11:59:15 +0200
Message-ID: <20260607095734.896842374@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 7e5c0f97c66ad538b87c04a640573371fb434b4f upstream.

When Common Clock Framework is disabled, clk_get_rate() returns 0.
This is used as part of the divisor to perform nanosecond delays
with help of ndelay(). When the above condition occurs the compiler,
due to unspecified behaviour, is free to do what it wants to. Here
it saturates the value, which is logical from mathematics point of
view. However, the ndelay() implementation has set a reasonable
upper threshold and refuses to provide anything for such a long
delay. That's why code may not be linked under these circumstances.

To solve the issue, provide a wrapper that calls ndelay() when
the value is known not to be zero.

Fixes: 4434072a893e ("iio: adc: Add the NXP SAR ADC support for the s32g2/3 platforms")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603311958.ly6uROit-lkp@intel.com/
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/nxp-sar-adc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/nxp-sar-adc.c
+++ b/drivers/iio/adc/nxp-sar-adc.c
@@ -198,6 +198,15 @@ static void nxp_sar_adc_irq_cfg(struct n
 		writel(0, NXP_SAR_ADC_IMR(info->regs));
 }
 
+static void nxp_sar_adc_wait_for(struct nxp_sar_adc *info, unsigned int cycles)
+{
+	u64 rate;
+
+	rate = clk_get_rate(info->clk);
+	if (rate)
+		ndelay(div64_u64(NSEC_PER_SEC, rate * cycles));
+}
+
 static bool nxp_sar_adc_set_enabled(struct nxp_sar_adc *info, bool enable)
 {
 	u32 mcr;
@@ -221,7 +230,7 @@ static bool nxp_sar_adc_set_enabled(stru
 	 * configuration of NCMR and the setting of NSTART.
 	 */
 	if (enable)
-		ndelay(div64_u64(NSEC_PER_SEC, clk_get_rate(info->clk) * 3));
+		nxp_sar_adc_wait_for(info, 3);
 
 	return pwdn;
 }
@@ -468,7 +477,7 @@ static void nxp_sar_adc_stop_conversion(
 	 * only when the capture finishes. The delay will be very
 	 * short, usec-ish, which is acceptable in the atomic context.
 	 */
-	ndelay(div64_u64(NSEC_PER_SEC, clk_get_rate(info->clk)) * 80);
+	nxp_sar_adc_wait_for(info, 80);
 }
 
 static int nxp_sar_adc_start_conversion(struct nxp_sar_adc *info, bool raw)


