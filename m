Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDAEB641;
	Tue, 16 Jul 2024 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144289; cv=none; b=Gj1b/dwCSHTJzPcwa6R9m5tdvKOht5ZOapoC+/nAtX5isWLDZlcqyuWYxX+5GWhGLjCtE2WrcI4oZZI5DNEI87fqGe2t4oexpq4M+eXiv+B2VpbSE8PJQaL9NR70gR+31sg2cG4c7m8tfG74Yl9EW1mS1yKZjhOfJVQDF8ibQsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144289; c=relaxed/simple;
	bh=sw/ADidbGpcAS9m5mlXUuRtoKd6JhUZq0zkcHkYKTzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjrQ8jGemlTkPEuagx/1Hm7Mlswmwc21wi4/MAzvufApCeGHsEIZoBvYoeqDGxhjfYoFIchq8BiQpJk+e89tcN6I8wbk+uK4yPx/8jk55vmxqx+6eN/ivqxfYJwWP2ZsCqbzlkKkuvkpSE1/+9+AmJ08MbRRq8kfeR6mcPLVpbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdOIIsYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdOIIsYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC25C116B1;
	Tue, 16 Jul 2024 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144289;
	bh=sw/ADidbGpcAS9m5mlXUuRtoKd6JhUZq0zkcHkYKTzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdOIIsYyNXRFYZLN5LN20kc5mHYmMOQMGOWxBcNPZQ+ikBkkQUgPn+tw2DS1MBmoD
	 FBFutLUts8so1fbbacdy3+5xvOSmOhHvHMM+NChdvRUFuJvOsRdYX9q/MM6hGEG66F
	 Vue+CPxOffS2FxbHXjJGYT4h3X4KZps7owYXy//Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bunk <micha@freedict.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/78] media: dw2102: Dont translate i2c read into write
Date: Tue, 16 Jul 2024 17:30:40 +0200
Message-ID: <20240716152740.950452496@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bunk <micha@freedict.org>

[ Upstream commit 0e148a522b8453115038193e19ec7bea71403e4a ]

The code ignored the I2C_M_RD flag on I2C messages.  Instead it assumed
an i2c transaction with a single message must be a write operation and a
transaction with two messages would be a read operation.

Though this works for the driver code, it leads to problems once the i2c
device is exposed to code not knowing this convention.  For example,
I did "insmod i2c-dev" and issued read requests from userspace, which
were translated into write requests and destroyed the EEPROM of my
device.

So, just check and respect the I2C_M_READ flag, which indicates a read
when set on a message.  If it is absent, it is a write message.

Incidentally, changing from the case statement to a while loop allows
the code to lift the limitation to two i2c messages per transaction.

There are 4 more *_i2c_transfer functions affected by the same behaviour
and limitation that should be fixed in the same way.

Link: https://lore.kernel.org/linux-media/20220116112238.74171-2-micha@freedict.org
Signed-off-by: Michael Bunk <micha@freedict.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dw2102.c | 120 ++++++++++++++++++-----------
 1 file changed, 73 insertions(+), 47 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 924a6478007a8..ff5b007e2d99d 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -716,6 +716,7 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct dw2102_state *state;
+	int j;
 
 	if (!d)
 		return -ENODEV;
@@ -729,11 +730,11 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		return -EAGAIN;
 	}
 
-	switch (num) {
-	case 1:
-		switch (msg[0].addr) {
+	j = 0;
+	while (j < num) {
+		switch (msg[j].addr) {
 		case SU3000_STREAM_CTRL:
-			state->data[0] = msg[0].buf[0] + 0x36;
+			state->data[0] = msg[j].buf[0] + 0x36;
 			state->data[1] = 3;
 			state->data[2] = 0;
 			if (dvb_usb_generic_rw(d, state->data, 3,
@@ -745,61 +746,86 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (dvb_usb_generic_rw(d, state->data, 1,
 					state->data, 2, 0) < 0)
 				err("i2c transfer failed.");
-			msg[0].buf[1] = state->data[0];
-			msg[0].buf[0] = state->data[1];
+			msg[j].buf[1] = state->data[0];
+			msg[j].buf[0] = state->data[1];
 			break;
 		default:
-			if (3 + msg[0].len > sizeof(state->data)) {
-				warn("i2c wr: len=%d is too big!\n",
-				     msg[0].len);
+			/* if the current write msg is followed by a another
+			 * read msg to/from the same address
+			 */
+			if ((j+1 < num) && (msg[j+1].flags & I2C_M_RD) &&
+			    (msg[j].addr == msg[j+1].addr)) {
+				/* join both i2c msgs to one usb read command */
+				if (4 + msg[j].len > sizeof(state->data)) {
+					warn("i2c combined wr/rd: write len=%d is too big!\n",
+					    msg[j].len);
+					num = -EOPNOTSUPP;
+					break;
+				}
+				if (1 + msg[j+1].len > sizeof(state->data)) {
+					warn("i2c combined wr/rd: read len=%d is too big!\n",
+					    msg[j+1].len);
+					num = -EOPNOTSUPP;
+					break;
+				}
+
+				state->data[0] = 0x09;
+				state->data[1] = msg[j].len;
+				state->data[2] = msg[j+1].len;
+				state->data[3] = msg[j].addr;
+				memcpy(&state->data[4], msg[j].buf, msg[j].len);
+
+				if (dvb_usb_generic_rw(d, state->data, msg[j].len + 4,
+					state->data, msg[j+1].len + 1, 0) < 0)
+					err("i2c transfer failed.");
+
+				memcpy(msg[j+1].buf, &state->data[1], msg[j+1].len);
+				j++;
+				break;
+			}
+
+			if (msg[j].flags & I2C_M_RD) {
+				/* single read */
+				if (1 + msg[j].len > sizeof(state->data)) {
+					warn("i2c rd: len=%d is too big!\n", msg[j].len);
+					num = -EOPNOTSUPP;
+					break;
+				}
+
+				state->data[0] = 0x09;
+				state->data[1] = 0;
+				state->data[2] = msg[j].len;
+				state->data[3] = msg[j].addr;
+				memcpy(&state->data[4], msg[j].buf, msg[j].len);
+
+				if (dvb_usb_generic_rw(d, state->data, 4,
+					state->data, msg[j].len + 1, 0) < 0)
+					err("i2c transfer failed.");
+
+				memcpy(msg[j].buf, &state->data[1], msg[j].len);
+				break;
+			}
+
+			/* single write */
+			if (3 + msg[j].len > sizeof(state->data)) {
+				warn("i2c wr: len=%d is too big!\n", msg[j].len);
 				num = -EOPNOTSUPP;
 				break;
 			}
 
-			/* always i2c write*/
 			state->data[0] = 0x08;
-			state->data[1] = msg[0].addr;
-			state->data[2] = msg[0].len;
+			state->data[1] = msg[j].addr;
+			state->data[2] = msg[j].len;
 
-			memcpy(&state->data[3], msg[0].buf, msg[0].len);
+			memcpy(&state->data[3], msg[j].buf, msg[j].len);
 
-			if (dvb_usb_generic_rw(d, state->data, msg[0].len + 3,
+			if (dvb_usb_generic_rw(d, state->data, msg[j].len + 3,
 						state->data, 1, 0) < 0)
 				err("i2c transfer failed.");
+		} // switch
+		j++;
 
-		}
-		break;
-	case 2:
-		/* always i2c read */
-		if (4 + msg[0].len > sizeof(state->data)) {
-			warn("i2c rd: len=%d is too big!\n",
-			     msg[0].len);
-			num = -EOPNOTSUPP;
-			break;
-		}
-		if (1 + msg[1].len > sizeof(state->data)) {
-			warn("i2c rd: len=%d is too big!\n",
-			     msg[1].len);
-			num = -EOPNOTSUPP;
-			break;
-		}
-
-		state->data[0] = 0x09;
-		state->data[1] = msg[0].len;
-		state->data[2] = msg[1].len;
-		state->data[3] = msg[0].addr;
-		memcpy(&state->data[4], msg[0].buf, msg[0].len);
-
-		if (dvb_usb_generic_rw(d, state->data, msg[0].len + 4,
-					state->data, msg[1].len + 1, 0) < 0)
-			err("i2c transfer failed.");
-
-		memcpy(msg[1].buf, &state->data[1], msg[1].len);
-		break;
-	default:
-		warn("more than 2 i2c messages at a time is not handled yet.");
-		break;
-	}
+	} // while
 	mutex_unlock(&d->data_mutex);
 	mutex_unlock(&d->i2c_mutex);
 	return num;
-- 
2.43.0



