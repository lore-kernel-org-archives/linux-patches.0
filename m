Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626191;
	b=tfNfB1FRJjcvXAegR/1jTpUN34fdLiFUhtmVgv/V6jXJZRvuh3DTRIbTStLm2kkQg/t7
	 0oUd8TzGNzciHctoKEfIRHph+cwi0k7YncezAGvkTCRih84DbEx7hmaUnhLe6kcZBZxrx
	 cgGrfAgR3YlmXGnhJWcQpTMOB1h8Gddytmb1OL4qxv82YsvY6OMPgZIeTQdgN9HvkuROA
	 8DF9joAkC8ipZ8m8UFa0izTgnBpeFc3mTi8GcGilKhCGrsGSDtAhuJTaNLZjcUIKWS4Rs
	 9nZFaTObgxJAVAtm1/L/AKOnSkATPr7PbkOYKtm/C9jx8LYAAc7iNzyBpCq4+RhRCjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jCvMkXu9gEUZV7lKWXYndiVYuHOXkywprWbK9XdtdtE=;
	b=i/bvSqQf5kMMMdqvET+jj7WPVk54g6t+PrjKu3vw04XYMCev/v+sN+5Dq/4linH7A0lr
	 +basWa7CTYcie7jSGGuPoPHF44eMXP9XHqWT/yKmiUBesiCe0ZeSOmu80oRmQW2ckLGZw
	 7A263zqd7cXjT1VrzBcXOA5SU0pv8mmRb9AHtqE44Z3r0WvucpXNMxAL5wzGd+kZmF1N2
	 XynXr0tLRQHCXB/28Ysu4HqYoAA7AESc073a+8t9cyCLuQBnnTzMn0NHF/WGR6idVPu1E
	 P65EYpX527VcWYEXg4c6jK3lw0F5DD8FqISP+RBC1jBsLrt3fiXyaR4jm+c1zH3+tfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3W1ouao;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F41606A321;
	Wed, 25 Nov 2026 17:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3W1ouao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B141F000C6;
	Wed, 25 Nov 2026 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626191;
	bh=jCvMkXu9gEUZV7lKWXYndiVYuHOXkywprWbK9XdtdtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3W1ouaoB5xcX3kGJ+SpQPzttnYa854fBDTvQ/RhA9xM7Ng4XlwvlWN5mibOwgud9
	 TIFGtsKDuOBUg6oV1oIJIEO8Af74szeXGOXdYr3UMyMTM028lqIYr5NP0XBSJIovH5
	 caEfkiKhw8AYu+DUCHZe25mnF/LuJmyJQDOjzVXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 6.12 763/816] w1: ds28e04: use the bus mutex to talk on the bus
Date: Wed, 25 Nov 2026 15:38:31 +0100
Message-ID: <20261125143906.833954648@linuxfoundation.org>
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

commit 5bc51235d0ad4a4991e38f4e9dc3440738296850 upstream.

Since commit b02f8bede217 ("W1: split master mutex to avoid deadlocks.")
the slave drivers serialise their accesses to the bus with bus_mutex.
This driver, which was merged shortly afterwards, takes the mutex of the
master in the callbacks of its eeprom and pio files instead.

That mutex is held while a slave which has disappeared from the bus is
removed, which waits for the sysfs callbacks of the slave to return.  A
callback which is waiting for the mutex at that moment never does: both
tasks are stuck, and with them the thread of the bus master.

Besides, it does not keep the other slave drivers off the bus, so that two
transactions can get mixed up on the wire.

Fixes: fbf7f7b4e2ae ("w1: Add 1-wire slave device driver for DS28E04-100")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-4-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_ds28e04.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/w1/slaves/w1_ds28e04.c
+++ b/drivers/w1/slaves/w1_ds28e04.c
@@ -123,7 +123,7 @@ static ssize_t eeprom_read(struct file *
 	if (count == 0)
 		return 0;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 
 	if (w1_enable_crccheck) {
 		min_page = (off >> W1_PAGE_BITS);
@@ -140,7 +140,7 @@ static ssize_t eeprom_read(struct file *
 	}
 
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	return count;
 }
@@ -253,7 +253,7 @@ static ssize_t eeprom_write(struct file
 		}
 	}
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 
 	/* Can only write data to one page at a time */
 	idx = 0;
@@ -271,7 +271,7 @@ static ssize_t eeprom_write(struct file
 	}
 
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	return count;
 }
@@ -290,9 +290,9 @@ static ssize_t pio_read(struct file *fil
 	if (off != 0 || count != 1 || buf == NULL)
 		return -EINVAL;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	ret = w1_f1C_read(sl, W1_1C_REG_LOGIC_STATE, count, buf);
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	return ret;
 }
@@ -310,11 +310,11 @@ static ssize_t pio_write(struct file *fi
 	if (off != 0 || count != 1 || buf == NULL)
 		return -EINVAL;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 
 	/* Write the PIO data */
 	if (w1_reset_select_slave(sl)) {
-		mutex_unlock(&sl->master->mutex);
+		mutex_unlock(&sl->master->bus_mutex);
 		return -1;
 	}
 
@@ -328,7 +328,7 @@ static ssize_t pio_write(struct file *fi
 
 	w1_read_block(sl->master, &ack, sizeof(ack));
 
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	/* check for acknowledgement */
 	if (ack != 0xAA)


