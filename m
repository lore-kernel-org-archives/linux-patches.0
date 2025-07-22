Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BD52EE27B;
	Tue, 22 Jul 2025 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193490; cv=none; b=WNzMNSOivt7LLAYwsnuLb159ZOJ49LsQRiGM5AtWQIyOx/fMrTzxIvFMqL4SPB+6SR8Sxpdnz1cjsWWmp4ru0eFG6951y7GK5gmlx01XF+P4K0/VrlXmUeedQFTFUNhFyxCHue/zgLppM+P49NERnF5gz22eor5oqTrz5ur5qd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193490; c=relaxed/simple;
	bh=M6XLjpshpAYBOfVuNXaKeD2DYyfFkrs7X01Tp9Kkh8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQgJHQwc4xaSZdHGHp8Nf4ZaSi4Xonz2SfYa6XfLm9ko0AJzszNdwW/3p7NZA2THPI2XVbodyJvf0ipX3UKA4BCRzBausHKYMXttrmfJjBRh6m6br1J1dva9mrd2XT2cMs6xGNm96e9SE3UyKzYKr/HbQPs/G/mrUawgO/Ii4/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIBi0VRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIBi0VRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105E0C4CEEB;
	Tue, 22 Jul 2025 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193490;
	bh=M6XLjpshpAYBOfVuNXaKeD2DYyfFkrs7X01Tp9Kkh8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIBi0VRYTk08NkGDiEnoOUfhg/VudW45mZGQByp78IEaSsZRrfGHOi6OuQLJmEA04
	 63bkKEr9uzaz/Gg8gl+vGVtnEgu5LxKtMbQKYkLv+y5AxvGbzUH4jO9rPfOjjGJAAw
	 J4C3QIe9y/kBYVpEt+dNqEoesxrRUY6kMNxR8noY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 6.15 076/187] soc: aspeed: lpc-snoop: Dont disable channels that arent enabled
Date: Tue, 22 Jul 2025 15:44:06 +0200
Message-ID: <20250722134348.558846933@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -58,6 +58,7 @@ struct aspeed_lpc_snoop_model_data {
 };
 
 struct aspeed_lpc_snoop_channel {
+	bool enabled;
 	struct kfifo		fifo;
 	wait_queue_head_t	wq;
 	struct miscdevice	miscdev;
@@ -190,6 +191,9 @@ static int aspeed_lpc_enable_snoop(struc
 	const struct aspeed_lpc_snoop_model_data *model_data =
 		of_device_get_match_data(dev);
 
+	if (WARN_ON(lpc_snoop->chan[channel].enabled))
+		return -EBUSY;
+
 	init_waitqueue_head(&lpc_snoop->chan[channel].wq);
 	/* Create FIFO datastructure */
 	rc = kfifo_alloc(&lpc_snoop->chan[channel].fifo,
@@ -236,6 +240,8 @@ static int aspeed_lpc_enable_snoop(struc
 		regmap_update_bits(lpc_snoop->regmap, HICRB,
 				hicrb_en, hicrb_en);
 
+	lpc_snoop->chan[channel].enabled = true;
+
 	return 0;
 
 err_misc_deregister:
@@ -248,6 +254,9 @@ err_free_fifo:
 static void aspeed_lpc_disable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 				     int channel)
 {
+	if (!lpc_snoop->chan[channel].enabled)
+		return;
+
 	switch (channel) {
 	case 0:
 		regmap_update_bits(lpc_snoop->regmap, HICR5,
@@ -263,6 +272,8 @@ static void aspeed_lpc_disable_snoop(str
 		return;
 	}
 
+	lpc_snoop->chan[channel].enabled = false;
+	/* Consider improving safety wrt concurrent reader(s) */
 	misc_deregister(&lpc_snoop->chan[channel].miscdev);
 	kfifo_free(&lpc_snoop->chan[channel].fifo);
 }


