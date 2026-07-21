Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F29144CADF;
	Tue, 21 Jul 2026 18:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658834; cv=none; b=KhUhQOmP/eM5MBltETsc8EYV8iAjKdb37LAYhhc38aCZuN3tLhdxEfyt7K9Vvl5yLfXBgSj2rX79MbkGbq8y3vLWd9G3eIYOqpzix3tYcvRXRXPBuQj+Z8vlAoGQ4uxF403Eh2Wj0zW3V7c6tm4Iim9MZcSS6nuu4pmpNnTCwH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658834; c=relaxed/simple;
	bh=o2w7hofyx7B8UhFtCS2yWttZ1tzfB6kS9aOkXVgsfmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASa+YedlqhRp9YhhvavobcLek5lRNEX7Z46S0bTxmCq+1QNxlsvjc+G/OQ5NxJXCjkbuQEK/5B3LRdy0aj9MaVUOA9/pRhnpy9DawRffUMY1Nn8J1WYPFXYVP73FmeUXBwCMHRfjovgE1FncUCGKrtEok5+nFvb23QkxNo6wjcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Te8PRKO/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Te8PRKO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DBA1F00A3A;
	Tue, 21 Jul 2026 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658833;
	bh=epmxUNlprSgQDkA361eBMB2amDEkWpW8njcmXzDRpL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Te8PRKO/3I0zCrMzWHQowX3t60ao9+WVP2C0RoxKJIHql4sSy1EMGa+n1Ws+DJYGi
	 tFCyrZ4oX+ZSvK0C31aJIzaAocdTalsCEwi9w0/6TEcfc6LcNd9s8rCwiMui9FM+FD
	 6mJlU3/DR4EqHcfBpyZWFb3ZgHNHd8Y6QzIqVO2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Stefan Wahren <wahrenst@gmx.net>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 1291/1611] tpm: tpm_tis_spi: Use wait_woken() in wait_for_tmp_stat()
Date: Tue, 21 Jul 2026 17:23:27 +0200
Message-ID: <20260721152544.481174827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

commit c0c9cfb3b75def8bf200a2d4db09015806acfeaf upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -66,8 +66,8 @@ static int wait_for_tpm_stat(struct tpm_
 		bool check_cancel)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	unsigned long stop;
-	long rc;
 	u8 status;
 	bool canceled = false;
 	u8 sts_mask;
@@ -87,23 +87,30 @@ static int wait_for_tpm_stat(struct tpm_
 	/* process status changes with irq support */
 	if (sts_mask) {
 		ret = -ETIME;
+		add_wait_queue(queue, &wait);
 again:
+		if (wait_for_tpm_stat_cond(chip, sts_mask, check_cancel,
+					   &canceled)) {
+			ret = canceled ? -ECANCELED : 0;
+			goto out;
+		}
+
 		timeout = stop - jiffies;
 		if ((long)timeout <= 0)
-			return -ETIME;
-		rc = wait_event_interruptible_timeout(*queue,
-			wait_for_tpm_stat_cond(chip, sts_mask, check_cancel,
-					       &canceled),
-			timeout);
-		if (rc > 0) {
-			if (canceled)
-				return -ECANCELED;
-			ret = 0;
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
 	}
 
 	if (ret)


