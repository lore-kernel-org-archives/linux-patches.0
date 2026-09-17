Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C684E01F9;
	Thu, 17 Sep 2026 15:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660362; cv=none; b=qI327OehF58MQYTOgg4drHZZt6uZkKW7NlvXKTRlfJVMQ4qSp/4yZpsyiJ4RpLcpaZCoxCx4KNvm5JadvTDogWD+ehRBcQbosDsg0lkgQlLYUwLhsfpUhQDvZcQIa12NOs6jW4rltst8vr/nqP/KWJbWmZsD8pg3z7okMrwo4Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660362; c=relaxed/simple;
	bh=ix8XAZxvzrF5Hz5jbRAL8HQD8rneSwvxDcxrTzprXRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5iEdmt1GIFZX8eC8VfSm6D2GOAVsmg1nf/JDThaP+oAOXgvsgchTlPoZdVrDSbE05agQzNzXSCGV3scq/PSqSr5c5yA8VaEGmKjOWzVYayxaXdvQiclLvTX9sDpC4hDk2Euhm4TRbNSvNYO8evUq/ZstxKGAy/VT/xDXLSv1Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlX4L9nA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlX4L9nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFBA1F000FF;
	Thu, 17 Sep 2026 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660360;
	bh=7hNAALEoGksf1AHsD60xOTPCRCusmXzyexMtGgGiNTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlX4L9nA2EAtBWEx9fviSScVRgNSon5cHI6aVlYicEuXSMkkdkg0hUuup/avrJq1p
	 sBKBnEFQORxwVhbN/YmvC/b/SMT7OH6LQTmiKMbicUGyIYy3lCnUB4eiQnRoHOf4At
	 9lOTAYZXZl6ZhhLqGeoM0/twJP4qickQN0e4BbYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 7.2 565/733] ieee802154: cc2520: fix FIFOP work use-after-free
Date: Thu, 17 Sep 2026 16:14:33 +0100
Message-ID: <20260917151406.407177267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit ff5891b266a7fc6a062710836be84f1cc19338b5 upstream.

The FIFOP interrupt handler queues cc2520_fifop_irqwork.  On removal,
cc2520_remove() only flushes the work.  The devm-managed FIFOP IRQ
remains active until after ->remove() returns and can queue the work
again after that flush, allowing it to run after the private data is
released.

Disable the work with disable_work_sync() instead of flushing it, so
the handler can no longer queue it once removal begins.  Destroy the
buffer mutex last, since the worker and the stop callback invoked
through ieee802154_unregister_hw() both take it.

Found by an in-house static analysis tool.

Fixes: 0da6bc8cc341 ("ieee802154: cc2520: adds driver for TI CC2520 radio")
Cc: stable@vger.kernel.org # v6.10+
Suggested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://lore.kernel.org/20260812061714.175966-1-fanwu01@zju.edu.cn
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/cc2520.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -1156,11 +1156,10 @@ static void cc2520_remove(struct spi_dev
 {
 	struct cc2520_private *priv = spi_get_drvdata(spi);
 
-	mutex_destroy(&priv->buffer_mutex);
-	flush_work(&priv->fifop_irqwork);
-
+	disable_work_sync(&priv->fifop_irqwork);
 	ieee802154_unregister_hw(priv->hw);
 	ieee802154_free_hw(priv->hw);
+	mutex_destroy(&priv->buffer_mutex);
 }
 
 static const struct spi_device_id cc2520_ids[] = {


