Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C581F46EF60;
	Tue, 21 Jul 2026 19:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663814; cv=none; b=ud03rpSMZg65nK1UqOFYI7+PW2P0D0K7p0n4vOSnXPyHJPtSH+K3ZWZd5BevL3zgpbw4liuQWIBh6X/R7ybd1r7EYoRhSlcCner1LB1dmJyXy4D2uRhXk3cP0MJdL5IU3bOt0CE0pAncuUP0/OeF/HuBdV+Qy/0vWM+PKmntTow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663814; c=relaxed/simple;
	bh=ORGgayN6wAzA4BK+p38H8RYFoBHaqCzm+fqIn2ZnUYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unqeATjM66Yzaf9C7B+Maq87KNsK00sDsi3bAyMGWH83lWxuxaNjHaVGiNTzBsBH6hYpBHYp82qNrfl5svWLfYegdnulOmeE0eSU0dDRLZfZ/NPFVopNvZmvi4O/trZlvddqOGkJ9chF5VwUU0SWbtkZxZuYli+tyEEPWA8Rv7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRgDj2Hf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRgDj2Hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375B01F000E9;
	Tue, 21 Jul 2026 19:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663813;
	bh=s+dZKRN7DxEFy4deMSUKG2hulxsUHgHK66tQ5cfWVcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRgDj2HfS2k3mM2975dGTidhJ1+oUWf1vUzgmPjMS8ezRchb7XG+rUAvjzhwq97Gu
	 /mgq9qMOTL+hMPSgKWgpjud9unvrdeVPN2tNl73yy8Jt+CfW+ZIyTKIEAuH6Xjsj64
	 Kv55SECYvHVrMZHsMt5hKPzZWGI86eog+HEa5YOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Stefan Wahren <wahrenst@gmx.net>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 0963/1276] tpm: tpm_tis_spi: Use wait_woken() in wait_for_tmp_stat()
Date: Tue, 21 Jul 2026 17:23:26 +0200
Message-ID: <20260721152507.575650832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


