Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8A92108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD34C433EF;
	Mon, 24 Apr 2023 13:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343521;
	bh=7n5COy0Bl8pm1WehfnkzFUGniLHZH6BPll5folXoacY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNkKma257TFdq8y13nbUuyEoPYu1LiNkqrMaromZPjFhQ0niEkt3wcNKMpZ1NNqZN
	 +lccHA5p1h3D1I3ga0819st6BSzYX8WLJwpwMEkaWXqY5bc0JsdRKideyl9R2wbxDc
	 jbXbfCJXELj7jSoG4i78mNY1e16VdHCSY5aNI5xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 4.19 27/29] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date: Mon, 24 Apr 2023 15:18:54 +0200
Message-Id: <20230424131122.042735111@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
References: <20230424131121.155649464@linuxfoundation.org>
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
 drivers/iio/counter/104-quad-8.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/drivers/iio/counter/104-quad-8.c
+++ b/drivers/iio/counter/104-quad-8.c
@@ -61,10 +61,6 @@ struct quad8_iio {
 
 #define QUAD8_REG_CHAN_OP 0x11
 #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -97,9 +93,6 @@ static int quad8_read_raw(struct iio_dev
 {
 	struct quad8_iio *const priv = iio_priv(indio_dev);
 	const int base_offset = priv->base + 2 * chan->channel;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
 	switch (mask) {
@@ -110,12 +103,7 @@ static int quad8_read_raw(struct iio_dev
 			return IIO_VAL_INT;
 		}
 
-		flags = inb(base_offset + 1);
-		borrow = flags & QUAD8_FLAG_BT;
-		carry = !!(flags & QUAD8_FLAG_CT);
-
-		/* Borrow XOR Carry effectively doubles count range */
-		*val = (borrow ^ carry) << 24;
+		*val = 0;
 
 		/* Reset Byte Pointer; transfer Counter to Output Latch */
 		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_CNTR_OUT,


