Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704751;
	b=0VepSzsz+N593qLk4lWKsiB6CooiimB4QvPAQMk2ZqzjKxxOqpy1Lm63eFXG/u2f3BRO
	 /JKoIYAYviGsfRto4bLlgKxAF4Ec9XM/Q775nBDzFfqoe37GzERmXT+vxl7uTJBIOapQk
	 IRP4hyN7rtSxf1W9QzOpws0RyhnaUR6BRkGwiS6Wr3yaUCxmMBV9e9nt7vEJ9m6miTO6c
	 NOF6z5qraIlfNIlnE1y4HndBTnuks/PBJOvrZzRIlgZKVTuIFtmy4nXX3+x+caZ3Svqrq
	 eUWvUMU0EMjVaIHILmm0/N5+rwYW2cQBWxLZsTq5+xCtvUg9A6vjM8qVY1gl/8efdfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hMkIITpHMB4zAsGh37Hcau3q6WA0zw0h4ECDjEdw36k=;
	b=CPAXl8c2zQyT+5aFqYw7/AhHa8hO6SyFXODxMPmssDRsY1R2/UMcvIVF/tjyykoiJHvS
	 5FOlblAAHHFVzn8GrAGK4VF5JGBV9HSYRsFPf2Z8770x9uMzzu12I24uvpMRvPkDeekl7
	 FuvdGwEgA+4sNsYF+Cq1AQu1dxAY3RL3Xlpp34JahX+/ymtr7d4+seTvlbNfTO3lC5N+7
	 hSASR9NEyNXJ1WAtOTNYMdvENBQMwtgEQYwzur5PL2iAR5FmkjVIDPWeVELcBb7yVWTZQ
	 YRPbbL9IsuGyU0S71p0CmhTCP+HzT9P6IUZdTvov+7APbb8ROHGyNkKPwAbrXwbEtSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLXeXeCe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFEB606A326;
	Thu, 26 Nov 2026 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLXeXeCe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16D41F000EF;
	Thu, 26 Nov 2026 14:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704751;
	bh=hMkIITpHMB4zAsGh37Hcau3q6WA0zw0h4ECDjEdw36k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLXeXeCeXv0kDd3SNGxEQorWBJYoegwQ3okYZZu+Hgv4e8zRsRDMObFBCjCyCMhHi
	 X5MvfLmBeP7UTAtLVA2oR4qLCWIkpGQsGRKPYryxbXwwRsevN0s9hz3EACuFVSGbyW
	 Qu2b6ZKnG2ANh0w5llxU8+KIiIZoj3XELK3J+DRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.10 229/265] w1: ds2805: use the bus mutex to talk on the bus
Date: Thu, 26 Nov 2026 15:39:19 +0100
Message-ID: <20261126143621.268138550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


