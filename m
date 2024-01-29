Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386DC15704D;
	Mon, 29 Jan 2024 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548039; cv=none; b=FleosoN3MsMJh1AioDhB+H2vgzkBI1+MmcTGzuWhmtI/5z+UzFcgVkwr8+PE+APalMQF6iaUYGjIDhJ5G2lgu2zcaKxh+UsFFPLcV+rz39nrCqdPO4weLU+cDz1qU9UnX0mS+FS5CX+PUl9j4vSjhBoO9fredrA5grtcOtR45Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548039; c=relaxed/simple;
	bh=ZxTDKPuU4TMwXFr6JkBdotKffQI6b5uVLpmrF9DMdqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxi399+sVPYzTa0HVVY5sz8tiSqmC56+2dl8LHxQA+vJi7wFYDiJgjIdol+uVVaaWzLX3GbIqyA1vD4CFm6idN1LI7zolU4YBIlubx8fVCEx5p2cCRPYeEHbRoWHAeJXL4snkz2F+O0S9xKgOlnAEhG7xW2KR0vVVbM1Mg8LmZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cO7OTPC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cO7OTPC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C29C433A6;
	Mon, 29 Jan 2024 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548039;
	bh=ZxTDKPuU4TMwXFr6JkBdotKffQI6b5uVLpmrF9DMdqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cO7OTPC6q1+TPlSAe1+XZ6rXRKFtZISyfZKODjNxj2Ba7TDtPk9/G+ooH1U2l+qW4
	 sJ1TIj9LdJAmOjROuKior1PEhUsZtQikiPmG/FIYI0IYDIGWM745UchvCJGIYou209
	 dRF10cATM7EhLxTp7iJkW3Zlam3K6mAFOgxLfZz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.7 038/346] s390/vfio-ap: let on_scan_complete() callback filter matrix and update guests APCB
Date: Mon, 29 Jan 2024 09:01:09 -0800
Message-ID: <20240129170017.506741666@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Krowiak <akrowiak@linux.ibm.com>

commit 774d10196e648e2c0b78da817f631edfb3dfa557 upstream.

When adapters and/or domains are added to the host's AP configuration, this
may result in multiple queue devices getting created and probed by the
vfio_ap device driver. For each queue device probed, the matrix of adapters
and domains assigned to a matrix mdev will be filtered to update the
guest's APCB. If any adapters or domains get added to or removed from the
APCB, the guest's AP configuration will be dynamically updated (i.e., hot
plug/unplug). To dynamically update the guest's configuration, its VCPUs
must be taken out of SIE for the period of time it takes to make the
update. This is disruptive to the guest's operation and if there are many
queues probed due to a change in the host's AP configuration, this could be
troublesome. The problem is exacerbated by the fact that the
'on_scan_complete' callback also filters the mdev's matrix and updates
the guest's AP configuration.

In order to reduce the potential amount of disruption to the guest that may
result from a change to the host's AP configuration, let's bypass the
filtering of the matrix and updating of the guest's AP configuration in the
probe callback - if due to a host config change - and defer it until the
'on_scan_complete' callback is invoked after the AP bus finishes its device
scan operation. This way the filtering and updating will be performed only
once regardless of the number of queues added.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 48cae940c31d ("s390/vfio-ap: refresh guest's APCB by filtering AP resources assigned to mdev")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240115185441.31526-4-akrowiak@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2084,9 +2084,22 @@ int vfio_ap_mdev_probe_queue(struct ap_d
 	if (matrix_mdev) {
 		vfio_ap_mdev_link_queue(matrix_mdev, q);
 
+		/*
+		 * If we're in the process of handling the adding of adapters or
+		 * domains to the host's AP configuration, then let the
+		 * vfio_ap device driver's on_scan_complete callback filter the
+		 * matrix and update the guest's AP configuration after all of
+		 * the new queue devices are probed.
+		 */
+		if (!bitmap_empty(matrix_mdev->apm_add, AP_DEVICES) ||
+		    !bitmap_empty(matrix_mdev->aqm_add, AP_DOMAINS))
+			goto done;
+
 		if (vfio_ap_mdev_filter_matrix(matrix_mdev))
 			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
 	}
+
+done:
 	dev_set_drvdata(&apdev->device, q);
 	release_update_locks_for_mdev(matrix_mdev);
 


