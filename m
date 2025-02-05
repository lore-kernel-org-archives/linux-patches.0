Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3805121345;
	Wed,  5 Feb 2025 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768158; cv=none; b=iCvqdq853vrTer2WoR2Vzw8AvRpI8jhNR8HyeqbmvQsgUe00mqcSOzjlposi2OemNe6e8j8nXeD/IrWmbY8sX6BgQ6gwVogXIzQ2imTMnZFTFqpRQfGToqizComE/nNjAXMSWhrjVJTYF8wPT1LpCSSG3yCF/NiRtd6elsr1U80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768158; c=relaxed/simple;
	bh=HZ7ccEuinhhQoFEigxlJ+b+PKjrcr9X6tUGb2aiqqmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zdy4U3qViU2zYMidJ8Rg4ozF1cIX+GY6x3vxO7mHM3IOnzDVvbO79G1W+DL9DwNdDmpO/E8yzTuCEEa86drMT4Sf/XWGgmsGYdT19t9uVYo0qZRAJRuaCySpk1wzXpfbqz5kBNZnUnDFLXk64xqiWotOhw8l7TfnRs8g4+itKRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXzfr/rN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXzfr/rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AE9C4CED1;
	Wed,  5 Feb 2025 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768158;
	bh=HZ7ccEuinhhQoFEigxlJ+b+PKjrcr9X6tUGb2aiqqmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXzfr/rNMVEOP+0W2FM0GBfnLrv5qgbwAFxp20Xmr6YG3L7HShF4nOvhtCMSkbv0P
	 PAQhgQ07XVux3mHkfzMD9RjiO41zcaWKCrBxc6yDvO8R+RZmc9rUDwHZcM0jTiFHV1
	 64A1GxtM3mwkjP7LNGRcsPObTuzpwuvin2SVDHZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 561/590] clk: qcom: gcc-x1e80100: Do not turn off usb_2 controller GDSC
Date: Wed,  5 Feb 2025 14:45:16 +0100
Message-ID: <20250205134516.730078505@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit d26c4ad3fa53e76a602a9974ade171c8399f2a29 upstream.

Allowing the usb_2 controller GDSC to be turned off during system suspend
renders the controller unable to resume.

So use PWRSTS_RET_ON instead in order to make sure this the GDSC doesn't
go down.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Cc: stable@vger.kernel.org      # 6.8
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250107-x1e80100-clk-gcc-fix-usb2-gdsc-pwrsts-v1-1-e15d1a5e7d80@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-x1e80100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -6083,7 +6083,7 @@ static struct gdsc gcc_usb20_prim_gdsc =
 	.pd = {
 		.name = "gcc_usb20_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 


