Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EE530C614;
	Mon, 13 Oct 2025 15:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368225; cv=none; b=mZhECHwMdqXRxmgRRBsmMyP1cXWRJI+vcVsc/HgDIYHj6TIXAK3N4oeTEwLcKM5k5hJa+vReClHNBzjFA4GebqGP3zpMPz572VGe8DMMFoEqDafItG25jyaH/87g98AI/T+3TD/MbLhUDCM/HbxkeVc5IAK0A8P+mq/8PVGaxSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368225; c=relaxed/simple;
	bh=YXIjgWMRI0e3d0Vg1xuISR2AbXTdb5vYWpwDB8ftbW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZeXERWvDiawmAMdVN6PEtMGxVBCP48+sU1MggM8jiJXj0qWveCok+RhRfysmfimHurf1aKM8bClYZdJ6BPQZ8Gsfj44cEwIMUrqI96UCa2jpkE2Nor9qQnK+A92ylV091zK2oRbxLMhpHmSTGTbC23gTngLKFadpfbjTjD++QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FM7f4VJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FM7f4VJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215E6C4CEE7;
	Mon, 13 Oct 2025 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368225;
	bh=YXIjgWMRI0e3d0Vg1xuISR2AbXTdb5vYWpwDB8ftbW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FM7f4VJHmqReGn8B68TwfpMHZmYVwHWOvKu7DzQMw5yqVeLOmTTnjILhpwq1Xvn5/
	 Yg/23i4+HQCEvnCEHPqNelhKJTGJhvNvti6knW7YUJD+Q4COujJT3m8SXPZcXvAWFO
	 X1m8KbNPgWf5Vw5g10xYENux0fUOAhKZfJjP/zoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/262] i2c: designware: Add disabling clocks when probe fails
Date: Mon, 13 Oct 2025 16:43:49 +0200
Message-ID: <20251013144329.263948534@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1615facff29c6..24c0ada72f6a5 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -311,6 +311,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 exit_probe:
 	dw_i2c_plat_pm_cleanup(dev);
+	i2c_dw_prepare_clk(dev, false);
 exit_reset:
 	reset_control_assert(dev->rst);
 	return ret;
-- 
2.51.0



