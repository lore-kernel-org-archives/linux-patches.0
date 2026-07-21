Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2262343E06E;
	Tue, 21 Jul 2026 20:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667521; cv=none; b=BMnrfIrMTbOExqVWJMyEhOMYfzZBw7WJv9BeFMiVo7+Hap0aXSmNopXtFs96XuKV1aHZJM8AqKtyaF5bDHTixMMZIag5lingSvnvBq1Z53o0lCgMUI77PJ7+9ER1cWQW89B1dsx0wa9k8Nbg2HMvATzY26YKkaZENWdMoOz+AHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667521; c=relaxed/simple;
	bh=YVQtK1a4SrG9cG4qbhGtLldkI3jBqEnxQxQzZf9oxjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2CBnN6HcoHg5wuwEO9QCzXJtwgB29OjtRbJ1oOpt3Oyu7FXxiaY6yl5fxE9JL+1kXfD3Yx9OdXn/rtHldhUpyb9YW35qWAOsUNLUoKVH36xPyMhTM1ZNr/jMPHCTQpgCNXOkNfVjDDigLPYx44wzp2y/853ubaoGWkts1bw4b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVgo25J2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVgo25J2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425941F000E9;
	Tue, 21 Jul 2026 20:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667519;
	bh=Jt0dKlFkLyGZTAL7z6e2YCFhyx8iZapm1SlRKKfxeEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVgo25J2QVI0vVMw20RgAHS+rZGa8AX7kkuzapilqpbHVcGEA7TIw5trqo1UtITcZ
	 yE2CnmmZuemSpJK8NsD6MpHfL7Q5JiKErXqg2uGFmZ7C62tR2iMEzeGqgFEizdJyOI
	 flvwIBHvsEl2xwjkIBPDgEcLQkXA/rlCEzUsmuhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.6 1091/1266] ieee802154: ca8210: fix cas_ctl leak on spi_async failure
Date: Tue, 21 Jul 2026 17:25:28 +0200
Message-ID: <20260721152506.221447292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>

commit e09390e439bd7cca30dd10893b1f64802961667a upstream.

ca8210_spi_transfer() allocates cas_ctl with kzalloc_obj(GFP_ATOMIC)
and relies entirely on the SPI completion callback
ca8210_spi_transfer_complete() to free it.

The spi_async() API only invokes the completion callback on successful
submission.  On failure it returns a negative error code without ever
queuing the callback, which leaves cas_ctl and its embedded spi_message
and spi_transfer orphaned.  Every kfree(cas_ctl) in the driver is
inside the completion callback, so there is no other reclamation path.

ca8210_spi_transfer() is called from ca8210_spi_exchange(), the
interrupt handler ca8210_interrupt_handler(), and from the retry path
inside the completion callback itself.  The exchange and interrupt
handler paths loop on -EBUSY, so under sustained SPI bus contention
every retry iteration leaks a fresh cas_ctl (~600 bytes per
occurrence).

Fix it by freeing cas_ctl on the spi_async() error path.  While here,
correct the misleading error string: the function calls spi_async(),
not spi_sync().

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/20260421073259.2259783-1-shitalkumar.gandhi@cambiumnetworks.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/ca8210.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -921,9 +921,10 @@ static int ca8210_spi_transfer(
 	if (status < 0) {
 		dev_crit(
 			&spi->dev,
-			"status %d from spi_sync in write\n",
+			"status %d from spi_async in write\n",
 			status
 		);
+		kfree(cas_ctl);
 	}
 
 	return status;


