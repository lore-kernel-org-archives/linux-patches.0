Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D0C7318E;
	Tue, 23 Jan 2024 02:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975438; cv=none; b=VK5OeIKZ7QTW4ovJf9wICVAVpsIfkjp08Gb5uyrqCfBNMxMnGzaWbuFHh+8EbA+MVH6oWG4aphMIhrrORdFeX2ERbFBmjlYsO3sAMQu3zf3Prjxo6zGV8CXgDXnJL+MVkqOWQZPykRsq2X03jPjaEO0KEhDAhGuw9Bud/dgOdv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975438; c=relaxed/simple;
	bh=BiVFR/sbAhciphhFjs1w0BygQ9GCm8idW60Elm4Hp5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sf4vyPE5x94D8kk3TwmeFR2IBDPm0jVxwzX8ZAAoSBIw08HHvXa+d92SJ8m3h6rz6apMRgWIr/ZZzrDCo5A4iyKUUbi3LMQf0I/8IlP/VeDGYoVEZ75CDwLJkAxqZYQr0GE2tqF6lb5vp43k+IfeUGkwwK0LM6HshIdOARfRspM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPiXk6No; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPiXk6No"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398B5C433C7;
	Tue, 23 Jan 2024 02:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975438;
	bh=BiVFR/sbAhciphhFjs1w0BygQ9GCm8idW60Elm4Hp5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPiXk6No4qWMRmUMdkNQvxupXWlZYqJZSYwG/gjeASKRdYBifnwBQzlgFkP4QX9J4
	 EHk1VBMjNdYoui6iunOOgw/XZoBdxSQO+1j3N4EndExktniRZflnGgBSv6scaUgJCG
	 8oISyXww/6APDpSqggDwL+XPnXcJzAYhvfYhq3XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 397/583] scsi: mpi3mr: Clean up block devices post controller reset
Date: Mon, 22 Jan 2024 15:57:28 -0800
Message-ID: <20240122235824.132116443@linuxfoundation.org>
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

commit c01d515687e358b22aa8414d6dac60d7defa6eb9 upstream.

After a controller reset, if the firmware changes the state of devices to
"hide", then remove those devices from the OS.

Cc: <stable@vger.kernel.org> # v6.6+
Co-developed-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Link: https://lore.kernel.org/r/20231126053134.10133-3-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 561fe0857bc0..872d4b809d08 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1047,8 +1047,9 @@ void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
 	    list) {
 		if ((tgtdev->dev_handle == MPI3MR_INVALID_DEV_HANDLE) &&
-		    tgtdev->host_exposed && tgtdev->starget &&
-		    tgtdev->starget->hostdata) {
+		     tgtdev->is_hidden &&
+		     tgtdev->host_exposed && tgtdev->starget &&
+		     tgtdev->starget->hostdata) {
 			tgt_priv = tgtdev->starget->hostdata;
 			tgt_priv->dev_removed = 1;
 			atomic_set(&tgt_priv->block_io, 0);
@@ -1064,6 +1065,10 @@ void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
 			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, true);
 			mpi3mr_tgtdev_put(tgtdev);
+		} else if (tgtdev->is_hidden & tgtdev->host_exposed) {
+			dprint_reset(mrioc, "hiding target device with perst_id(%d)\n",
+				     tgtdev->perst_id);
+			mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
 		}
 	}
 
-- 
2.43.0



