Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CF31DFF4;
	Mon,  1 Apr 2024 17:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991093; cv=none; b=bwee7bfYwb+ooyEh4kuakFALKotskAhliancWur60715/JKRSkDudZrTTHCqCHaDZUyCPECKdVGBgtJIVwq2rsrEJ0xCqkcy8iF1nXEBjM58QK47Ko5lBAcCgtozGEsZYxOnxOEAIo0mfPUQ2RRRHcU3ZrMpsuvaoiLgpKUrmpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991093; c=relaxed/simple;
	bh=7oe3U/q5xgGdILxcACAYj4Nfi1U/yFiuFGC5zRrd32s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFmr22cA2Kq2iVL/oYepRzkyy+xUkXFJNnvKxH9Tl0ONPZBOLbYjEBWxUG1vopvnWCIyHXOti6Kayi2Oy0svJHofzyyjYlQRbgvQx/JlU7/rhUa1Zfm4wZh1ajZPuz9AIP/7dJCNFer0BwM2fKigj/UnxIXMhRCigrE+XG+P2LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piUxCEK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piUxCEK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AACC433F1;
	Mon,  1 Apr 2024 17:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991092;
	bh=7oe3U/q5xgGdILxcACAYj4Nfi1U/yFiuFGC5zRrd32s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piUxCEK1G0Q/a9RZUoUxiq1RVYxuSE1+TiHq4w8NHTXmNiplZEFaU3kkNeSFFKR1R
	 QlwpSpKjkEuRoCEFCA5xY7zHQiQtUdrD1sozz2V2uFf2VkU1N82NVGFei3p/AuCouq
	 KZ24gFRDMucv8Djk9C6Tsb74zF4RKnDaC3C+7WXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.1 161/272] serial: 8250_dw: Do not reclock if already at correct rate
Date: Mon,  1 Apr 2024 17:45:51 +0200
Message-ID: <20240401152535.771156476@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Collingbourne <pcc@google.com>

commit e5d6bd25f93d6ae158bb4cd04956cb497a85b8ef upstream.

When userspace opens the console, we call set_termios() passing a
termios with the console's configured baud rate. Currently this causes
dw8250_set_termios() to disable and then re-enable the UART clock at
the same frequency as it was originally. This can cause corruption
of any concurrent console output. Fix it by skipping the reclocking
if we are already at the correct rate.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Fixes: 4e26b134bd17 ("serial: 8250_dw: clock rate handling for all ACPI platforms")
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240222192635.1050502-1-pcc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -357,9 +357,9 @@ static void dw8250_set_termios(struct ua
 	long rate;
 	int ret;
 
-	clk_disable_unprepare(d->clk);
 	rate = clk_round_rate(d->clk, newrate);
-	if (rate > 0) {
+	if (rate > 0 && p->uartclk != rate) {
+		clk_disable_unprepare(d->clk);
 		/*
 		 * Note that any clock-notifer worker will block in
 		 * serial8250_update_uartclk() until we are done.
@@ -367,8 +367,8 @@ static void dw8250_set_termios(struct ua
 		ret = clk_set_rate(d->clk, newrate);
 		if (!ret)
 			p->uartclk = rate;
+		clk_prepare_enable(d->clk);
 	}
-	clk_prepare_enable(d->clk);
 
 	dw8250_do_set_termios(p, termios, old);
 }


