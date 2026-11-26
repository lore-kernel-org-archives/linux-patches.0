Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705689;
	b=T88ZeUs4X8gLMI6qaORKrOklQngubg2x7BSwd0JuuUh53Kx6eqXgHCCy/jAILh2MgEP1
	 OUUW1pjC+xtd08XkuEZgq5i9bCs4Mtev4r0/9eZnSuuESG7Izt/85Dfu8l0RfP13Ur73u
	 rrQqW7PLQledXXXQnphfllrpsH9ZKuKPO+xbkNZnmugN97orqOLtmwlKVrQzGxMphwZRv
	 U/Z33duTHKTclRlyJoc8mFHFH/ryCCsAtb/MhvuxfeROa17Maz4rIhcQz95J/WdgPW7Zz
	 j2FJAo1Io7T+hySBnwuZYkVbRa1fTCXxNbH5Sagd/0aZ4Q6R6YCEsD/VuPKDxdg+8Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gMJEAiGzznklobcbS89l0YxpEH6CMg74vvAZDpeZIbg=;
	b=Y5HzYMPr3lgKeLKLzsDc67r3hxRG+eu32CSMuglfyYGQS1gyqgTUTYWoei0IN5Ipfdhl
	 VrldU+3pYWQh3OvToTqR67/bFI2Wmk76ZRhHjOcxIBoXSzsUj9uDlNbIL90FSpiOh7N1n
	 En/FJ2lZzY1ye3mwuEuMA/3BFWy5kehiSMwOzr9i9xy9o86yeRNap8D/Z4WMEQY00RB7U
	 bdwtJpr3P2Z8Tta6Mkr5jbW1U0FOH6GGd5vl/zmP+ToJqniPIO0vNMWGa6v0YxPkBBSd7
	 CeOuD3eDhzcBOdSKaB0qpSravnvOVKkE6Z9A/crfP54pHSiBKyrvDuMhAJ0mtOVz0ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JtrD/68d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B63A606A31C;
	Thu, 26 Nov 2026 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JtrD/68d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B701F000D1;
	Thu, 26 Nov 2026 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705688;
	bh=gMJEAiGzznklobcbS89l0YxpEH6CMg74vvAZDpeZIbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtrD/68dzw6U4zDqnfart2LYEFIVm0rljnxu/PmQnnXiLiTnv2kY1Q1vI4NM6sg7G
	 QXA2msXSDoPi3KXeG7EVus8JSTW/apzXglQdOPJsWWCaN9xrqT1dmsNCqTdYXY8WR8
	 dOwps10/4alG/5upINNTVqvIHckpmDVYQV5Fiags=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.15 283/319] w1: ds28e04: use the bus mutex to talk on the bus
Date: Thu, 26 Nov 2026 15:40:51 +0100
Message-ID: <20261126144013.143966003@linuxfoundation.org>
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
@@ -250,7 +250,7 @@ static ssize_t eeprom_write(struct file
 		}
 	}
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 
 	/* Can only write data to one page at a time */
 	idx = 0;
@@ -268,7 +268,7 @@ static ssize_t eeprom_write(struct file
 	}
 
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	return count;
 }
@@ -287,9 +287,9 @@ static ssize_t pio_read(struct file *fil
 	if (off != 0 || count != 1 || buf == NULL)
 		return -EINVAL;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	ret = w1_f1C_read(sl, W1_1C_REG_LOGIC_STATE, count, buf);
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	return ret;
 }
@@ -307,11 +307,11 @@ static ssize_t pio_write(struct file *fi
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
 
@@ -325,7 +325,7 @@ static ssize_t pio_write(struct file *fi
 
 	w1_read_block(sl->master, &ack, sizeof(ack));
 
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	/* check for acknowledgement */
 	if (ack != 0xAA)


