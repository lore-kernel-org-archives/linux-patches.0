Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60792144A4;
	Tue, 12 Nov 2024 10:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408380; cv=none; b=ASh58ye1nLFbS+D58Jcra6E48NpbyHG6tX1UQzgISVEt5HZ7mYqTpj6YWnJp1XWLAsABVjVxX+cil1QK/ZyTZ86RhFxePrr7TpOt9I+ncpeKZjoCFlG4HaVyrykEM6TJie5ApTcXbmsV5SCDLcHe6bg8VQGN8CY9/1JgRTsCH/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408380; c=relaxed/simple;
	bh=scc6Ey4QJ7Ns2CieAgfkYT5ytyOmCLkw/KatmHvVRvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5fVp0kpf1qvyI07UZFq81J10Od3EzjpBePD8WcSvQaO0Omtot4Dl/8a7QKjy+PttGHD/g5o1fI31h/WX4E2rv+Mx00Oz6uz44LjtI6tjRC/nvqmaL96tSAiXTtNflf+XxAfk4ffLHVBArVU1QInMSU/oirxHTlr/rF87yU6Wio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltRbA+uE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltRbA+uE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E8BC4CECD;
	Tue, 12 Nov 2024 10:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408380;
	bh=scc6Ey4QJ7Ns2CieAgfkYT5ytyOmCLkw/KatmHvVRvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltRbA+uE3k27ueoG+zHmAPNMVapmEGvIcyXsjwFh9uESzNVc99po2yDpiBA/iXiLP
	 HJhVJcBRDrZR8ukfsTBVmmlD5usDFphTpwf4fOraM/5YFMsL2ugkIkSGvVPZPFq7Ip
	 hMdQ4ROlSW0O64CWkHZkvqaVXJNdd5/vpPpTnUfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 145/184] clk: qcom: gcc-x1e80100: Fix USB MP SS1 PHY GDSC pwrsts flags
Date: Tue, 12 Nov 2024 11:21:43 +0100
Message-ID: <20241112101906.436859048@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit e7f37a7d16310d3c9474825de26a67f00983ebea upstream.

Allowing these GDSCs to collapse makes the QMP combo PHYs lose their
configuration on machine suspend. Currently, the QMP combo PHY driver
doesn't reinitialise the HW on resume. Under such conditions, the USB
SuperSpeed support is broken. To avoid this, mark the pwrsts flags with
RET_ON. This has been already done for USB 0 and 1 SS PHY GDSCs,
Do this also for the USB MP SS1 PHY GDSC config. The USB MP SS0 PHY GDSC
already has it.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241021-x1e80100-clk-gcc-fix-usb-mp-phy-gdsc-pwrsts-flags-v2-1-0bfd64556238@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 81ba5ceab342..8ea25aa25dff 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -6155,7 +6155,7 @@ static struct gdsc gcc_usb3_mp_ss1_phy_gdsc = {
 	.pd = {
 		.name = "gcc_usb3_mp_ss1_phy_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
-- 
2.47.0



