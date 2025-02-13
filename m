Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D506198E76;
	Thu, 13 Feb 2025 15:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460939; cv=none; b=mPwmScAs7wldHmGSwRZqrb2tnx7uQlhI22oJSfFvddJpaQKpvi5qvEcUi7w2DwqUs2DcOVq9qz9PprtZVfk7OTQwgRJkMmbTY4Ae1lQ8rLmBE2J+BuzZ+OMhvnjsL9CdFDri2wG/7Pc6/Q64VIcc+qhndtfkA1y5iahkQ65hv0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460939; c=relaxed/simple;
	bh=Qlk9OS2n7gtyn5SqIyO7q1b4H2/lm2JgIrigEhTURSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGmckF5BPezKlJkscuFPmCJAuE6snpJlkEtXqpC3wmLEV9TafsbYBOs+oSqG1FpR2m3cV16JWIlNA5/dV1/EZdVIRFulli69IwQazqgDGIJqjJ1RNxxtltKAAEKYazMpKLtuBGO3t7W1rtX/87zxQ2qpNc+pSDvGyMQ6XKohQIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rfd05a7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rfd05a7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D5FC4CED1;
	Thu, 13 Feb 2025 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460939;
	bh=Qlk9OS2n7gtyn5SqIyO7q1b4H2/lm2JgIrigEhTURSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rfd05a7gXmo+aZE2PJxCC9DHEmsNJKijF4D8jeqjd1kTwC1sRA4kiZJ9k6H7sEyD5
	 JnD4gRYPU9sfIJ4WmuI7gEY1lBUq7TcgP+4eyiDRSiC72eWBnYmraIa7csXkDDPFEK
	 jxp4GgDFajc9vQXWMoJLJNwOoCJv90P3xWIlFz3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Richard Cochran <richardcochran@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 257/273] ptp: Ensure info->enable callback is always set
Date: Thu, 13 Feb 2025 15:30:29 +0100
Message-ID: <20250213142417.577084262@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -189,6 +189,11 @@ static int ptp_getcycles64(struct ptp_cl
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
@@ -251,6 +256,9 @@ struct ptp_clock *ptp_clock_register(str
 			ptp->info->getcrosscycles = ptp->info->getcrosststamp;
 	}
 
+	if (!ptp->info->enable)
+		ptp->info->enable = ptp_enable;
+
 	if (ptp->info->do_aux_work) {
 		kthread_init_delayed_work(&ptp->aux_work, ptp_aux_kworker);
 		ptp->kworker = kthread_create_worker(0, "ptp%d", ptp->index);


