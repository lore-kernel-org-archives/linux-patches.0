Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620518;
	b=zxP9vXinWdKuOpfLi7X4hQIUlatrfajjdI93q/HKqZqH9ZpCu+Wyy8OGoedkabevdQUL
	 CVMXx9F98pK8OZy5EvK03sgoE2QwTbnxVgzkQI4WHufN1eae21gBhDwXDw2BkXhdqs++s
	 qT4jIcgmXdUZwHzDvbjNmtqkilfCtxYwne/TRlHGmwax2mdl08L2k9qIz+hPwv3rNZGnd
	 DN/yFZW7P9kWZQjFNK4bMfw5krQ/gwFnT7hLYuT0avKtJudrT0yS89/A9uaiKcfLKPSRM
	 1ZZyAYfjZmmsRLj7Zw4teLGJm5VeP6TTbsJ9A5TuEU0pKG0arJO9+DmcKGc0o4vmrqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l4hCqrXs4l2oj1wbEcCMKdN8b9mFBVe8J+qAk0tsuSY=;
	b=gufLneTgIN8a1WowVx/yiUcROT70M5j7ZRtiKNF40aPrpuznHBXrhhkZS2/pyXJgHKyX
	 ZUIFP0GgmovvmtYnCW0B+RT3XJl8P7YOM1QX88Vg1FEpqc9k5J05R12CBquSTaPge2+6n
	 BRZG+oEINPl+xx5qOcXUeSw3v9/yuhFDHW+Kv22uUQTntcCWOIqSO/pDwBPj6uXLLPplN
	 J5UPqRSVipvdvxTbNYRlGm2/f0ggAogQSpQuZEXt5HvxI6asvPQozSkCUK01jc6DDIUam
	 Jud1bdfmtfHgNXEhLFzr6k6job5JLJAi0b3b3xQzHNPkJ3mSGVQTLRsLichujHNSkMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flyTM7ri;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B1C606A331;
	Wed, 25 Nov 2026 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flyTM7ri
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8321F000D3;
	Wed, 25 Nov 2026 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620517;
	bh=l4hCqrXs4l2oj1wbEcCMKdN8b9mFBVe8J+qAk0tsuSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flyTM7rivU6jEyva27svALJRI7RZyZJaGX2CqEt6E6YTZbg784McHIl2a1QzaMWPo
	 RvpGWBhHp1c9Jjbr3ZI45mQCrxJhZjJxLBvYR7X14LU7p+ig6o4w813z7MwOQ7RKxC
	 PlOBMRDrZDjbCVqlYbbYBeWZIBkPmnzdZD57DOf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 7.3 0945/1005] w1: ds2805: use the bus mutex to talk on the bus
Date: Wed, 25 Nov 2026 15:38:03 +0100
Message-ID: <20261125143843.813709428@linuxfoundation.org>
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


