Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7826FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F777C433D2;
	Mon, 19 Dec 2022 19:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477872;
	bh=f/+yAd95iiio2Apg+GwBH2JRY4ZFWoFTDUTP3iRCvok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOtapROqR5Zop6Q1t3W22Qd0jne6KO9YJukKafhTbdZ0IB+QkjIw3yW3ki8VxWWIh
	 G8aNmtZn7YCqU09xL7kW63DWG8ljUB9GzRR3jDR9qa7mqxaUWMrWBVd5zZYxGOEAek
	 hyh5izL0/J1K49qKIgW5wJpHSYZVIytW8CykGo+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 16/25] USB: serial: f81534: fix division by zero on line-speed change
Date: Mon, 19 Dec 2022 20:22:55 +0100
Message-Id: <20221219182944.090110632@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
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

commit 188c9c2e0c7f4ae864113f80c40bafb394062271 upstream.

The driver leaves the line speed unchanged in case a requested speed is
not supported. Make sure to handle the case where the current speed is
B0 (hangup) without dividing by zero when determining the clock source.

Fixes: 3aacac02f385 ("USB: serial: f81534: add high baud rate support")
Cc: stable@vger.kernel.org      # 4.16
Cc: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/f81534.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/f81534.c
+++ b/drivers/usb/serial/f81534.c
@@ -536,9 +536,6 @@ static int f81534_submit_writer(struct u
 
 static u32 f81534_calc_baud_divisor(u32 baudrate, u32 clockrate)
 {
-	if (!baudrate)
-		return 0;
-
 	/* Round to nearest divisor */
 	return DIV_ROUND_CLOSEST(clockrate, baudrate);
 }
@@ -568,9 +565,14 @@ static int f81534_set_port_config(struct
 	u32 baud_list[] = {baudrate, old_baudrate, F81534_DEFAULT_BAUD_RATE};
 
 	for (i = 0; i < ARRAY_SIZE(baud_list); ++i) {
-		idx = f81534_find_clk(baud_list[i]);
+		baudrate = baud_list[i];
+		if (baudrate == 0) {
+			tty_encode_baud_rate(tty, 0, 0);
+			return 0;
+		}
+
+		idx = f81534_find_clk(baudrate);
 		if (idx >= 0) {
-			baudrate = baud_list[i];
 			tty_encode_baud_rate(tty, baudrate, baudrate);
 			break;
 		}


