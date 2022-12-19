Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF08D6FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D57CC433EF;
	Mon, 19 Dec 2022 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477952;
	bh=oMAzkoQPevLcgi40z9VdWz78/mwiPrfO1A/FqoCJaeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtUMCEKnUq8yX/kv7BU9yvWKUqsJ0bdSSTtrOJ7tbWZwgh93CLM5tbjLMh+MUItJD
	 Y127wGyZR1uzI/60r12Xw46hpBpdk+EgTdj7vkqkhxCmifQQJGMJx1IVh9COnVaPtV
	 kd5BPWta6xOiawBPe82RB/VmzSDZFJRuii6U88xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.0 17/28] USB: serial: f81232: fix division by zero on line-speed change
Date: Mon, 19 Dec 2022 20:23:04 +0100
Message-Id: <20221219182944.925732326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan@kernel.org>

commit a08ca6ebafe615c9028c53fc4c9e6c9b2b1f2888 upstream.

The driver leaves the line speed unchanged in case a requested speed is
not supported. Make sure to handle the case where the current speed is
B0 (hangup) without dividing by zero when determining the clock source.

Fixes: 268ddb5e9b62 ("USB: serial: f81232: add high baud rate support")
Cc: stable@vger.kernel.org      # 5.2
Cc: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/f81232.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -130,9 +130,6 @@ static u8 const clock_table[] = { F81232
 
 static int calc_baud_divisor(speed_t baudrate, speed_t clockrate)
 {
-	if (!baudrate)
-		return 0;
-
 	return DIV_ROUND_CLOSEST(clockrate, baudrate);
 }
 
@@ -498,9 +495,14 @@ static void f81232_set_baudrate(struct t
 	speed_t baud_list[] = { baudrate, old_baudrate, F81232_DEF_BAUDRATE };
 
 	for (i = 0; i < ARRAY_SIZE(baud_list); ++i) {
-		idx = f81232_find_clk(baud_list[i]);
+		baudrate = baud_list[i];
+		if (baudrate == 0) {
+			tty_encode_baud_rate(tty, 0, 0);
+			return;
+		}
+
+		idx = f81232_find_clk(baudrate);
 		if (idx >= 0) {
-			baudrate = baud_list[i];
 			tty_encode_baud_rate(tty, baudrate, baudrate);
 			break;
 		}


