Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA4D145B3E;
	Mon, 27 Oct 2025 18:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591120; cv=none; b=mE99bkG+kpTG1RWWo8MoOnhId8UtTGNJALMPxcPuvQK2ym4aROffeecTe3SPuJUJKpw1dBhkL+Q3OnGVeW0R6qmTlXK0fPdKwzZ43CC5IOafXIQWPu2SQQkZQNzbmPrpEW/D65wWpiAMfYn57zuX0bw5U+PTs2FfoKqAtDPIzc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591120; c=relaxed/simple;
	bh=njrGNHd7HNHA3ujm/3AFYyBZz+M/oXDZUOPa6elq/XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlxVIPmK9eHAgQmWFuX/n1a6mpq2UNltJHRGIxAcuKRsKR1nq3dFZyVLPJJNdOFq3G/l33i5GfYY5Hzp8GHFTVzhNRx7UQb068vaYUitygEUvGzB5Q1VtnxAHWUY/YCG37lV37/xabfjZ/H2s09TFOiRuJKoyT37SwQXDObQSj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2g1Mzv8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2g1Mzv8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF53C4CEF1;
	Mon, 27 Oct 2025 18:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591120;
	bh=njrGNHd7HNHA3ujm/3AFYyBZz+M/oXDZUOPa6elq/XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2g1Mzv8yH9hlifnyQKr1vSEXxzUDy7BhIf20pzU8mol90mR1/dHePQeRLsCvUrEP9
	 H/xwmV04H8IoY1VBa3Bcm5jMw5YsGw21BOT3UGnc2C0IKWqh0bpOVYmam/yLlJgzRU
	 wxuj84yqTPTDfm+zlYK72H7pFdRJA7c4/H2HX38U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/332] i2c: designware: Add disabling clocks when probe fails
Date: Mon, 27 Oct 2025 19:31:31 +0100
Message-ID: <20251027183525.628875275@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit c149841b069ccc6e480b00e11f35a57b5d88c7bb ]

After an error occurs during probing state, dw_i2c_plat_pm_cleanup() is
called. However, this function doesn't disable clocks and the clock-enable
count keeps increasing. Should disable these clocks explicitly.

Fixes: 7272194ed391f ("i2c-designware: add minimal support for runtime PM")
Co-developed-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 4747541517252..dc05775d12e1c 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -327,6 +327,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 exit_probe:
 	dw_i2c_plat_pm_cleanup(dev);
+	i2c_dw_prepare_clk(dev, false);
 exit_reset:
 	reset_control_assert(dev->rst);
 	return ret;
-- 
2.51.0



