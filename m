Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BC84BE423;
	Wed, 30 Sep 2026 17:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789594; cv=none; b=qdxrtK0Oae6kDC06fEH1rRI/fh00GVCIN+VWhjFnbKcrTikrG1sizgL8z6jqxfqiXKDlKueJf8GE6XnWGBRf6DzbzMUerLLgfYVV2Y+buUIbP6kIYYV5cmj+iRKcDchwhzyHVZ1u9lOPZUZY3r8mg4ZCE/NppugeYrcK4P13pBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789594; c=relaxed/simple;
	bh=Ca3q8G07FCEMYub0nxhZ9pIye5vuKJmP6+AeKm84sMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtG73aur3P8O5cskRnoyEc7X+GT4u85l1s/16PnpD58jP7vAWgmRUPFqu9/8FO6Qa3SKx77K1nu7kdh3hYcySAvdmpQrrgYqzG16hLy5506FHabFzF/Hf340se1VxeKCEVTx7zQhAHfLNpM8YCjz7WnUeb6TxNCaiKB+glUISU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERV5QTZT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERV5QTZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8923A1F000FF;
	Wed, 30 Sep 2026 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789593;
	bh=t0P4rtbgM0dKMxgxlUQRXIelVqpvQlxz3+6RgHvYsjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERV5QTZTxDFaycqvBu+8/sYQsafivFeWHQWdB58+2nbjK0Uegd/vPoZkGpZsKsJ1L
	 08IYINQ97g6LUcI1qBxYDVlSLMF4IgNjj4UwVrucFAuPYpt6HIH9KCoG7iFB0NqzeC
	 Fs5JW6hLXaOI1NKHJ5sBeqzC77Xu5k9oFTseZkss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.12 531/877] s390/vfio-ap: fix KVM GISC and page leak when queue removed from host config
Date: Wed, 30 Sep 2026 17:24:02 +0200
Message-ID: <20260930152426.102816390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit 65e05ec252a9b79e75930d3c4dd42d8877db04c5 upstream.

Three related problems exist in the handling of KVM interrupt and page
resources when a queue is removed from the host's AP configuration
while assigned to a mediated device (mdev).

Problem 1:
~~~~~~~~~
AP_RESPONSE_Q_NOT_AVAIL not handled in vfio_ap_mdev_reset_queue()

When the AP bus removes a queue device whose adapter or domain has
been removed from the host's AP configuration,
vfio_ap_mdev_remove_queue() is called. If the queue is still in the
host's AP configuration at that point, it calls
vfio_ap_mdev_reset_queue(), which issues a PQAP(ZAPQ). Since the
adapter is already gone from the host configuration, ap_zapq() returns
AP_RESPONSE_Q_NOT_AVAIL (0x01). This response code is not handled in
vfio_ap_mdev_reset_queue()'s switch statement and falls through to
the default case, which issues a WARN but does not call
vfio_ap_free_aqic_resources(). As a result, if IRQ handling was
enabled for the queue by the guest, the KVM GISC registration and
the pinned guest page holding the notification indicator byte (NIB)
are both leaked.

This is fixed by adding AP_RESPONSE_Q_NOT_AVAIL to the same case as
AP_RESPONSE_DECONFIGURED and AP_RESPONSE_CHECKSTOPPED in
vfio_ap_mdev_reset_queue(). Like those response codes, Q_NOT_AVAIL
indicates the queue is not operational and no further reset attempts
are possible; the correct action is to free the IRQ resources
immediately.

Problem 2:
~~~~~~~~~
 AP_RESPONSE_Q_NOT_AVAIL not handled in apq_status_check()

In vfio_ap_mdev_reset_queue(), there are four cases that indicate a queue
reset has not yet completed, in which case apq_reset_check() is queued to
a work queue to verify completion of the reset operation. This function
uses the PQAP(TAPQ) function to get the queue's status and calls
apq_status_check() to verify whether the reset has completed, failed or
needs to be executed again. As described in Problem #1 above,
apq_reset_check() does not specifically check for AP_RESPONSE_Q_NOT_AVAIL,
thereby potentially leaking KVM GISC registration and the pinned guest page
holding the NIB.

This is fixed by adding a case statement for AP_RESPONSE_Q_NOT_AVAIL to
apq_status_check() and returning -ENODEV for that case. The caller,
apq_reset_check() will then check for this return code and call
vfio_ap_free_aqic_resources() to prevent the leak.

Problem 3:
~~~~~~~~~
vfio_ap_free_aqic_resources() leaks saved_isc when kvm is NULL

vfio_ap_free_aqic_resources() guards the call to
kvm_s390_gisc_unregister() with:

    if (q->saved_isc != VFIO_AP_ISC_INVALID &&
        !WARN_ON(!(q->matrix_mdev && q->matrix_mdev->kvm)))

If matrix_mdev->kvm is NULL -- which can happen when
vfio_ap_mdev_unset_kvm() has already run and cleared kvm before a
subsequent cleanup path reaches this function -- the WARN_ON fires
and the entire block is skipped. This leaves q->saved_isc set to a
non-invalid value, creating a potential double-free on any subsequent
call to this function.

When kvm is NULL the KVM guest is already torn down, so
kvm_s390_gisc_unregister() need not and cannot be called; however,
q->saved_isc must always be cleared. Fix this by separating the
kvm_s390_gisc_unregister() call from the q->saved_isc reset. The
WARN_ON now guards only the genuinely impossible case of matrix_mdev
being NULL. A NULL kvm is handled gracefully by skipping only the
unregister call, and q->saved_isc = VFIO_AP_ISC_INVALID is set
unconditionally whenever saved_isc was not already invalid.

Additionally, add an else clause to the host-config check in
vfio_ap_mdev_remove_queue() to call vfio_ap_free_aqic_resources()
directly when the queue is not in the host's AP configuration. This
serves as a backstop: when the AP bus fires the driver .remove
callback after an adapter is removed from the host config, the queue
is by definition no longer addressable, so vfio_ap_mdev_reset_queue()
would always return Q_NOT_AVAIL. The else clause handles this case
directly without the unnecessary ap_zapq() call, and ensures cleanup
occurs even if kvm has already been set to NULL by a prior call to
vfio_ap_mdev_unset_kvm().

Fixes: b9bd10c43456d ("s390/vfio-ap: do not reset queue removed from host config")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260818193349.1877940-2-akrowiak@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -277,9 +277,9 @@ static void vfio_ap_free_aqic_resources(
 {
 	if (!q)
 		return;
-	if (q->saved_isc != VFIO_AP_ISC_INVALID &&
-	    !WARN_ON(!(q->matrix_mdev && q->matrix_mdev->kvm))) {
-		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
+	if (q->saved_isc != VFIO_AP_ISC_INVALID) {
+		if (!WARN_ON(!q->matrix_mdev) && q->matrix_mdev->kvm)
+			kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
 		q->saved_isc = VFIO_AP_ISC_INVALID;
 	}
 	if (q->saved_iova && !WARN_ON(!q->matrix_mdev)) {
@@ -1926,6 +1926,8 @@ static int apq_status_check(int apqn, st
 		 * a value indicating a reset needs to be performed again.
 		 */
 		return -EAGAIN;
+	case AP_RESPONSE_Q_NOT_AVAIL:
+		return -ENODEV;
 	default:
 		WARN(true,
 		     "failed to verify reset of queue %02x.%04x: TAPQ rc=%u\n",
@@ -1952,6 +1954,10 @@ static void apq_reset_check(struct work_
 		ret = apq_status_check(q->apqn, &status);
 		if (ret == -EIO)
 			return;
+		if (ret == -ENODEV) {
+			vfio_ap_free_aqic_resources(q);
+			return;
+		}
 		if (ret == -EBUSY) {
 			pr_notice_ratelimited(WAIT_MSG, elapsed,
 					      AP_QID_CARD(q->apqn),
@@ -1995,6 +2001,7 @@ static void vfio_ap_mdev_reset_queue(str
 		break;
 	case AP_RESPONSE_DECONFIGURED:
 	case AP_RESPONSE_CHECKSTOPPED:
+	case AP_RESPONSE_Q_NOT_AVAIL:
 		vfio_ap_free_aqic_resources(q);
 		break;
 	default:
@@ -2470,12 +2477,15 @@ void vfio_ap_mdev_remove_queue(struct ap
 	/*
 	 * If the queue is not in the host's AP configuration, then resetting
 	 * it will fail with response code 01, (APQN not valid); so, let's make
-	 * sure it is in the host's config.
+	 * sure it is in the host's config. If it is not, free the KVM GISC
+	 * resources.
 	 */
 	if (test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm) &&
 	    test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm)) {
 		vfio_ap_mdev_reset_queue(q);
 		flush_work(&q->reset_work);
+	} else {
+		vfio_ap_free_aqic_resources(q);
 	}
 
 done:


