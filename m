Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10EE25C715;
	Tue, 11 Mar 2025 15:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705886; cv=none; b=Tnj5huH9XyqZq6IHUcI78ovsnRNJuKP9mYAQegbQIZfhzc2A1P3FsZQ/xoR3HzhPOmL4ZSHBITOKZZsNbWAUosm9dbPGhbo4B7NOrCWzDrPtD/B8wANIaeHzKa+NhB2m3yroybKghRK57HqqeGKd5Ln1wSR4NAPqEnAF+wwiRss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705886; c=relaxed/simple;
	bh=tHi5KybfWqbeVUS7pF7TAs8U6mGSGtrOsO1vApzORtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=askpdIiGcM6Jrw3sOGkOdrtrQox5OLQuF2bLBeJIzNWtMsqYXZ9dhD9ERNFEs6/lwivp+10CjJV6ESpD4sBjkiA/lTuZ9DRkQhcxgJ7Iy4DhSHQHrl4bk1l/u4M8cgqUVlCq5VdRIqc91RLLzqJHYCK6dXzuZHNC0o44qB+o75U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fg1nI3q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fg1nI3q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C8CC4CEE9;
	Tue, 11 Mar 2025 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705886;
	bh=tHi5KybfWqbeVUS7pF7TAs8U6mGSGtrOsO1vApzORtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fg1nI3q8ayuvPj9AVv9lMqrigIMipb+KIQGhyXLQ61YUY2RZaT0TEoRbYZGhPtTrT
	 H7DGgGMJ1psC/9H0XVHz3YsavTNcWRTI6Q/kzMDIw8DQV/l0de1TR4JLB+bE8XeN9p
	 nFvBzO0v13/OXEYxxn6OBTcR0Ulxh3E2urCHnxEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Richard Cochran <richardcochran@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 159/328] ptp: Ensure info->enable callback is always set
Date: Tue, 11 Mar 2025 15:58:49 +0100
Message-ID: <20250311145721.227499832@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit fd53aa40e65f518453115b6f56183b0c201db26b upstream.

The ioctl and sysfs handlers unconditionally call the ->enable callback.
Not all drivers implement that callback, leading to NULL dereferences.
Example of affected drivers: ptp_s390.c, ptp_vclock.c and ptp_mock.c.

Instead use a dummy callback if no better was specified by the driver.

Fixes: d94ba80ebbea ("ptp: Added a brand new class driver for ptp clocks.")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250123-ptp-enable-v1-1-b015834d3a47@weissschuh.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_clock.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -178,6 +178,11 @@ static void ptp_clock_release(struct dev
 	kfree(ptp);
 }
 
+static int ptp_enable(struct ptp_clock_info *ptp, struct ptp_clock_request *request, int on)
+{
+	return -EOPNOTSUPP;
+}
+
 static void ptp_aux_kworker(struct kthread_work *work)
 {
 	struct ptp_clock *ptp = container_of(work, struct ptp_clock,
@@ -223,6 +228,9 @@ struct ptp_clock *ptp_clock_register(str
 	mutex_init(&ptp->pincfg_mux);
 	init_waitqueue_head(&ptp->tsev_wq);
 
+	if (!ptp->info->enable)
+		ptp->info->enable = ptp_enable;
+
 	if (ptp->info->do_aux_work) {
 		kthread_init_delayed_work(&ptp->aux_work, ptp_aux_kworker);
 		ptp->kworker = kthread_create_worker(0, "ptp%d", ptp->index);


