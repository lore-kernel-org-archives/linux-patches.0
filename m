Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDD57E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B711EC433C1;
	Wed,  2 Nov 2022 03:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358095;
	bh=0BEUI3eToLJ3v8OyESkT1kMG5CoOsCroTUEPLE7vMno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIzd8uP0PAt1y8MB/s4ldeBZAetQrz5tPx3QlfXeJmbQUKBN7wFEuM158A8gkHWTJ
	 Pe4YciT4MG6r+yknLoO1jmCM3LeEN9jMXbxZhLgGhR8jHenOvfxrJGjat7bqpWQEYm
	 NK1JdVfmKj6ZJ7x/QSLtTh4lXZif1Zd8o22RYM+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamel Bouhara <kamel.bouhara@bootlin.com>,
	William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 5.15 040/132] counter: microchip-tcb-capture: Handle Signal1 read and Synapse
Date: Wed,  2 Nov 2022 03:32:26 +0100
Message-Id: <20221102022100.681708162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: William Breathitt Gray <william.gray@linaro.org>

commit d917a62af81b133f35f627e7936e193c842a7947 upstream.

The signal_read(), action_read(), and action_write() callbacks have been
assuming Signal0 is requested without checking. This results in requests
for Signal1 returning data for Signal0. This patch fixes these
oversights by properly checking for the Signal's id in the respective
callbacks and handling accordingly based on the particular Signal
requested. The trig_inverted member of the mchp_tc_data is removed as
superfluous.

Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
Cc: stable@vger.kernel.org
Reviewed-by: Kamel Bouhara <kamel.bouhara@bootlin.com>
Link: https://lore.kernel.org/r/20221018121014.7368-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/microchip-tcb-capture.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -29,7 +29,6 @@ struct mchp_tc_data {
 	int qdec_mode;
 	int num_channels;
 	int channel[2];
-	bool trig_inverted;
 };
 
 enum mchp_tc_count_function {
@@ -166,7 +165,7 @@ static int mchp_tc_count_signal_read(str
 
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], SR), &sr);
 
-	if (priv->trig_inverted)
+	if (signal->id == 1)
 		sigstatus = (sr & ATMEL_TC_MTIOB);
 	else
 		sigstatus = (sr & ATMEL_TC_MTIOA);
@@ -184,6 +183,17 @@ static int mchp_tc_count_action_get(stru
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 cmr;
 
+	if (priv->qdec_mode) {
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
+		return 0;
+	}
+
+	/* Only TIOA signal is evaluated in non-QDEC mode */
+	if (synapse->signal->id != 0) {
+		*action = COUNTER_SYNAPSE_ACTION_NONE;
+		return 0;
+	}
+
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], CMR), &cmr);
 
 	switch (cmr & ATMEL_TC_ETRGEDG) {
@@ -212,8 +222,8 @@ static int mchp_tc_count_action_set(stru
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 edge = ATMEL_TC_ETRGEDG_NONE;
 
-	/* QDEC mode is rising edge only */
-	if (priv->qdec_mode)
+	/* QDEC mode is rising edge only; only TIOA handled in non-QDEC mode */
+	if (priv->qdec_mode || synapse->signal->id != 0)
 		return -EINVAL;
 
 	switch (action) {


