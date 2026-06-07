Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76C21E98EF;
	Sun,  7 Jun 2026 10:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829072; cv=none; b=Z/NzcaN68CCXMS+ywsydhe3UhxQs2kSWwRz8A0tfHLBrZTdKrybs8jUEc1X/YrCkNW1jle0/ImVLEbeu6NOCae1Tv05QdOj75E662CnYLg7PQ42v+ynXrBW4AilmxOK2cDvSzH8aSL0RY+iYtLvugu/4bHG3MIBsXuJk+XSBxLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829072; c=relaxed/simple;
	bh=fhzpCDNUnQ1IiczapelJpnkC9LgSgcHLhKNG2rfUc7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9kYx3RLUS1k/tIpoG+cOWZiPVOu43djzih8UsscD3G0g52DDA01YZ7HnnYwb4LgON3UnFSvsvJw8ew2v3zuGuevXLwDR3A8pfz0200S0AkqmECGZGScgElFltSONwN5neK+wV3oz2o58/1d7KZK60JVNHAYUzxjGzeJewwLfW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI0XGoTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI0XGoTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EA81F00893;
	Sun,  7 Jun 2026 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829071;
	bh=NSTOCLxVj83RpxtcypVEgmoy/AWesUKcnwDXh9wvU7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fI0XGoTOsS8ln6Xz7mBukRGvVOphN1hFzKzTsDZJtqmBcRTdGM7hHb+XXFM0hd7tO
	 1UIsAAgX/GczpE4wOwOCBI3GxZeGSOgdqwAAXU62HPsu7X8epOwdRqEcSrYBZh0hj2
	 n7qlBVa90w/Zg+/ELTHy2+55MBMsyxrMA61lsMck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 7.0 243/332] gpib: cb7210: Fix region leak when request_irq fails
Date: Sun,  7 Jun 2026 12:00:12 +0200
Message-ID: <20260607095736.972391850@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

commit 2eae90a457baa0048a96ed38ad93090ee38c8b2f upstream.

When request_irq() fails, the region allocated by request_region()
is not released. Fix this by adding an error handling path with
proper goto labels to release the region.

Fixes: e9dc69956d4d ("staging: gpib: Add Computer Boards GPIB driver")
Closes: https://lore.kernel.org/oe-kbuild-all/202605160620.ReBOadPX-lkp@intel.com/
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260518022939.16881-1-zenghongling@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpib/cb7210/cb7210.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpib/cb7210/cb7210.c
+++ b/drivers/gpib/cb7210/cb7210.c
@@ -1049,7 +1049,8 @@ static int cb_isa_attach(struct gpib_boa
 	if (!request_region(config->ibbase, cb7210_iosize, DRV_NAME)) {
 		dev_err(board->gpib_dev, "ioports starting at 0x%x are already in use\n",
 			config->ibbase);
-		return -EBUSY;
+		retval = -EBUSY;
+		goto err_release_region;
 	}
 	nec_priv->iobase = config->ibbase;
 	cb_priv->fifo_iobase = nec7210_iobase(cb_priv);
@@ -1062,11 +1063,16 @@ static int cb_isa_attach(struct gpib_boa
 	// install interrupt handler
 	if (request_irq(config->ibirq, cb7210_interrupt, isr_flags, DRV_NAME, board)) {
 		dev_err(board->gpib_dev, "failed to obtain IRQ %d\n", config->ibirq);
-		return -EBUSY;
+		retval = -EBUSY;
+		goto err_release_region;
 	}
 	cb_priv->irq = config->ibirq;
 
 	return cb7210_init(cb_priv, board);
+
+err_release_region:
+	release_region(nec7210_iobase(cb_priv), cb7210_iosize);
+	return retval;
 }
 
 static void cb_isa_detach(struct gpib_board *board)


