Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF07341672;
	Tue, 26 Aug 2025 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214865; cv=none; b=Ah5AHLXYnSlrMNhEI1J7hZBurfziJvVGJpeA/z/AyMbRi2K1pZxOiUBUApvctNm/otegtbVcO10v9m7GqSWlbdsNmzuxwGX8VM1wvh9Or2R+7o7moN8QVBjVVUZrXFxmult6nDbAYtYqcTkAk6sHY8LEXOyAezpt9uuoaJfwAPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214865; c=relaxed/simple;
	bh=R7kcCqr0jZHk4O7rlCl8SShBCnTWIFDJrlzXFxkqU7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ppzbHDtO2VNf4+FsUTTJoIfbTBt9DHt9tb+c+fz/7ky3voU5ZDV8fU63QlpU2M6Z8Ngk6gezyPn72CInQRW9H8F1tx2gSRCk+wQ3MsRssw+SQkk39jXu1XEWziWaJdJyWwjXkfhkSeWnyLi8m8ESTFnyP7IJlSfqLpiRVbvXrA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQ12brMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQ12brMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E25C4CEF1;
	Tue, 26 Aug 2025 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214864;
	bh=R7kcCqr0jZHk4O7rlCl8SShBCnTWIFDJrlzXFxkqU7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQ12brMpCDqoGWNn8UTOlp09sdTZLuQDXVIWiwmCiPpIDZbSfqiDJ97uZ8c3PJLfb
	 glu/muL/FYyran/8Ym2sgmPIubtpWRkI12Cftai3uvZThx3vjSJsbIkthtOtb4V/W0
	 /tEsKVIMbEo/Gzy7asxcdDB1Haw571WKyeiRhquM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.1 299/482] pwm: imx-tpm: Reset counter if CMOD is 0
Date: Tue, 26 Aug 2025 13:09:12 +0200
Message-ID: <20250826110938.185044228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>

commit 65c6f742ab14ab1a2679fba72b82dcc0289d96f1 upstream.

As per the i.MX93 TRM, section 67.3.2.1 "MOD register update", the value
of the TPM counter does NOT get updated when writing MOD.MOD unless
SC.CMOD != 0. Therefore, with the current code, assuming the following
sequence:

	1) pwm_disable()
	2) pwm_apply_might_sleep() /* period is changed here */
	3) pwm_enable()

and assuming only one channel is active, if CNT.COUNT is higher than the
MOD.MOD value written during the pwm_apply_might_sleep() call then, when
re-enabling the PWM during pwm_enable(), the counter will end up resetting
after UINT32_MAX - CNT.COUNT + MOD.MOD cycles instead of MOD.MOD cycles as
normally expected.

Fix this problem by forcing a reset of the TPM counter before MOD.MOD is
written.

Fixes: 738a1cfec2ed ("pwm: Add i.MX TPM PWM driver support")
Cc: stable@vger.kernel.org
Signed-off-by: Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>
Link: https://lore.kernel.org/r/20250728194144.22884-1-laurentiumihalcea111@gmail.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-imx-tpm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/pwm/pwm-imx-tpm.c
+++ b/drivers/pwm/pwm-imx-tpm.c
@@ -205,6 +205,15 @@ static int pwm_imx_tpm_apply_hw(struct p
 		writel(val, tpm->base + PWM_IMX_TPM_SC);
 
 		/*
+		 * if the counter is disabled (CMOD == 0), programming the new
+		 * period length (MOD) will not reset the counter (CNT). If
+		 * CNT.COUNT happens to be bigger than the new MOD value then
+		 * the counter will end up being reset way too late. Therefore,
+		 * manually reset it to 0.
+		 */
+		if (!cmod)
+			writel(0x0, tpm->base + PWM_IMX_TPM_CNT);
+		/*
 		 * set period count:
 		 * if the PWM is disabled (CMOD[1:0] = 2b00), then MOD register
 		 * is updated when MOD register is written.


