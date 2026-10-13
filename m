Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65514EB872;
	Tue, 13 Oct 2026 12:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895372; cv=none; b=kAIxjHnw/PcX7DcxejAzFICC2INBIsy6d33Bcm5XdFkvl/U8fgUJRPYvpqRfIqyni9c8HzXvER9ehk45wlnHiDXuQ0IimEAkAqeOjlHxnz34LSleDZ+uRU20pd1DvgXavS9A2ddJaWUz8PyVJGiZcq96dDSmc4ZQKXApwO9qTgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895372; c=relaxed/simple;
	bh=hawzgfeL8j1wxOPCYznAteJCtWSuEbou27dK3XdrJxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSpgc3YgXxJXG+KgjenxFujUj2KcYCCCe6x0317Q0wwX5fPma2zBdXe+Y4HYuXDGyPPMlN8duX3m09E9gddqZSGDMBDbBm70g3D6a8zJxZ9nH1kyL1UqmOmvMgGqsq7y+zzzW/OgqxVoY8X9hmG9BVdOu2H4JG92C2sHFB356gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFK4uRsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFK4uRsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1231F008A1;
	Tue, 13 Oct 2026 12:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895370;
	bh=8AqrLVSmk5ILTgOh2HVX6jTU7D7Ul+D8mBNmuogiPAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFK4uRsve8Zq9/wXciQAiTkY5Lp9qC2zs6u7NVfU5ZQgr7IJykE3Ox/NcrhNuACEY
	 Wq/+mmX7cDgYJtviAWmAI4ntiNRqsnKasd+BYIqCo+gtyBV+sausI+0VjxpDkMeeMH
	 0yOLaU8SiziZMvzjE+jr30z/PQvLpcJ69v9yap70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Ivan Mikhaylov <fr0st61te@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 252/497] iio: proximity: vcnl3020: fix ISR bitmask check in IRQ handler
Date: Tue, 13 Oct 2026 13:36:59 +0200
Message-ID: <20261013112913.872505988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit 7d38af8f20239a66e90de7632a79c9425256c574 upstream.

The threaded IRQ handler contained multiple issues in handling interrupt
events and clearing status flags:

1. ISR bit check: The handler incorrectly checked the Interrupt Status
   Register (VCNL_ISR) against VCNL_ICR_THRES_EN (BIT(1)), which is a
   bitmask meant for the Control Register (VCNL_PS_ICR). In VCNL_ISR,
   BIT(1) corresponds only to low-threshold interrupts. A high-threshold
   interrupt (VCNL_INT_TH_HI, BIT(0)) on its own was completely ignored and
   returned IRQ_NONE.

2. Event direction & channel index: The handler unconditionally pushed a
   RISING event code on channel index 1. The driver only registers a single
   proximity channel (index 0), and low-threshold interrupts should be
   reported with IIO_EV_DIR_FALLING.

3. ISR clearing: The write-back to acknowledge the interrupt only preserved
   BIT(1) instead of masking against both valid status bits.

Fix this by checking both VCNL_INT_TH_HI and VCNL_INT_TH_LOW bits in
VCNL_ISR, pushing separate IIO events with the correct direction and
channel index (0), and properly clearing handled status bits.

Fixes: 3363fbbe19e5 ("iio: proximity: vcnl3020: add periodic mode")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Ivan Mikhaylov <fr0st61te@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/vcnl3020.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/iio/proximity/vcnl3020.c
+++ b/drivers/iio/proximity/vcnl3020.c
@@ -584,16 +584,26 @@ static irqreturn_t vcnl3020_handle_irq_t
 		return IRQ_HANDLED;
 	}
 
-	if (!(isr & VCNL_ICR_THRES_EN))
+	if (!(isr & (VCNL_INT_TH_HI | VCNL_INT_TH_LOW)))
 		return IRQ_NONE;
 
-	iio_push_event(indio_dev,
-		       IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY, 1,
-				            IIO_EV_TYPE_THRESH,
-				            IIO_EV_DIR_RISING),
-		       iio_get_time_ns(indio_dev));
+	if (isr & VCNL_INT_TH_HI) {
+		iio_push_event(indio_dev,
+			       IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY, 0,
+						    IIO_EV_TYPE_THRESH,
+						    IIO_EV_DIR_RISING),
+			       iio_get_time_ns(indio_dev));
+	}
+
+	if (isr & VCNL_INT_TH_LOW) {
+		iio_push_event(indio_dev,
+			       IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY, 0,
+						    IIO_EV_TYPE_THRESH,
+						    IIO_EV_DIR_FALLING),
+			       iio_get_time_ns(indio_dev));
+	}
 
-	rc = regmap_write(data->regmap, VCNL_ISR, isr & VCNL_ICR_THRES_EN);
+	rc = regmap_write(data->regmap, VCNL_ISR, isr & (VCNL_INT_TH_HI | VCNL_INT_TH_LOW));
 	if (rc)
 		dev_err(data->dev, "Error (%d) writing in reg (0x%x)\n",
 			rc, VCNL_ISR);


