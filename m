Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620684;
	b=RiwEzvb3bGQ99LrX6GvEjbYYZSPAgcHmRRuU5nMS9yjCRB13AS6PpbJ+yXk6rXea84VP
	 MiDa8J10e/1mqe0Ef7hTvRj6XllnVQEGHyhZi8LPwI2okHcdTi7OnQ7E4Guhlfm+fbqzD
	 H3HOGBVGvd+rICtGUw78SIguuPMCz0QOQlA3ZqoIjQPb9KfRvgM1owuuWcDdNKc/9cxjg
	 SNOZGElNR81xyy8CYDErz/tBJwXiUoNRYkQBiLFyYowPaYv6QqhQDC9jwI8h5TjUOppI5
	 5Fpv1Z275sgQccKu6JaiVmb0NjoBuzPzqUH6X8u0NsWhvo7XDuyW6NUqsS2evCbuhuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9WI6ei2jBWj+aDV0POOi6n1Nt5D19STY5GLK2fcg57s=;
	b=iejwEc/CMxoC67ZojGfZBsePCKT6EQZZauxBC84WgOFPa/Rhz88D8dEW802FC2WHalja
	 kAJXPp/OFRiBM3pJ0qMIzIAJDUMk9pIOddBJp5CCTKpgOypHK+rBpFHypByzowygB6l1y
	 cNTp6LZaiHvgw2E54NsIi8R+UGuSpxMnVtGKufugrRKQwhTFQdqbDDd9xttylp4u6uQeg
	 KodXoybLrQeFoP6vIGdRQShqhJ2Mam0iErrx/wk4uPSFUz687TT1AM7Xf+2FG772oKXPM
	 ImOXpVmC0+MxMePogOwdQepwgxfcN6e3lj4lJy9DbvszR2C+UO8r8FMyWR7mDsBZ7FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iOL30lWK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4408606A684;
	Wed, 25 Nov 2026 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iOL30lWK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4291F000EC;
	Wed, 25 Nov 2026 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620684;
	bh=9WI6ei2jBWj+aDV0POOi6n1Nt5D19STY5GLK2fcg57s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOL30lWKON4owswirnLh/M2YRUqb+57iGrNsYFUCC6cWp5PIqniBvE0VldeEXKvGx
	 Zn95xTHAUCVFed8onxgCRQvU+rPL/U0DsCAf8/Vc8pKN1VKBxxWzhazaFCTO8lsYDR
	 rgruJ6WFwSqvjJottZUQ1pgbX3gu2IiK5sEzEsv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0982/1005] iio: inv_sensors: prevent timestamps going back in time in transitions
Date: Wed, 25 Nov 2026 15:38:40 +0100
Message-ID: <20261125143844.662659872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 3785dffc7c68751a8429ae6dd75804c14a5a7c7a upstream.

Ensure when computing first timestamp and when applying odr change,
that the next timestamp will not be lower than the previous one.

This way there is no risk to have a timestamp going back in time, meaning
being lower than the previous one. It already can never happen without
a transition because we are generating timestamps by adding the period
to the last timestamp.

Fixes: 0ecc363ccea7 ("iio: make invensense timestamp module generic")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |   16 ++++++++++++----
 include/linux/iio/common/inv_sensors_timestamp.h       |    3 ++-
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -133,10 +133,15 @@ void inv_sensors_timestamp_interrupt(str
 		return;
 
 	/* no previous data, compute theoretical value from interrupt */
-	if (ts->timestamp == 0) {
+	if (!ts->init) {
 		/* elapsed time: sensor period * sensor samples number */
 		interval = (s64)ts->period * (s64)sample_nb;
-		ts->timestamp = timestamp - interval;
+		delta = timestamp - interval;
+		/* prevent next timestamp to be lower than the last one */
+		if ((delta + ts->period) > ts->timestamp)
+			ts->timestamp = delta;
+		ts->init = true;
+
 	}
 
 	/* update delta timestamps and estimated period */
@@ -190,7 +195,7 @@ void inv_sensors_timestamp_apply_odr(str
 				     u32 fifo_period, size_t fifo_nb,
 				     unsigned int fifo_no)
 {
-	s64 interval;
+	s64 interval, timestamp;
 	u32 fifo_mult;
 
 	if (ts->new_mult == 0)
@@ -213,7 +218,10 @@ void inv_sensors_timestamp_apply_odr(str
 		fifo_period = fifo_mult * ts->chip_period.val;
 		/* computes time interval between interrupt and this sample */
 		interval = (s64)(fifo_nb - fifo_no) * (s64)fifo_period;
-		ts->timestamp = ts->it.up - interval;
+		timestamp = ts->it.up - interval;
+		/* prevent next timestamp to be lower than current one */
+		if ((timestamp + ts->period) > ts->timestamp)
+			ts->timestamp = timestamp;
 	}
 }
 EXPORT_SYMBOL_NS_GPL(inv_sensors_timestamp_apply_odr, "IIO_INV_SENSORS_TIMESTAMP");
--- a/include/linux/iio/common/inv_sensors_timestamp.h
+++ b/include/linux/iio/common/inv_sensors_timestamp.h
@@ -66,6 +66,7 @@ struct inv_sensors_timestamp {
 	u32 new_mult;
 	u32 period;
 	struct inv_sensors_timestamp_acc chip_period;
+	bool init;
 };
 
 void inv_sensors_timestamp_init(struct inv_sensors_timestamp *ts,
@@ -94,7 +95,7 @@ static inline void inv_sensors_timestamp
 	ts->it = interval_init;
 	ts->delta = interval_init;
 	ts->delta_counter = 0;
-	ts->timestamp = 0;
+	ts->init = false;
 }
 
 #endif


