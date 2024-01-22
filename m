Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD4215E272;
	Tue, 23 Jan 2024 00:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969764; cv=none; b=tVqebBq8mI27KwrgEOytQEYgh5rLbVNfeu3xDwhFAywK52HB0eIh/3HCWNwdHoST/dJNYOG9vI2gUYkio5hURFQQ60TImE2eqGZsGllZIhf2lgg7nJypk3/Qinit+Arsbwl8tEvKQ/Dyeg52PLEkZM9BVNHRrDYvKorpIRJfzAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969764; c=relaxed/simple;
	bh=DzdoeayJhfmuJv9tVvRTTqftDLfw1vN3018M+Y2M8Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqcBuRduGpemtIFQkNTnrLcCWsn/2mmoUJBsw2pzNbFSs7hCKZ1xzIIVLbDsiuG9M9FJ99jRn5S/ExiPe0MpBdd5LkqgPybXpUJoGOyM84F87/iT4cz6oHU5+P0bOWrPMz3pcIpMtl7Ato0SEoSAO7onc9lYff0guz+NzhKo/8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDPmojSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDPmojSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7449FC433F1;
	Tue, 23 Jan 2024 00:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969762;
	bh=DzdoeayJhfmuJv9tVvRTTqftDLfw1vN3018M+Y2M8Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDPmojSCuAvwXtMe/xv185H1z2mKPDSR0CCYjel9SjpaCyuV+ijrn4yoAafoW5PJi
	 kOuFv+q6Xy965vLTJjF5RwrLJFSzKHHUUoBxlkdQ4sFDIJkCURYc2H9Ama58IkyNJ1
	 Dop97n1T28jo6EHpV8EsAV2b8VVo+kNpOfw4/tzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 435/641] scsi: mpi3mr: Refresh sdev queue depth after controller reset
Date: Mon, 22 Jan 2024 15:55:39 -0800
Message-ID: <20240122235831.603086807@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Chandrakanth patil <chandrakanth.patil@broadcom.com>

commit e5aab848dfdf7996d20ece4d28d2733c732c5e5a upstream.

After a controller reset, the firmware may modify the device queue depth.
Therefore, update the device queue depth accordingly.

Cc: <stable@vger.kernel.org> # v5.15+
Co-developed-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Link: https://lore.kernel.org/r/20231126053134.10133-2-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1070,8 +1070,14 @@ void mpi3mr_rfresh_tgtdevs(struct mpi3mr
 	tgtdev = NULL;
 	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
 		if ((tgtdev->dev_handle != MPI3MR_INVALID_DEV_HANDLE) &&
-		    !tgtdev->is_hidden && !tgtdev->host_exposed)
-			mpi3mr_report_tgtdev_to_host(mrioc, tgtdev->perst_id);
+		    !tgtdev->is_hidden) {
+			if (!tgtdev->host_exposed)
+				mpi3mr_report_tgtdev_to_host(mrioc,
+							     tgtdev->perst_id);
+			else if (tgtdev->starget)
+				starget_for_each_device(tgtdev->starget,
+							(void *)tgtdev, mpi3mr_update_sdev);
+	}
 	}
 }
 


