Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8315318A6C1;
	Mon,  6 Jan 2025 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177320; cv=none; b=MMRgK+aPBnpBhKjmXMUoNaNi/dJiXufv0LUnG7YjXzGHbCE4ATSDhlcmRxE4Vme97B7f9oDy3NXBrGJFsbhGXk1gtKLyeZNZEnpNyyPOc1h/1g61maL8bNVrDAzxSTFSro6aeG6SRFuydB5sFMjxpOJXR83wyQsRpuF01L6tYj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177320; c=relaxed/simple;
	bh=glKbAY8kJrQdbHT9uJyH+vhDRwB2yqgC9VzvBcMKo58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drBDng5dJ1JnFpQWKTLyDyJStWlUrxrQvdsos9ESZFWsDmw7wsT3HRSLdUZyYDrsNkL5OE4ETmM0L/Sm5B1JX2Go84f5ZMx5gRmMdx4I3U7Fi1j/wwKVUs3iKjxbWActi2qg6dJkw9+19XLEKC3j1X71RqDanG51NCQkDnUUKbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mu2F94XJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mu2F94XJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D72C4CED2;
	Mon,  6 Jan 2025 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177320;
	bh=glKbAY8kJrQdbHT9uJyH+vhDRwB2yqgC9VzvBcMKo58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mu2F94XJ6DDHlslpQ5wHv4QgSMTKtWnBck/KZTbUV11nsBxGhZe4l5D0A6GF/O1/E
	 LnYx4idRvulrI+3FbH58W7D7vMVD9VowiMsd38FEo/9CT/deGKqeXvBZMaJd0ByeIY
	 nnKaKL4+8J1upLMCK6f2mVr3tLep/0QRyk39xcS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/222] scsi: mpi3mr: Use ida to manage mrioc ID
Date: Mon,  6 Jan 2025 16:14:57 +0100
Message-ID: <20250106151154.117096194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 29b75184f721b16c51ef6e67eec0e40ed88381c7 ]

To ensure that the same ID is not obtained during concurrent execution of
the probe, an ida is used to manage the mrioc's ID.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20231229040331.52518-1-kanie@linux.alibaba.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 0d32014f1e3e ("scsi: mpi3mr: Start controller indexing from 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 7f3261923469..3f86f1d0a9be 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -8,11 +8,12 @@
  */
 
 #include "mpi3mr.h"
+#include <linux/idr.h>
 
 /* global driver scop variables */
 LIST_HEAD(mrioc_list);
 DEFINE_SPINLOCK(mrioc_list_lock);
-static int mrioc_ids;
+static DEFINE_IDA(mrioc_ida);
 static int warn_non_secure_ctlr;
 atomic64_t event_counter;
 
@@ -5065,7 +5066,10 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc = shost_priv(shost);
-	mrioc->id = mrioc_ids++;
+	retval = ida_alloc_range(&mrioc_ida, 1, U8_MAX, GFP_KERNEL);
+	if (retval < 0)
+		goto id_alloc_failed;
+	mrioc->id = (u8)retval;
 	sprintf(mrioc->driver_name, "%s", MPI3MR_DRIVER_NAME);
 	sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id);
 	INIT_LIST_HEAD(&mrioc->list);
@@ -5215,9 +5219,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 resource_alloc_failed:
 	destroy_workqueue(mrioc->fwevt_worker_thread);
 fwevtthread_failed:
+	ida_free(&mrioc_ida, mrioc->id);
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
+id_alloc_failed:
 	scsi_host_put(shost);
 shost_failed:
 	return retval;
@@ -5303,6 +5309,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 		mrioc->sas_hba.num_phys = 0;
 	}
 
+	ida_free(&mrioc_ida, mrioc->id);
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
@@ -5518,6 +5525,7 @@ static void __exit mpi3mr_exit(void)
 			   &driver_attr_event_counter);
 	pci_unregister_driver(&mpi3mr_pci_driver);
 	sas_release_transport(mpi3mr_transport_template);
+	ida_destroy(&mrioc_ida);
 }
 
 module_init(mpi3mr_init);
-- 
2.39.5



