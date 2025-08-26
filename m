Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42772352089;
	Tue, 26 Aug 2025 14:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217120; cv=none; b=UkN1jwvJ+FbXi2BxpS2vi5o7v2b4wpH1SdeFD+jEvzJPz7t+oEj/k2jblMThvfz3CCGSAd2OEq1e0WLajQNWAOsbkkz7JvxDtMHi7OX08Vq98LDsxIaL/rNJS8YQFDhjGuN3acUPoB74vzkmBU5n8QJ0gbyzFFrM/gPSmw6DZLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217120; c=relaxed/simple;
	bh=M6jOZIhYaHzIPlwYXj6cGElJB2tYk1MXfEYWbAXBKF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3l0xabL6QP2/luH8QEHF+endzPjjPBOFMV/soBn3BLjBUiblA8IVoyQG+S8VHCwEFQbZOJSBI3k1+AGqdUaaDYa9wgZ44Pluq0KgxTsVZBpXxbSKf8rFzUxsifJjdcTC/MooZugNaPeTsbIUMZLV0vEe/Rj1FKPAXA/hD33uWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edCqaW2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edCqaW2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1ACC113CF;
	Tue, 26 Aug 2025 14:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217120;
	bh=M6jOZIhYaHzIPlwYXj6cGElJB2tYk1MXfEYWbAXBKF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edCqaW2e2sxH1hOkTHZ9onUKL6Nj6r6OE8AHDITysjTaQfoD+hTzFI8H888igU5mv
	 G5ctCXHAVGiCA7wuEF1bf6t4xrndCgoKlSNc4kpsfrPSdim6/e6dROyPXBqaAVB6qP
	 CDrRfLVykr9CLWzXWmz1u/873vN5QtsXzDTs7SMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 5.10 023/523] soc: aspeed: lpc-snoop: Dont disable channels that arent enabled
Date: Tue, 26 Aug 2025 13:03:53 +0200
Message-ID: <20250826110925.163776108@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andrew Jeffery <andrew@codeconstruct.com.au>

commit 56448e78a6bb4e1a8528a0e2efe94eff0400c247 upstream.

Mitigate e.g. the following:

    # echo 1e789080.lpc-snoop > /sys/bus/platform/drivers/aspeed-lpc-snoop/unbind
    ...
    [  120.363594] Unable to handle kernel NULL pointer dereference at virtual address 00000004 when write
    [  120.373866] [00000004] *pgd=00000000
    [  120.377910] Internal error: Oops: 805 [#1] SMP ARM
    [  120.383306] CPU: 1 UID: 0 PID: 315 Comm: sh Not tainted 6.15.0-rc1-00009-g926217bc7d7d-dirty #20 NONE
    ...
    [  120.679543] Call trace:
    [  120.679559]  misc_deregister from aspeed_lpc_snoop_remove+0x84/0xac
    [  120.692462]  aspeed_lpc_snoop_remove from platform_remove+0x28/0x38
    [  120.700996]  platform_remove from device_release_driver_internal+0x188/0x200
    ...

Fixes: 9f4f9ae81d0a ("drivers/misc: add Aspeed LPC snoop driver")
Cc: stable@vger.kernel.org
Cc: Jean Delvare <jdelvare@suse.de>
Acked-by: Jean Delvare <jdelvare@suse.de>
Link: https://patch.msgid.link/20250616-aspeed-lpc-snoop-fixes-v2-2-3cdd59c934d3@codeconstruct.com.au
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/aspeed/aspeed-lpc-snoop.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -60,6 +60,7 @@ struct aspeed_lpc_snoop_model_data {
 };
 
 struct aspeed_lpc_snoop_channel {
+	bool enabled;
 	struct kfifo		fifo;
 	wait_queue_head_t	wq;
 	struct miscdevice	miscdev;
@@ -192,6 +193,9 @@ static int aspeed_lpc_enable_snoop(struc
 	const struct aspeed_lpc_snoop_model_data *model_data =
 		of_device_get_match_data(dev);
 
+	if (WARN_ON(lpc_snoop->chan[channel].enabled))
+		return -EBUSY;
+
 	init_waitqueue_head(&lpc_snoop->chan[channel].wq);
 	/* Create FIFO datastructure */
 	rc = kfifo_alloc(&lpc_snoop->chan[channel].fifo,
@@ -238,6 +242,8 @@ static int aspeed_lpc_enable_snoop(struc
 		regmap_update_bits(lpc_snoop->regmap, HICRB,
 				hicrb_en, hicrb_en);
 
+	lpc_snoop->chan[channel].enabled = true;
+
 	return 0;
 
 err_misc_deregister:
@@ -250,6 +256,9 @@ err_free_fifo:
 static void aspeed_lpc_disable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 				     int channel)
 {
+	if (!lpc_snoop->chan[channel].enabled)
+		return;
+
 	switch (channel) {
 	case 0:
 		regmap_update_bits(lpc_snoop->regmap, HICR5,
@@ -265,6 +274,8 @@ static void aspeed_lpc_disable_snoop(str
 		return;
 	}
 
+	lpc_snoop->chan[channel].enabled = false;
+	/* Consider improving safety wrt concurrent reader(s) */
 	misc_deregister(&lpc_snoop->chan[channel].miscdev);
 	kfifo_free(&lpc_snoop->chan[channel].fifo);
 }


