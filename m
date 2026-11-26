Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705686;
	b=X8YeIvxJeWDqInXwFvbrDMReCvg4ibi6xNrw9YxNOZHkqDvcieVOZRi0Nj9jI2OsvgCf
	 GWNgBKYI75ZP7EG9QCrr9Bxp7jMoHyFu/BDsDHyo/Ks48Sfi8M31UCi52UuaLjK+H/nX0
	 o6C2U+cPcjuSBR0WDSGJkNxbRNbKERKONLfQPzxU1Hpyc+vtAuuedfhuCjExUP3UP/b3o
	 3vgxPDdkvylOBi4lL4Hgy4ZU9RwoZJRVlsTnQiwTxMLDpQwMQ6mPilo6gn0gmXdKMTp3z
	 WuikqnQAonoW2zGSCPKI7sb1yGnDaEE1rJO+bCGToc7ygO1LzZsq4N+kmoQKPgULWFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c/WpUyTKlFP/uupBSARXQyvfXm15kEthfPWn8y5NE/M=;
	b=Lg1iLdAUmDw4AgcLKebPu11pFQm1JSNRF4vr/199VF2NB9/BMwcyyWNb7OVsZ/NYLFQn
	 F+SUhnf0Q3ZtGhul4stf5425q16H0cz3g0UBAtNeiczYurMvjR29y+oAfCLSVEMEBuSBA
	 wMhhZKa10KNw3BGKxmiJ4eo/x+bA/0AedB35PDhKzNTVPUv49PeTtOLmChFyaBl0740OI
	 lrQkY9yca2N5qOv28P2c3OoLHQOyA9ZjiBkTDX3TpssCKBoYNVgeEKLVPAmJmwc7kMquk
	 sGjPFOkjBkDA+tYyPjf5LIIzzGqsw2fQO0Vvzvx0ScljRAVulCWYhJTj2ap3V+ko7tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvUnTScC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34536606A31E;
	Thu, 26 Nov 2026 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvUnTScC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350111F000D0;
	Thu, 26 Nov 2026 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705685;
	bh=c/WpUyTKlFP/uupBSARXQyvfXm15kEthfPWn8y5NE/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvUnTScCf5r296dZV2Snu4XLlaiSS2aWOtxHP4s24rjeQBhYVwiaI/8FnnbecIpf0
	 B2wobWMxII1zs25udwKucCHk3c8kCr+0IUU4TVvUEsxycdQAwnm8vow0DcC3T39YeR
	 MDBPGkYGSMjwH2YMSlPRLQpZ9bmJSLTYrF2k9YhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.15 282/319] w1: ds2805: use the bus mutex to talk on the bus
Date: Thu, 26 Nov 2026 15:40:50 +0100
Message-ID: <20261126144013.120520546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit a2e52ccce044e13d2695bb1bbdc07942727f28dd upstream.

Since commit b02f8bede217 ("W1: split master mutex to avoid deadlocks.")
the slave drivers serialise their accesses to the bus with bus_mutex.
This driver takes the mutex of the master in the callbacks of its eeprom
file instead.

That mutex is held while a slave which has disappeared from the bus is
removed, which waits for the sysfs callbacks of the slave to return.  A
callback which is waiting for the mutex at that moment never does: both
tasks are stuck, and with them the thread of the bus master.

Besides, it does not keep the other slave drivers off the bus, so that two
transactions can get mixed up on the wire.

Fixes: f6887531c0c6 ("drivers: w1: Add 1w slave driver for DS28E05 EEPROM")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-5-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_ds2805.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/w1/slaves/w1_ds2805.c
+++ b/drivers/w1/slaves/w1_ds2805.c
@@ -102,7 +102,7 @@ static ssize_t w1_f0d_read_bin(struct fi
 	if (count == 0)
 		return 0;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 
 	/* read directly from the EEPROM in chunks of W1_F0D_READ_MAXLEN */
 	while (todo > 0) {
@@ -123,7 +123,7 @@ static ssize_t w1_f0d_read_bin(struct fi
 		off += W1_F0D_READ_MAXLEN;
 	}
 
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	return count;
 }
@@ -211,7 +211,7 @@ static ssize_t w1_f0d_write_bin(struct f
 	if (count == 0)
 		return 0;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 
 	/* Can only write data in blocks of the size of the scratchpad */
 	addr = off;
@@ -256,7 +256,7 @@ static ssize_t w1_f0d_write_bin(struct f
 	}
 
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	return count;
 }


