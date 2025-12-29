Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418C7332EA9;
	Mon, 29 Dec 2025 16:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026075; cv=none; b=DZlmPl/VO7M00HfyWZfff/ACYmLRkn0zshORg7dV33GSNlNUM07p2nDGJ1n8MBAy8ogF9eG9hx0Y9CCw07aF0s+NPETCaJF9qcDQiP316U4bbd7W4Lsgd79M5aArk40Ss2b99JrnGGCPpR6iCXPgdQSZhnPK2KRpULzRXY0MqwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026075; c=relaxed/simple;
	bh=MLItFqNMVgZXPIDF9EFxiMnjKKx3/M28MSl0ajyHvNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EFFaI94xCoJitRvaApJ0ShkameJI6pRwXjseyQmFw7tx9mqLMD9dSZZoqMpjRBNeigkJIpNXjOKEF/aar9OjY4ZdZcJaxtcSC8NgOyd9Bdtw+o6b+hot7VGKa6BZyt44G8CchR6lPPkiA3rj9wzJmIgHX6I1liKJat7Mxkesukw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQ72V9HE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQ72V9HE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBE6C4CEF7;
	Mon, 29 Dec 2025 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026075;
	bh=MLItFqNMVgZXPIDF9EFxiMnjKKx3/M28MSl0ajyHvNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQ72V9HE9vl9OarhCPdSNC6FTzJ9AY04ggGGz5VunLqJRT21USQH9Jj3nn3cioURC
	 yWu2X1nkRi3gNff3GyDVzTI1+TbcoKuXPi459rfOv8ohwVRtywo31ZiprJkUy+gGi7
	 R1PtJL4VeWK9oUiLOLFOGVAGr2ys08qm+3V19nRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Biju Das <biju.das.jz@bp.renesas.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.18 413/430] pwm: rzg2l-gpt: Allow checking period_tick cache value only if sibling channel is enabled
Date: Mon, 29 Dec 2025 17:13:35 +0100
Message-ID: <20251229160739.512861461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit fae00ea9f00367771003ace78f29549dead58fc7 upstream.

The rzg2l_gpt_config() tests the rzg2l_gpt->period_tick variable when
both channels of a hardware channel are in use. This check is not valid
if rzg2l_gpt_config() is called after disabling all the channels, as it
tests against the cached value. Hence, allow checking and setting the
cached value only if the sibling channel is enabled.

While at it, drop else after return statement to fix the check patch
warning.

Cc: stable@kernel.org
Fixes: 061f087f5d0b ("pwm: Add support for RZ/G2L GPT")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20251126104308.142302-1-biju.das.jz@bp.renesas.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-rzg2l-gpt.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/pwm/pwm-rzg2l-gpt.c
+++ b/drivers/pwm/pwm-rzg2l-gpt.c
@@ -96,6 +96,11 @@ static inline unsigned int rzg2l_gpt_sub
 	return hwpwm & 0x1;
 }
 
+static inline unsigned int rzg2l_gpt_sibling(unsigned int hwpwm)
+{
+	return hwpwm ^ 0x1;
+}
+
 static void rzg2l_gpt_write(struct rzg2l_gpt_chip *rzg2l_gpt, u32 reg, u32 data)
 {
 	writel(data, rzg2l_gpt->mmio + reg);
@@ -271,10 +276,14 @@ static int rzg2l_gpt_config(struct pwm_c
 	 * in use with different settings.
 	 */
 	if (rzg2l_gpt->channel_request_count[ch] > 1) {
-		if (period_ticks < rzg2l_gpt->period_ticks[ch])
-			return -EBUSY;
-		else
+		u8 sibling_ch = rzg2l_gpt_sibling(pwm->hwpwm);
+
+		if (rzg2l_gpt_is_ch_enabled(rzg2l_gpt, sibling_ch)) {
+			if (period_ticks < rzg2l_gpt->period_ticks[ch])
+				return -EBUSY;
+
 			period_ticks = rzg2l_gpt->period_ticks[ch];
+		}
 	}
 
 	prescale = rzg2l_gpt_calculate_prescale(rzg2l_gpt, period_ticks);


