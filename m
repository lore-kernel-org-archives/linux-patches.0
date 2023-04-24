Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984C17C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C549C433D2;
	Mon, 24 Apr 2023 13:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342510;
	bh=/OLmyZE12K7PKskW1Q9yKeMtOE5uPBfrXASfVYl5gbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVB8+qLE/bhm4FrySmV1wiVTBh/wApD/mDRIUtJ/rV/ENIxpHwJ9TiCE3nKchxPgL
	 bB0h2982GtdZSjHU9tcNEf8b4Qg5YuMdJRVbgoenNalMCc50yWCIaiKitVTkFj+7Ad
	 xKJCOe83Kn/Z3cSRjfr9rq6IfvdIPg7tYWKbKIi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 5.15 66/73] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date: Mon, 24 Apr 2023 15:17:20 +0200
Message-Id: <20230424131131.522238893@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
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

commit 4aa3b75c74603c3374877d5fd18ad9cc3a9a62ed upstream.

The Counter (CNTR) register is 24 bits wide, but we can have an
effective 25-bit count value by setting bit 24 to the XOR of the Borrow
flag and Carry flag. The flags can be read from the FLAG register, but a
race condition exists: the Borrow flag and Carry flag are instantaneous
and could change by the time the count value is read from the CNTR
register.

Since the race condition could result in an incorrect 25-bit count
value, remove support for 25-bit count values from this driver;
hard-coded maximum count values are replaced by a LS7267_CNTR_MAX define
for consistency and clarity.

Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-QUAD-8")
Cc: <stable@vger.kernel.org> # 6.1.x
Cc: <stable@vger.kernel.org> # 6.2.x
Link: https://lore.kernel.org/r/20230312231554.134858-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/104-quad-8.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -61,10 +61,6 @@ struct quad8 {
 #define QUAD8_REG_CHAN_OP 0x11
 #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
 #define QUAD8_DIFF_ENCODER_CABLE_STATUS 0x17
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -97,6 +93,9 @@ struct quad8 {
 #define QUAD8_CMR_QUADRATURE_X2 0x10
 #define QUAD8_CMR_QUADRATURE_X4 0x18
 
+/* Each Counter is 24 bits wide */
+#define LS7267_CNTR_MAX GENMASK(23, 0)
+
 static int quad8_signal_read(struct counter_device *counter,
 			     struct counter_signal *signal,
 			     enum counter_signal_level *level)
@@ -121,17 +120,9 @@ static int quad8_count_read(struct count
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
-	flags = inb(base_offset + 1);
-	borrow = flags & QUAD8_FLAG_BT;
-	carry = !!(flags & QUAD8_FLAG_CT);
-
-	/* Borrow XOR Carry effectively doubles count range */
-	*val = (unsigned long)(borrow ^ carry) << 24;
+	*val = 0;
 
 	mutex_lock(&priv->lock);
 
@@ -154,8 +145,7 @@ static int quad8_count_write(struct coun
 	const int base_offset = priv->base + 2 * count->id;
 	int i;
 
-	/* Only 24-bit values are supported */
-	if (val > 0xFFFFFF)
+	if (val > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	mutex_lock(&priv->lock);
@@ -627,8 +617,7 @@ static int quad8_count_preset_write(stru
 {
 	struct quad8 *const priv = counter->priv;
 
-	/* Only 24-bit values are supported */
-	if (preset > 0xFFFFFF)
+	if (preset > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	mutex_lock(&priv->lock);
@@ -654,8 +643,7 @@ static int quad8_count_ceiling_read(stru
 		*ceiling = priv->preset[count->id];
 		break;
 	default:
-		/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-		*ceiling = 0x1FFFFFF;
+		*ceiling = LS7267_CNTR_MAX;
 		break;
 	}
 
@@ -669,8 +657,7 @@ static int quad8_count_ceiling_write(str
 {
 	struct quad8 *const priv = counter->priv;
 
-	/* Only 24-bit values are supported */
-	if (ceiling > 0xFFFFFF)
+	if (ceiling > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	mutex_lock(&priv->lock);


