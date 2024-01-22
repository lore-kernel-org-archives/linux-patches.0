Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011B2657B3;
	Tue, 23 Jan 2024 01:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971768; cv=none; b=pftW289FgRZIwRjae7zLNSGch2kGK8ydcFIrjY18714yxxKrNURcprFdP3KhShUc7xmOLo0cfzZgnGUXF8uCP0oYDY4gq3RbOW6+fbQWLnDcwQPIo/0XOgBs+3SEiW3EBUJ2PiHgNqfaPn/KAmL3QAwqWpI+zOkHJXL0NUMEYm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971768; c=relaxed/simple;
	bh=osAyhIlLcbCAinmFGJ5NvwJKxstQ7GiuPuQnSg2BQrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQWQDaq90xOoyy4e/2Gw6uM8CiKRb1xU9KFKpiJfkObhRZ1fKWgnGn/yjm4GpuIyJ99S4ZqvP89LdXeRpf3/MEVLfsVGh3rivDCWh4bGFD4GYACKN0B29vkag1LvZdWZnZ32ZW6uWgpQQ4RnjMiSJUQorEHiVyoenOMBiW59Xn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e74qUoi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e74qUoi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B37AC43399;
	Tue, 23 Jan 2024 01:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971767;
	bh=osAyhIlLcbCAinmFGJ5NvwJKxstQ7GiuPuQnSg2BQrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e74qUoi8ET9pdZ7s2dG9C0y6+T5gl060EIsX7PUlueJqZ258CryamfD+jrNz3ldXS
	 9r8RqrR7xlECmu47FpgOPhLPiL/pjaoz7sWrhchE/WULgfTAW0kWNDL0lFNE/Eva0U
	 vXZ7KPlEoX3btf4x9tZHzvA9h3L8gDaAXPtx2Eto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 291/417] scsi: mpi3mr: Refresh sdev queue depth after controller reset
Date: Mon, 22 Jan 2024 15:57:39 -0800
Message-ID: <20240122235801.911788065@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1044,8 +1044,14 @@ void mpi3mr_rfresh_tgtdevs(struct mpi3mr
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
 


