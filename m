Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704755;
	b=urHfNJQ0Ts2EObW6rN77ukcoPQG89jwXCMBqP8Q4KQV0OiFZvWZeqC5if04vAwCr8XIz
	 azgktVwsRvFMegzcc0TMjcaBJ+6hXpONkis8HL/ByExDskTjs1mmwNffMTW4w+QpLJE+M
	 G2krt4qHgx0ZFub8irXcxs5Ii0YDAXjsfdpOF3D9mf2FcqGLGx3RJ2vs15myXCO7NHLpY
	 zj1OqqrL80i/2YPm3RSeMyU026hdJYxfPt6HS4LVLOC/a8yae9T1vmTCt1z8zMm5nTZQ7
	 C2VjC5tMZqp94fngU6DaKIv7/lua4Cpn9flXof5ckaNeKDrem5Qg1AV7is6Iu391GbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yJh9y03hWl7f+jqL7HQ/LIZYCA/nAvNFmvMvPebVAC0=;
	b=31KENqukuagRIgcHCRuzaSlJHHRPOYs4uiXKHwA2JfRnX1zEJXnUvUIW0SIfY9eGeZSk
	 7kC2PH++XRw/D+Y3BVal8gOVIY/FhsqGdl9uYLcW2wKK77DO5s9RlMIlJcgOTnDTUbPOk
	 kt85WRenPmPZb1CEATB3FXru9xCPBQhHmO0Jt2I+rUX9dwFES2+NiFDEKmyT8GnfLvUuW
	 oohaOJQb18C+H4LG3kLL5MdCLd3DCbzhf/79OkFVZ+Wf5kt1ejBpGcOxMcb/19nGEclzr
	 rqK0cgiKDo12P9IyeHW7hXzTv76IQifgCuQB/oU4yai9L96GqDfKu3WqK2EEk4uQ3SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNIsejDh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6AA606A31C;
	Thu, 26 Nov 2026 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNIsejDh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC341F000C6;
	Thu, 26 Nov 2026 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704754;
	bh=yJh9y03hWl7f+jqL7HQ/LIZYCA/nAvNFmvMvPebVAC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNIsejDhyzBRSWn3rY5yDhw3CRTSIcqAdrqEmNrNlJHTB0plcBBMS51Rn5X/u6+mF
	 WTUCTJYzTRmY6qvIRS5NtOTL06L7cOybEIBC0QCX6p/DLAjRmMW1an3VmzfFSsvRBL
	 32cntu5junWwOSjaqqaDbNkY+x0ZvdStQHBgHDeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.10 230/265] w1: ds28e04: use the bus mutex to talk on the bus
Date: Thu, 26 Nov 2026 15:39:20 +0100
Message-ID: <20261126143621.338799028@linuxfoundation.org>
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


