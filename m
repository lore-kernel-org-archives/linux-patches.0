Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB752566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85033C4339C;
	Tue, 18 Apr 2023 12:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821121;
	bh=g1JdaTqc+GJwXQHupKB9cJr+LsSeKB6hTeeliZTCv5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYu+/sxmRH8rab+uMucgOA8z6V3yujokpF61mvATO9Tut2/Bn7j7IDxn69F2tdS4b
	 btCh7N9DOrqH1wctOuib1Ii/tsXAEB3OUIXKgaDGt/qLEznyIMGxpm0JPFOvBbfkEp
	 bPcLbEePIED7Y1fAvVAdFz/o5is4PlKpN1Y7nI3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Federico Vaga <federico.vaga@cern.ch>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 73/92] i2c: ocores: generate stop condition after timeout in polling mode
Date: Tue, 18 Apr 2023 14:21:48 +0200
Message-Id: <20230418120307.347576921@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gregor Herburger <gregor.herburger@tq-group.com>

[ Upstream commit f8160d3b35fc94491bb0cb974dbda310ef96c0e2 ]

In polling mode, no stop condition is generated after a timeout. This
causes SCL to remain low and thereby block the bus. If this happens
during a transfer it can cause slaves to misinterpret the subsequent
transfer and return wrong values.

To solve this, pass the ETIMEDOUT error up from ocores_process_polling()
instead of setting STATE_ERROR directly. The caller is adjusted to call
ocores_process_timeout() on error both in polling and in IRQ mode, which
will set STATE_ERROR and generate a stop condition.

Fixes: 69c8c0c0efa8 ("i2c: ocores: add polling interface")
Signed-off-by: Gregor Herburger <gregor.herburger@tq-group.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Federico Vaga <federico.vaga@cern.ch>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ocores.c | 35 ++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index ca8b3ecfa93d1..1c3595c8a761a 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -343,18 +343,18 @@ static int ocores_poll_wait(struct ocores_i2c *i2c)
  * ocores_isr(), we just add our polling code around it.
  *
  * It can run in atomic context
+ *
+ * Return: 0 on success, -ETIMEDOUT on timeout
  */
-static void ocores_process_polling(struct ocores_i2c *i2c)
+static int ocores_process_polling(struct ocores_i2c *i2c)
 {
-	while (1) {
-		irqreturn_t ret;
-		int err;
+	irqreturn_t ret;
+	int err = 0;
 
+	while (1) {
 		err = ocores_poll_wait(i2c);
-		if (err) {
-			i2c->state = STATE_ERROR;
+		if (err)
 			break; /* timeout */
-		}
 
 		ret = ocores_isr(-1, i2c);
 		if (ret == IRQ_NONE)
@@ -365,13 +365,15 @@ static void ocores_process_polling(struct ocores_i2c *i2c)
 					break;
 		}
 	}
+
+	return err;
 }
 
 static int ocores_xfer_core(struct ocores_i2c *i2c,
 			    struct i2c_msg *msgs, int num,
 			    bool polling)
 {
-	int ret;
+	int ret = 0;
 	u8 ctrl;
 
 	ctrl = oc_getreg(i2c, OCI2C_CONTROL);
@@ -389,15 +391,16 @@ static int ocores_xfer_core(struct ocores_i2c *i2c,
 	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_START);
 
 	if (polling) {
-		ocores_process_polling(i2c);
+		ret = ocores_process_polling(i2c);
 	} else {
-		ret = wait_event_timeout(i2c->wait,
-					 (i2c->state == STATE_ERROR) ||
-					 (i2c->state == STATE_DONE), HZ);
-		if (ret == 0) {
-			ocores_process_timeout(i2c);
-			return -ETIMEDOUT;
-		}
+		if (wait_event_timeout(i2c->wait,
+				       (i2c->state == STATE_ERROR) ||
+				       (i2c->state == STATE_DONE), HZ) == 0)
+			ret = -ETIMEDOUT;
+	}
+	if (ret) {
+		ocores_process_timeout(i2c);
+		return ret;
 	}
 
 	return (i2c->state == STATE_DONE) ? num : -EIO;
-- 
2.39.2



