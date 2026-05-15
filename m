Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF0A3C0607;
	Fri, 15 May 2026 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862051; cv=none; b=H4619BF/xIQpCeUvDvtEgszmkbte0EEVJg4X8pkfhsrqjRhvxXZYL/iEqkNEOGyBxmVljW4mcs5UTx+XFuerPP2nt31rb3j/BrD3BurIB2GoLwJINayi+se/IgSN8NAfBjypmygl3Palp6UfYxNOuFi0cEnsfykbu9/6ArKj0Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862051; c=relaxed/simple;
	bh=ZVBGNTJLFrStW3mxfL3n3j/6o5q/9logcNAUv11O4HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5wg5f9C4+CDlWqwP0vBUoD1F7Wp5AqapXJYI1urmOQgjwxpI5tv8xd9PWOvREhxR8tP/Lz6QECr3axwzm3ABihLrbSNMnPUQCdXngAxSTm/P2YbClcP4TaRqajN+QzB18MBdzs2OIBoi1gzb8IRN+pMNsE2G+gBEzkcOpdAZnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1pRRMSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1pRRMSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101B6C2BCB0;
	Fri, 15 May 2026 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862051;
	bh=ZVBGNTJLFrStW3mxfL3n3j/6o5q/9logcNAUv11O4HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1pRRMSAH3y4Bv9ahxWxOFk6Z02rT4oXQh88LRmD5/io0PzNUKy6JG8sfKO4M0c4A
	 Nm2wWGlKV6WP2hlYzQXvZN7EIiqE3tJiGmiAn7uDjDf1sK9gybZAg5Z4hXNRHpeIQf
	 mYp8r32r/Vmoy/rGwtSw2yoH11RXfvpDO7qq/wOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 089/188] spi: orion: fix runtime pm leak on unbind
Date: Fri, 15 May 2026 17:48:26 +0200
Message-ID: <20260515154659.256740472@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 97b17dd8266d2e26d9ee3c75a0fa34ecde6944f0 upstream.

Make sure to balance the runtime PM usage count on driver unbind so that
the controller can be suspended when a driver is rebound.

Also restore the autosuspend setting.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: 5c6786945b4e ("spi: spi-orion: add runtime PM support")
Cc: stable@vger.kernel.org	# 3.17
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=6
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421130211.1537628-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-orion.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -812,6 +812,9 @@ static void orion_spi_remove(struct plat
 	spi_controller_put(host);
 
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 }
 
 MODULE_ALIAS("platform:" DRIVER_NAME);


