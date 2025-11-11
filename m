Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D049272E7C;
	Tue, 11 Nov 2025 01:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823963; cv=none; b=GBK+xkjwkgNCf8Xh8smiXAuBx4oo4jorrWj+Ah5KAonPLwVXA1IC/6IBVbXqWmX6pHb/fiN/JE06Jeg5GA0YMtSOkBmQ1D1Hhreurt2vBm6EG4nUdlYRJMjo108SK84yqmv0VntAq6rHfwEfzkS9LiP2IWgrW3g8z+XtBhbixw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823963; c=relaxed/simple;
	bh=ih+h+3nkgF0vkEhRpOXPZ7+fdXDJvPvJuwKhr1Eg2uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxDeLVo4MPqpaG6pl+zn1c11aALEhImrAwX5/UfIHNzjDnasPhRwRI/lBj7fHBhv3LPrWvB9G0m4nKPedj+v9rMB4ojiX8h1TFZPbaZJI1jtOilghXYUrZoMAiqgYYNmKyPx8xBBhEbhpPChoR1dsbwjj02AMOQN2ueaoRjzvH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Sk14AWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Sk14AWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D732C113D0;
	Tue, 11 Nov 2025 01:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823963;
	bh=ih+h+3nkgF0vkEhRpOXPZ7+fdXDJvPvJuwKhr1Eg2uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Sk14AWuO0c1DkjaShItSVFuipg1wykAgjAYkDAJEtCnX5CEQ1S2QGuhXKlw6lR7C
	 jYMRlCR8ND8I/mJh5ivan8XYKmCTT6nYohYOPr8SNMSp2klebnr4m+eHuXjinFsmIV
	 Pd0jNC1QCTCagMNSOTIYLtBkQj7858EaiDarx5ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 358/565] ALSA: serial-generic: remove shared static buffer
Date: Tue, 11 Nov 2025 09:43:34 +0900
Message-ID: <20251111004534.923531634@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 84973249011fda3ff292f83439a062fec81ef982 ]

If multiple instances of this driver are instantiated and try to send
concurrently then the single static buffer snd_serial_generic_tx_work()
will cause corruption in the data output.

Move the buffer into the per-instance driver data to avoid this.

Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/serial-generic.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/drivers/serial-generic.c b/sound/drivers/serial-generic.c
index 36409a56c675e..d0e2e656c31c1 100644
--- a/sound/drivers/serial-generic.c
+++ b/sound/drivers/serial-generic.c
@@ -37,6 +37,8 @@ MODULE_LICENSE("GPL");
 #define SERIAL_TX_STATE_ACTIVE	1
 #define SERIAL_TX_STATE_WAKEUP	2
 
+#define INTERNAL_BUF_SIZE 256
+
 struct snd_serial_generic {
 	struct serdev_device *serdev;
 
@@ -51,6 +53,7 @@ struct snd_serial_generic {
 	struct work_struct tx_work;
 	unsigned long tx_state;
 
+	char tx_buf[INTERNAL_BUF_SIZE];
 };
 
 static void snd_serial_generic_tx_wakeup(struct snd_serial_generic *drvdata)
@@ -61,11 +64,8 @@ static void snd_serial_generic_tx_wakeup(struct snd_serial_generic *drvdata)
 	schedule_work(&drvdata->tx_work);
 }
 
-#define INTERNAL_BUF_SIZE 256
-
 static void snd_serial_generic_tx_work(struct work_struct *work)
 {
-	static char buf[INTERNAL_BUF_SIZE];
 	int num_bytes;
 	struct snd_serial_generic *drvdata = container_of(work, struct snd_serial_generic,
 						   tx_work);
@@ -78,8 +78,10 @@ static void snd_serial_generic_tx_work(struct work_struct *work)
 		if (!test_bit(SERIAL_MODE_OUTPUT_OPEN, &drvdata->filemode))
 			break;
 
-		num_bytes = snd_rawmidi_transmit_peek(substream, buf, INTERNAL_BUF_SIZE);
-		num_bytes = serdev_device_write_buf(drvdata->serdev, buf, num_bytes);
+		num_bytes = snd_rawmidi_transmit_peek(substream, drvdata->tx_buf,
+						      INTERNAL_BUF_SIZE);
+		num_bytes = serdev_device_write_buf(drvdata->serdev, drvdata->tx_buf,
+						    num_bytes);
 
 		if (!num_bytes)
 			break;
-- 
2.51.0



