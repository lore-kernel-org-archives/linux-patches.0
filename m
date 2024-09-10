Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAA219F10E;
	Tue, 10 Sep 2024 10:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964017; cv=none; b=TXMxXFrQaa80ek2jYmIEkWAlm5G0klE4CB1uuAKwtcb+0I/eraIPd57+B/iZNu8n58WSaSMw0mkuR5Y5vgd++XqQSw15mixENyYIOQTZd98m6FjGHwd91EQWQ9ZgSVa1Ziv1MTtdYfAZCJ7mk0MuPbixJBka9eJX9hPEfZQzHvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964017; c=relaxed/simple;
	bh=xqBrdNDQvTvrDZJ5UIvMeu4P26nCHLNVjWpttJoSvYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XRUJJs19nnYH9TrTcTcCe7yU0w29KMcOTU2NbPLtAZbQAOAwm60QGFHWWokeiyp3Z1tnCbH2RKnIKAqLPaFw+IXU/W1zlAXmtwr2Qaiv6D+sPUsAxH4+4x+PUU74FwsS61EHO9a/Ij9xP3W9tT3hgHg5IZsJKKjfp7uXf5fCmvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXRUhoY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXRUhoY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25663C4CEC3;
	Tue, 10 Sep 2024 10:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964017;
	bh=xqBrdNDQvTvrDZJ5UIvMeu4P26nCHLNVjWpttJoSvYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXRUhoY4ZUILi+UpJsMxuJGSersrQh+Tuqhh/hpWmNn1rRAtK97eUNZe0W6MZAqDr
	 xieI95x+VeU+3nhK1JtTfQ9O/c7WrSwZ+Jr5JGlRevQUx8K60yh5yMBI3rUFJa3M55
	 KofgNB/gM1ap7YJ8QF3Gv6G8JZ6yUOinOSLpCMR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ond=C5=99ej=20Jirman?= <megi@xff.cz>,
	Brian Norris <briannorris@chromium.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 040/269] spi: rockchip: Resolve unbalanced runtime PM / system PM handling
Date: Tue, 10 Sep 2024 11:30:27 +0200
Message-ID: <20240910092609.687797274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

commit be721b451affbecc4ba4eaac3b71cdbdcade1b1b upstream.

Commit e882575efc77 ("spi: rockchip: Suspend and resume the bus during
NOIRQ_SYSTEM_SLEEP_PM ops") stopped respecting runtime PM status and
simply disabled clocks unconditionally when suspending the system. This
causes problems when the device is already runtime suspended when we go
to sleep -- in which case we double-disable clocks and produce a
WARNing.

Switch back to pm_runtime_force_{suspend,resume}(), because that still
seems like the right thing to do, and the aforementioned commit makes no
explanation why it stopped using it.

Also, refactor some of the resume() error handling, because it's not
actually a good idea to re-disable clocks on failure.

Fixes: e882575efc77 ("spi: rockchip: Suspend and resume the bus during NOIRQ_SYSTEM_SLEEP_PM ops")
Cc: stable@vger.kernel.org
Reported-by: Ondřej Jirman <megi@xff.cz>
Closes: https://lore.kernel.org/lkml/20220621154218.sau54jeij4bunf56@core/
Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://patch.msgid.link/20240827171126.1115748-1-briannorris@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-rockchip.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -974,14 +974,16 @@ static int rockchip_spi_suspend(struct d
 {
 	int ret;
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
-	struct rockchip_spi *rs = spi_controller_get_devdata(ctlr);
 
 	ret = spi_controller_suspend(ctlr);
 	if (ret < 0)
 		return ret;
 
-	clk_disable_unprepare(rs->spiclk);
-	clk_disable_unprepare(rs->apb_pclk);
+	ret = pm_runtime_force_suspend(dev);
+	if (ret < 0) {
+		spi_controller_resume(ctlr);
+		return ret;
+	}
 
 	pinctrl_pm_select_sleep_state(dev);
 
@@ -992,25 +994,14 @@ static int rockchip_spi_resume(struct de
 {
 	int ret;
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
-	struct rockchip_spi *rs = spi_controller_get_devdata(ctlr);
 
 	pinctrl_pm_select_default_state(dev);
 
-	ret = clk_prepare_enable(rs->apb_pclk);
+	ret = pm_runtime_force_resume(dev);
 	if (ret < 0)
 		return ret;
 
-	ret = clk_prepare_enable(rs->spiclk);
-	if (ret < 0)
-		clk_disable_unprepare(rs->apb_pclk);
-
-	ret = spi_controller_resume(ctlr);
-	if (ret < 0) {
-		clk_disable_unprepare(rs->spiclk);
-		clk_disable_unprepare(rs->apb_pclk);
-	}
-
-	return 0;
+	return spi_controller_resume(ctlr);
 }
 #endif /* CONFIG_PM_SLEEP */
 


