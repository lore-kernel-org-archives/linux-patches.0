Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1300469849;
	Thu, 20 Aug 2026 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243626; cv=none; b=NGZ6U5g63SJfkq75fjMPS0Nv0IUQJQeuoswPzaybqlWB+NK3iDiFHULzBssFZWionf0U9ljitckhC0w3X81vF40KMnPXWbFLH9LjyBCHrgUJPnA8b22Nhi3VIdgao3c925vl0FqqCa9azIdvZZAq6rW1fglDZUZ5z9VZmGB2Q4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243626; c=relaxed/simple;
	bh=aJ0sCOcKK3L+G6j4QYcMOoI52KHc2wr5vHR0kAEnVKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyjQQO7+jahtLmfF2AsjA50LzLLh5nsrR+J9kp86/kJm5FV+HIcD0TZoAvsHPGz0pEC/b0gqa9qNPWpAZfVtqI2HhEBYD4Rb8fb50MXOk1vRkjCCn58Ip/xmCD2zUHrSrMuNUGA5MMmJKzxIGg5V3dSCMdXFS5pHldFbIWPxPiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQpfRO3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQpfRO3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AC21F000E9;
	Thu, 20 Aug 2026 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243624;
	bh=jX0iDDrp9KAAO4oalMiK+71eL6d7t5Svlx39s+8FteI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQpfRO3lvlOll7Tq5bqIhc7/NfNFk0Oe+0jgz0APu5ffeZcXnA7skSENAUq3oDOjr
	 yVZ/y4SYTAB68kf4LEy0SmB4KpNWHbmxQ2GfeMDVkIbRmAom62LZ/I2HRetDrybEVN
	 yODrNUqbmxQwVHygk+xgfUrZvFV+6Lic70T7mncg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Stefan Wahren <wahrenst@gmx.net>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/272] tpm: tpm_tis_spi: Use wait_woken() in wait_for_tmp_stat()
Date: Thu, 20 Aug 2026 16:55:05 +0200
Message-ID: <20260820145234.894589786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit c0c9cfb3b75def8bf200a2d4db09015806acfeaf ]

wait_event_interruptible_timeout() evaluates its condition after setting
the current task state to TASK_INTERRUPTIBLE.

With CONFIG_DEBUG_ATOMIC_SLEEP this triggers a warning when the IRQ wait
path is used:

    tpm_tis_status()
      tpm_tis_spi_read_bytes()
        tpm_tis_spi_transfer_full()
          spi_bus_lock()
            mutex_lock()

Address this with the following measures:

1. Call wait_tpm_stat_cond() only while tasking is running.
2. Use wait_woken() to wait for changes.

Cc: stable@vger.kernel.org # v4.19+
Cc: Linus Walleij <linusw@kernel.org>
Reported-by: Stefan Wahren <wahrenst@gmx.net>
Closes: https://lore.kernel.org/linux-integrity/6964bec7-3dbb-453b-89ef-9b990217a8b9@gmx.net/
Fixes: 1a339b658d9d ("tpm_tis_spi: Pass the SPI IRQ down to the driver")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -49,10 +49,11 @@ static int wait_for_tpm_stat(struct tpm_
 		bool check_cancel)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	unsigned long stop;
-	long rc;
 	u8 status;
 	bool canceled = false;
+	int ret;
 
 	/* check current status */
 	status = chip->ops->status(chip);
@@ -62,23 +63,32 @@ static int wait_for_tpm_stat(struct tpm_
 	stop = jiffies + timeout;
 
 	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
+		ret = -ETIME;
+		add_wait_queue(queue, &wait);
 again:
+		if (wait_for_tpm_stat_cond(chip, mask, check_cancel,
+					   &canceled)) {
+			ret = canceled ? -ECANCELED : 0;
+			goto out;
+		}
+
 		timeout = stop - jiffies;
 		if ((long)timeout <= 0)
-			return -ETIME;
-		rc = wait_event_interruptible_timeout(*queue,
-			wait_for_tpm_stat_cond(chip, mask, check_cancel,
-					       &canceled),
-			timeout);
-		if (rc > 0) {
-			if (canceled)
-				return -ECANCELED;
-			return 0;
-		}
-		if (rc == -ERESTARTSYS && freezing(current)) {
-			clear_thread_flag(TIF_SIGPENDING);
-			goto again;
+			goto out;
+
+		if (signal_pending(current)) {
+			if (freezing(current)) {
+				clear_thread_flag(TIF_SIGPENDING);
+				goto again;
+			}
+			goto out;
 		}
+
+		wait_woken(&wait, TASK_INTERRUPTIBLE, timeout);
+		goto again;
+out:
+		remove_wait_queue(queue, &wait);
+		return ret;
 	} else {
 		do {
 			usleep_range(priv->timeout_min,


