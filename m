Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F78615B107;
	Mon, 29 Jan 2024 17:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548453; cv=none; b=U5f7IZaPzrrU/FTD1uDhHjd+rhbR2c3sxbUnuE8ZIFOU9Imxy42DtMNsxOnfvhOmLdCnSJlaOwKAG5MARcf4gt5wiMTmcs7nMoigG3JWG5sM4Yih/doykDIG+CO/KZMXRq27qjSlUwtHE/JS6B6ewITl/Nwzhh63J99a4YWB4M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548453; c=relaxed/simple;
	bh=/0I9j1XNuaiRzDPCroyxRmiqGVEUKsriA5DIAuuF3no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X28qNfKxffO8k/Oh3GgVN/lteTfOXkU8A1FA25vCxDLSoAgwr3PkEuBbxkOLdLoyzPI63z7V1byB2/l55b/IOyZqUKUEgTjb7qWMIUXP6qJqBtGh16MPFgroroFiEZYtQrn1lIjWIX3LnYosd4FDdJeG3xKJ5NoqTJ5B9e5bIQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfDRRuRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfDRRuRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575D9C433C7;
	Mon, 29 Jan 2024 17:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548453;
	bh=/0I9j1XNuaiRzDPCroyxRmiqGVEUKsriA5DIAuuF3no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfDRRuRLr8gOMwRrrMVGHNM9w8uxqj8P6jgVElWTF15j+wclYDnZbwoFK5QAzmvTV
	 1YO1iFJU0/MDXqNT9r2dNNVD0W2AUnmYthvWe6+1ztSgrbRWm7QA446qzh7Fm1kZHc
	 uBimwi1lBoV4NXdvni4FyWEpp6S+Z8ObRjJOiMyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	"Jason J. Herne" <jjherne@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.6 064/331] s390/vfio-ap: do not reset queue removed from host config
Date: Mon, 29 Jan 2024 09:02:08 -0800
Message-ID: <20240129170016.809170425@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Krowiak <akrowiak@linux.ibm.com>

commit b9bd10c43456d16abd97b717446f51afb3b88411 upstream.

When a queue is unbound from the vfio_ap device driver, it is reset to
ensure its crypto data is not leaked when it is bound to another device
driver. If the queue is unbound due to the fact that the adapter or domain
was removed from the host's AP configuration, then attempting to reset it
will fail with response code 01 (APID not valid) getting returned from the
reset command. Let's ensure that the queue is assigned to the host's
configuration before resetting it.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: "Jason J. Herne" <jjherne@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: eeb386aeb5b7 ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240115185441.31526-7-akrowiak@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2198,10 +2198,10 @@ void vfio_ap_mdev_remove_queue(struct ap
 	q = dev_get_drvdata(&apdev->device);
 	get_update_locks_for_queue(q);
 	matrix_mdev = q->matrix_mdev;
+	apid = AP_QID_CARD(q->apqn);
+	apqi = AP_QID_QUEUE(q->apqn);
 
 	if (matrix_mdev) {
-		apid = AP_QID_CARD(q->apqn);
-		apqi = AP_QID_QUEUE(q->apqn);
 		/* If the queue is assigned to the guest's AP configuration */
 		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
 		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
@@ -2217,8 +2217,16 @@ void vfio_ap_mdev_remove_queue(struct ap
 		}
 	}
 
-	vfio_ap_mdev_reset_queue(q);
-	flush_work(&q->reset_work);
+	/*
+	 * If the queue is not in the host's AP configuration, then resetting
+	 * it will fail with response code 01, (APQN not valid); so, let's make
+	 * sure it is in the host's config.
+	 */
+	if (test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm) &&
+	    test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm)) {
+		vfio_ap_mdev_reset_queue(q);
+		flush_work(&q->reset_work);
+	}
 
 done:
 	if (matrix_mdev)


