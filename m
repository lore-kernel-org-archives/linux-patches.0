Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30F32A1CF;
	Thu, 13 Feb 2025 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459998; cv=none; b=RT/OGlC8r5W/cBMR1dSeXGccTaxNKDqoub5DIktLGlF30LhmusqMpRVZevhmrkmmTsiqKI0hpASP2OtqVI3QpuCk6CKIVsEQq2iYBWDwLdDqZlNiPAgzaxV93oG03KKfEo39kNcvgTidYBSX6NlIiefpZeuN1tIQcHxHEsoqN5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459998; c=relaxed/simple;
	bh=hy8imgnZ+aTANJazUT7CNRdhuaN3wYOMGE7jz/I8u10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JDZH5qa8QROhgBL5Nrm1qGxuwr2r/npxqONvyFW7PgamszyiAmj0s2NoqD9QEKxe4VLSD9aKLPZkerZmD0lKeM48i0+YOcnYEoR5uhyNKavIcTg2EpX6AOaCi9/CRA6nujNFC02FgwITpuzio3EwMcftES+t4F10rTQSUcSlZDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gm/E4pge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gm/E4pge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF4CC4CED1;
	Thu, 13 Feb 2025 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459998;
	bh=hy8imgnZ+aTANJazUT7CNRdhuaN3wYOMGE7jz/I8u10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gm/E4pgeJmmbAdL+kV3g7xcmZbFB310+MYZtdWE8QLz2QYPpdkB+cwbcMM3ZDNb8+
	 ouqjAJghRbVJzkWMIkdyj0SaVWmG1LESUTV3D8oGStZT5N837Q4fhjUEcnsF/qypen
	 foiRquqrV6BrbLiBVRwVHThpUV9a9F75uI2la/5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Richard Cochran <richardcochran@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 428/443] ptp: Ensure info->enable callback is always set
Date: Thu, 13 Feb 2025 15:29:53 +0100
Message-ID: <20250213142457.134141881@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -217,6 +217,11 @@ static int ptp_getcycles64(struct ptp_cl
 		return info->gettime64(info, ts);
 }
 
+static int ptp_enable(struct ptp_clock_info *ptp, struct ptp_clock_request *request, int on)
+{
+	return -EOPNOTSUPP;
+}
+
 static void ptp_aux_kworker(struct kthread_work *work)
 {
 	struct ptp_clock *ptp = container_of(work, struct ptp_clock,
@@ -294,6 +299,9 @@ struct ptp_clock *ptp_clock_register(str
 			ptp->info->getcrosscycles = ptp->info->getcrosststamp;
 	}
 
+	if (!ptp->info->enable)
+		ptp->info->enable = ptp_enable;
+
 	if (ptp->info->do_aux_work) {
 		kthread_init_delayed_work(&ptp->aux_work, ptp_aux_kworker);
 		ptp->kworker = kthread_create_worker(0, "ptp%d", ptp->index);


