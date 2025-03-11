Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9B815820C;
	Tue, 11 Mar 2025 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706942; cv=none; b=L/eZXF3vqPPTomUZohRcW37DhuRQw0wz7hz9QRL+ELvBe3Csf6k9hR2Qqkm4HYzhJ9uq1SYnKiERfYeElHVTHGJoFBndMDBdsn5kW3h64X09hZfkQZyvnaQYF8UoAEIWqPrlj3ZaK+JpVclImv0hWT8EohfcjE/7PFIT6IIEulQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706942; c=relaxed/simple;
	bh=IVDYb+FTgcn8F7v5ormP0lXXETl0I+wQ0lY7qRFRMpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IUQCHVcV75j7rP/wWvTsQtve0iZTrDedZYH14gz1pKplI2VEXQYsdp24CD/zkXFUbgMH+MazKZxrsSB5XrNARfzIw+Re/iMkyNXb+ZaXrRwtyzZwke7cty2osYUYOvFFecJEC2xPqp2LkdR7Gh7gilSGDnQnG/oMDVKq+PY4KbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eG8WR38W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eG8WR38W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2756BC4CEE9;
	Tue, 11 Mar 2025 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706941;
	bh=IVDYb+FTgcn8F7v5ormP0lXXETl0I+wQ0lY7qRFRMpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eG8WR38W8YJz4QpIZV7mH4XB0rilCVBanFQtxaQ0nWRBxUPQ/77fjhGmqLo1h/sTG
	 yfkmmxuaE8Ys6M+YB571DN/Mz58WSS6NaBWD+pRnveSHCe9fsuvnJg0DORE+wnx2ez
	 9bXL8F0ehtDVAkkWLTx9xN88i7G6Jbb+uFfaNiC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Richard Cochran <richardcochran@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 221/462] ptp: Ensure info->enable callback is always set
Date: Tue, 11 Mar 2025 15:58:07 +0100
Message-ID: <20250311145807.093448563@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,6 +188,11 @@ static void ptp_clock_release(struct dev
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
@@ -233,6 +238,9 @@ struct ptp_clock *ptp_clock_register(str
 	mutex_init(&ptp->pincfg_mux);
 	init_waitqueue_head(&ptp->tsev_wq);
 
+	if (!ptp->info->enable)
+		ptp->info->enable = ptp_enable;
+
 	if (ptp->info->do_aux_work) {
 		kthread_init_delayed_work(&ptp->aux_work, ptp_aux_kworker);
 		ptp->kworker = kthread_create_worker(0, "ptp%d", ptp->index);


