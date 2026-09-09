Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2363568FD4;
	Wed,  9 Sep 2026 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963439; cv=none; b=ceLcAjWinWs7/r/+C1qbJ/5f/C+gLmnmQwMkE5dfNzDNchHdWAapokBhxyoYz9IMREeWb9TDMHXpRGGNgFEuMRKE3cb0dKX38T3c0GBge41Q4Af2B0K/UclirqAR2k+jOi8DISrxHnh+Uin0/dT8KSkcdDLliNo2lDJN4Hgxk5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963439; c=relaxed/simple;
	bh=akQFNZgNjcQ5jxLmYXJyaoM6OOOPplXc6HGhp/DYXx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSGBB94PYUGfecsijDFwQUAQoSRhx/ro7QM92GsDJF5/DVU4MM59UeWHx/t1nTr5Nc0s2cjeMlUpRdLt8QLEzleEVd17mvnMPVU7blVlvzhRv0RBjYfZfARfsFkwmAf/ys/e7g4jIsfDmHukeixSaHYuqCt8OG1cMdXvbh3l7WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjDY4f7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjDY4f7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564C11F00A3A;
	Wed,  9 Sep 2026 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963437;
	bh=wBwSfSTviVKsjg2GxvyZreKVNjEXMCbKRAcsYvCk74g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjDY4f7Q2p39X3dPWLCkwAaOq9VubV/OoRt6Hd0q1jo1R3qtfuCr+oq+1hhdn37xO
	 v+N9VC1olPIroJ9gOZ4MqJO8xeGALOUFQVoTpYX313tokj4ChecuyqATXSspvp4WVU
	 dus2ngz5/nKoDIPy7u6gub3s0UaBa3Lrxpt296pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 040/583] spi: bcm63xx-hsspi: disable clocks on resume failure
Date: Wed,  9 Sep 2026 15:35:25 +0200
Message-ID: <20260909134239.307557893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit 3b0cee02664041aea7e4f787c66cb86c82eb4e97 upstream.

bcm63xx_hsspi_resume() enables the HSSPI clock, and optionally the PLL
clock, before restarting the SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves those clocks enabled. Propagate the error and disable the
clocks before returning.

Fixes: 142168eba9dc ("spi: bcm63xx-hsspi: add bcm63xx HSSPI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Kursad Oney <kursad.oney@broadcom.com>
Link: https://patch.msgid.link/20260804072017.860974-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -921,7 +921,13 @@ static int bcm63xx_hsspi_resume(struct d
 		}
 	}
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		if (bs->pll_clk)
+			clk_disable_unprepare(bs->pll_clk);
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }


