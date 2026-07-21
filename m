Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8993368A5;
	Tue, 21 Jul 2026 20:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667121; cv=none; b=OPGp6L6WqkoggJw6M0Y8pF6Nxf2f7xSvFe0aCc94rIumfG1nt+L8LSYjxCvhnuBfqWM8a72MYa1wOAxqE6eczv0gZRL0fhBALFwQPuRJIdBgh98YS0vOk436czFiHbB0Sp/PlzMuvzSgMr8pB7q9dwLtMYhBLVZr8aK5XRFNEow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667121; c=relaxed/simple;
	bh=d7ES6wBYUs8p2WtmYaBSK5RRrke95RDg2vDpN6RFdbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9aZ7Ok+M9ooKLxqQZuAOl4xUzoG6RT60p/E93tQOWF0hmuz5uGuBpYwCTgLwI3r2h9CXQL8FB5k5Hd8nJy2CGRoih6JWQ6LFcU5uenbtGSFpb8OXcgd17rFJ/6Dt54Mj1u/HNc0OFrEw9ayiVpp5EpvrxDJxK4WR5jG/RlDPrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxmZFry7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxmZFry7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3971F000E9;
	Tue, 21 Jul 2026 20:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667120;
	bh=PcwA9Vc7+6aCX4b73zJ0C5VIOQmvE6I8eQvovjTh29I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wxmZFry7pOzO7kWPfrJQHAT/PsUhBdi9NAdtFP835Uyu4i5DBCzuA3hxdm0FcYnuf
	 YGdtV5HKTK9W3m2b86l0b21y/jFJ/Pjq16NafiAv5no1aAheGsUd6YLFYhEUImF/xY
	 xVn2D6WHcQjuxER8wvZ5dn6VOhbf8AlqvCHF14F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 6.6 0941/1266] x86/boot: Validate console=uart8250 baud rate to fix early boot hang
Date: Tue, 21 Jul 2026 17:22:58 +0200
Message-ID: <20260721152502.889092525@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit ffa0aa5b625fe0bed7463ac613f8b06676ff4542 upstream.

When the baud rate is empty, 0, invalid, or overflows to 0 when stored
as an int, the system will hang during early boot because of a division
by zero in early_serial_init().

Fall back to DEFAULT_BAUD when the resulting baud rate is 0 to prevent
an early system hang.

Fixes: ce0aa5dd20e4 ("x86, setup: Make the setup code also accept console=uart8250")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260713194924.126472-3-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/early_serial_console.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -117,7 +117,7 @@ static unsigned int probe_baud(int port)
 static void parse_console_uart8250(void)
 {
 	char optstr[64], *options;
-	int baud = DEFAULT_BAUD;
+	int baud;
 	int port = 0;
 
 	/*
@@ -136,10 +136,13 @@ static void parse_console_uart8250(void)
 	else
 		return;
 
-	if (options && (options[0] == ','))
-		baud = simple_strtoull(options + 1, &options, 0);
-	else
+	if (options && (options[0] == ',')) {
+		baud = simple_strtoull(options + 1, NULL, 0);
+		if (!baud)
+			baud = DEFAULT_BAUD;
+	} else {
 		baud = probe_baud(port);
+	}
 
 	if (port)
 		early_serial_init(port, baud);


