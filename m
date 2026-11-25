Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626189;
	b=XbsDyWsHOFkaWoqntc2nl4g5LGDEORCcTCS+kns9KDdGiXrRcY4NjlE8LbIKfEk5iCNk
	 jvbn52WmJWgFW/GM95yxkCybaPfQdZOHKAhb6GBmQBcWZDCnBQTxHyI4bX3K6uXlWGvpZ
	 jwzaOZtr+0COW0NG18E1ASkjK/3Htpw1A8PNYFxNxRv4JBO4aUROGwKcKqSErIvFAyApT
	 XU+fnZADWViDEL/xWhuZrtJZdhl3TcM5WXrArTAZsAF9lJkBVNE1gGo7R7zrX89GXdUNe
	 ZGBDKTX/RyM0297pCvITndKTaUGhsmjpQg/c2dC+HXmnX8OL3NXqrGd3EvLAEDOsjEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ULld2Eq4b9J3j5mblR2pbLudyAIwhArXZbMimdS/H8U=;
	b=1m3LsDwLiqtYdXn8U9BNmVnJh/Cwfb5HjfIlNEUqdtHHqLnMikf7IL4O0Pm2B5Y1EA0H
	 mVdj4hCF+cvjoHfvX2J9RLCIt0t3irdbEUFG+VkCHyB11Av59E8vneCKRVd9AN/iZRQuX
	 Om9PPwx77Q9swpN7MddPakgekX70x0Jpgnz1I6Cqv02AfSRrQQy+BdHBbjGBdeDRkSanw
	 L7BULyly7kk7NzPCR5HL63/Xxk6kV/nXT+lLES4U5dTvREqegfMBGXPmujCRZwdZSf2zk
	 cZXDE9dtDt10bkbMHxI/UVrNPJI9UQ0RIT1174VfPgo2t974FC3sCmCrNUkeFiLmpJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TW36cWi1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDEB606A321;
	Wed, 25 Nov 2026 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TW36cWi1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4EF1F000C0;
	Wed, 25 Nov 2026 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626188;
	bh=ULld2Eq4b9J3j5mblR2pbLudyAIwhArXZbMimdS/H8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TW36cWi1MwkJIrreq/GfKIPOAR2OlOfUlqEdZg2cwMpsIMTXu2beuP4Y4pl9uE2X7
	 sWxl9mv79EGIA3/s1LhI1vmB3+bqgFKILHBGIyKHaotRI+sgh+muWCj2CiJXWydgE/
	 KBH3ttcT/cY9xeCIxJhyKm88hakU2qiPNqAmqrd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 6.12 762/816] w1: ds2805: use the bus mutex to talk on the bus
Date: Wed, 25 Nov 2026 15:38:30 +0100
Message-ID: <20261125143906.810274829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


