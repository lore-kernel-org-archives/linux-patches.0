Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E9F2DF139;
	Mon, 13 Oct 2025 14:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367167; cv=none; b=NCoiGM2ACGj98AsDIk5UYEFRi/Bbz6Xn10QEU9MZZlNTDF87QizCGEDnFzcZsh/uMMNgxl3V/eGcsaNSWXI1CVFmifjao4wn45Y2JfaqcovXDTS9uadfdUDfmsii/9IVbI55GphgryO7Ks39Q4eaArgytFeioNCQinhvOarpR3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367167; c=relaxed/simple;
	bh=9ZPHbAOd+CawNmXw6hwMk3I0l4hl9dbuGmZ/xGdlOI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwoomjTk2Ym+J2o66XKImyHqlsZQ+qo9jCnvbrO5OXDfuMDQQNLFjkrjwqDk56CJ0FgRspyFQtk0mU9Mm1waORAcL44eTpgGMiaIgQwcCKZdp/1rA7U4VCCzAFha4kEGQCoaCDr6ApvBCNRj/wjGa3Lqp8OOiHhPyRzL0gUWY+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+Z/rKoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+Z/rKoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC0DC4CEE7;
	Mon, 13 Oct 2025 14:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367167;
	bh=9ZPHbAOd+CawNmXw6hwMk3I0l4hl9dbuGmZ/xGdlOI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+Z/rKoIZB+TgL+wjnzVob7zo+lngtxcXCXg7SIoruqK/5cBgKCFPiXdC/xS+YKSa
	 RLgTdJAfuG/ylyH4I/y4rtlCCnjbV78aBfhPG35LSvjQ2Bf1BkuBdBpKCtxn+DSzOT
	 p7l/gEVhLIoG18NiLukvsl8PVVIeVvp+PQf0mXsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/196] i2c: designware: Add disabling clocks when probe fails
Date: Mon, 13 Oct 2025 16:44:21 +0200
Message-ID: <20251013144317.755024818@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 74182db03a88b..a29f4ef793cf3 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -380,6 +380,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 exit_probe:
 	dw_i2c_plat_pm_cleanup(dev);
+	i2c_dw_prepare_clk(dev, false);
 exit_reset:
 	reset_control_assert(dev->rst);
 	return ret;
-- 
2.51.0



