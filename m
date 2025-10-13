Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3158C2BF009;
	Mon, 13 Oct 2025 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367581; cv=none; b=uDMLe48HzVxjD/161D5TaK9ScxD0WYf9dVcL0d9VdvihJ+9/MEEu7X7TblNcOkZze8GSeRjG6jkdDb8z1xedpb/fX0D9QPea6ApJBPKa7BCCAo2fJ4swPzXi/7DfUrgoe0Ezqq0JlGOgzH3ivLbYSf4pAVaQyKGZW1x4tY5zMyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367581; c=relaxed/simple;
	bh=28Fa+r6r9ehmUSj2dWg5hKeOrat5OaNL+BJwUpXp3pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmCrIstdlxsUo+eDnHW+oEztKiGVSGhVGJ7/x8XxjvYSSp6lHS1j67eb3sToh2XF7FKaXRbJwELn4uQC2FafT+BJ1aoEGVDfQascXIPA4fIVurNQ/SWUPMJ/xfAPaLM4iTxb41yexB5yVebVL/h/5gdq+dA9eBxHtC9689jT1ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OAlCIx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OAlCIx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F67C4CEE7;
	Mon, 13 Oct 2025 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367580;
	bh=28Fa+r6r9ehmUSj2dWg5hKeOrat5OaNL+BJwUpXp3pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OAlCIx4dcWh2OjGX3EQPBEQ1xg3VeCMt/taDHLDPuSmVehrn/kMzFT3+gfq4V02b
	 SVxDLjfey204Uuzkzq4PMR7uPvW61PK+F2MqiSKQ8i/W67C4j5xRsE8b+/OTX6L1/u
	 EILDRgyJ1wDiMqRO/p1bXVXNIh0EzGqgal+3Sdms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/196] i2c: designware: Add disabling clocks when probe fails
Date: Mon, 13 Oct 2025 16:44:11 +0200
Message-ID: <20251013144317.367195620@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ca6e1991ad13f..e6fa6cb1011ab 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -394,6 +394,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 exit_probe:
 	dw_i2c_plat_pm_cleanup(dev);
+	i2c_dw_prepare_clk(dev, false);
 exit_reset:
 	reset_control_assert(dev->rst);
 	return ret;
-- 
2.51.0



