Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB423816F0;
	Wed, 21 Jan 2026 18:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019644; cv=none; b=glrNLejFT1MDlOD7YkDTO82VYdpoA7pPgONVTajtkHCj9s9FtHVDuoJyWSdf9YR9UXmlvP3BQFAiNxypmfEXOcUgRToTDrHY0GcZ5xPUNn/lEt9zpNqIzrrND80vfT1ntUYoOdFOpyiYrEkuZBC/NO/iU9+SmLvvPIA5OG+qsdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019644; c=relaxed/simple;
	bh=M158QqM/h0O5RKj1r+0Xijb5IykoVJPsQyUoEZvual4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvPtRXGaVtdvGhxZdc6ErRcG+cwtcO3QZ7uMTw+Xlos3275BLhPDv8Ca81LLw1Qg1kaAaVMIAL4dYnw7D63TfkFNZnRXbgVFnlyyJPziubxSySqBtgTxsex8HBbfmFeZPNpuHbChxiPzMkVsSKFva0hwfteCTYi99uwbm9JE+7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUkFECKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUkFECKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F02C4CEF1;
	Wed, 21 Jan 2026 18:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019643;
	bh=M158QqM/h0O5RKj1r+0Xijb5IykoVJPsQyUoEZvual4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUkFECKOwzQCJv3F0MoaU4yWowSyU8lcuUuabDpJ6gAF4fTG+2zgxVjCr3hfLqJJd
	 dnuAmfQw9j7iQaoS+ZpbIJ/XU9HcsO7TCqlc3eojDtTYxnG4ot7rmZj3Rr+VoL2ltn
	 PWPahlqBu+QaiH0vwBDsmwqfdmfnm5tHkqLbvXm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 066/139] null_blk: fix kmemleak by releasing references to fault configfs items
Date: Wed, 21 Jan 2026 19:15:14 +0100
Message-ID: <20260121181413.829909561@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

From: Nilay Shroff <nilay@linux.ibm.com>

commit 40b94ec7edbbb867c4e26a1a43d2b898f04b93c5 upstream.

When CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION is enabled, the null-blk
driver sets up fault injection support by creating the timeout_inject,
requeue_inject, and init_hctx_fault_inject configfs items as children
of the top-level nullbX configfs group.

However, when the nullbX device is removed, the references taken to
these fault-config configfs items are not released. As a result,
kmemleak reports a memory leak, for example:

unreferenced object 0xc00000021ff25c40 (size 32):
  comm "mkdir", pid 10665, jiffies 4322121578
  hex dump (first 32 bytes):
    69 6e 69 74 5f 68 63 74 78 5f 66 61 75 6c 74 5f  init_hctx_fault_
    69 6e 6a 65 63 74 00 88 00 00 00 00 00 00 00 00  inject..........
  backtrace (crc 1a018c86):
    __kmalloc_node_track_caller_noprof+0x494/0xbd8
    kvasprintf+0x74/0xf4
    config_item_set_name+0xf0/0x104
    config_group_init_type_name+0x48/0xfc
    fault_config_init+0x48/0xf0
    0xc0080000180559e4
    configfs_mkdir+0x304/0x814
    vfs_mkdir+0x49c/0x604
    do_mkdirat+0x314/0x3d0
    sys_mkdir+0xa0/0xd8
    system_call_exception+0x1b0/0x4f0
    system_call_vectored_common+0x15c/0x2ec

Fix this by explicitly releasing the references to the fault-config
configfs items when dropping the reference to the top-level nullbX
configfs group.

Cc: stable@vger.kernel.org
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Fixes: bb4c19e030f4 ("block: null_blk: make fault-injection dynamically configurable per device")
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/main.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -655,12 +655,22 @@ static void nullb_add_fault_config(struc
 	configfs_add_default_group(&dev->init_hctx_fault_config.group, &dev->group);
 }
 
+static void nullb_del_fault_config(struct nullb_device *dev)
+{
+	config_item_put(&dev->init_hctx_fault_config.group.cg_item);
+	config_item_put(&dev->requeue_config.group.cg_item);
+	config_item_put(&dev->timeout_config.group.cg_item);
+}
+
 #else
 
 static void nullb_add_fault_config(struct nullb_device *dev)
 {
 }
 
+static void nullb_del_fault_config(struct nullb_device *dev)
+{
+}
 #endif
 
 static struct
@@ -692,7 +702,7 @@ nullb_group_drop_item(struct config_grou
 		null_del_dev(dev->nullb);
 		mutex_unlock(&lock);
 	}
-
+	nullb_del_fault_config(dev);
 	config_item_put(item);
 }
 


