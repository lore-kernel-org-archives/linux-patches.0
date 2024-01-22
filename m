Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920567318E;
	Tue, 23 Jan 2024 02:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975437; cv=none; b=uVHTgb/ep49Lysho05aspPNQvf4c9IdMO0q6t6PGCC4MkrDQcstnrQQF0gmhoTs1B7GrGfIStheW2O6X5glU4SxyFc8kRWvVpXeCJT4i+Hanbz06eZY7JftfgvFDAGS183ZmFzNSxzNmYS2aBuHCb+zQ+0MjjY5z69y4Nj6Wchc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975437; c=relaxed/simple;
	bh=LmWENgodePq7gIkeeLBgx4VtHiiVZiRRjYVar0zGIzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRgXKiqF/pIg8JIlvfEoLhK4kTgsrm0gtp77vKr8zPTF4FqPabLqpUHuiU8mMyogxDDgoKTy93GeATCnNc97JPCcW9sikekNFEYx4eM86QRYrSdvdzQFQl2BI+yQ+tKYjRQBcuXEtE6bnQLTxjsTfq8gy6ok5QUoBZmrm7+DiZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtTYuJJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtTYuJJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAAEC433C7;
	Tue, 23 Jan 2024 02:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975437;
	bh=LmWENgodePq7gIkeeLBgx4VtHiiVZiRRjYVar0zGIzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtTYuJJS91YZ8utfqwN1quorggn70RdIT3vF80nhdAhHqBl7POgGM6UhyRAY5i5eW
	 BBx+W9d48HkVtMmmYL19PgoBBreDAfJ7w+NxlV40WNMrMoXTqzIlC3EYxjPFNMYCsS
	 u3xiUrWnboC+KpHzeK2PHDwsB/MBhZhWpGkBG+UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 396/583] scsi: mpi3mr: Refresh sdev queue depth after controller reset
Date: Mon, 22 Jan 2024 15:57:27 -0800
Message-ID: <20240122235824.099962415@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
 


