Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C92F346797;
	Tue, 17 Mar 2026 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766819; cv=none; b=dAoL+XyxaCDj8PctVgFA15dUPv2KJNYTnBWpVF7+IwSGO+crSS4cjr6sdX5SXckWD0gjwjlzL/gqjeElpSqd94qclA4euuyKgteenssymW9txrCZxeKiT2KLfh6b/W93sNQjk+9PgRb3LO7nFjT43JoeVj/SlucxpvluEcAvPLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766819; c=relaxed/simple;
	bh=/xG/mQNV+CHiPHxtgfr/eZoFEyKziawHdzA1mPv3pPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SldzwvGCJ49s5bQLMjfDNFLKiRruVSYZPmSQOI40R+kC/SacrcLYsKBWTfyRsaq2eMAofTYl+Obrheq7wF2Ywz5g5mVSuyFRgtUcD6xhRte7Tr8yEjLrew60Lkv8eOnRRD5HlafQdIWweUViFqz5ExsTUcaaHM7sLBb5FqaiGNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvxI+lWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvxI+lWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94D3C4CEF7;
	Tue, 17 Mar 2026 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766819;
	bh=/xG/mQNV+CHiPHxtgfr/eZoFEyKziawHdzA1mPv3pPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvxI+lWtRVJzeDnLBeAebQICTU6Sc6NcK01mSvZ0Vm3ea7Nv1bnZauXfvbPhScXBs
	 umRTQ9/rHP5wzUdvFMk/7jpGw78BcsUyFUZEBDZd+bFd/GE+CpZs9Fc0Ksv/xvYXuT
	 C1pwrrfCMtkPCsRCjhrQGBF3Y9jUTrCe7cgoxidY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Eduard Shishkin <edward6@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 328/378] s390/dasd: Copy detected format information to secondary device
Date: Tue, 17 Mar 2026 17:34:45 +0100
Message-ID: <20260317163019.055292442@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit 4c527c7e030672efd788d0806d7a68972a7ba3c1 upstream.

During online processing for a DASD device an IO operation is started to
determine the format of the device. CDL format contains specifically
sized blocks at the beginning of the disk.

For a PPRC secondary device no real IO operation is possible therefore
this IO request can not be started and this step is skipped for online
processing of secondary devices. This is generally fine since the
secondary is a copy of the primary device.

In case of an additional partition detection that is run after a swap
operation the format information is needed to properly drive partition
detection IO.

Currently the information is not passed leading to IO errors during
partition detection and a wrongly detected partition table which in turn
might lead to data corruption on the disk with the wrong partition table.

Fix by passing the format information from primary to secondary device.

Fixes: 413862caad6f ("s390/dasd: add copy pair swap capability")
Cc: stable@vger.kernel.org #6.1
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Acked-by: Eduard Shishkin <edward6@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260310142330.4080106-3-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -6135,6 +6135,7 @@ static void copy_pair_set_active(struct
 static int dasd_eckd_copy_pair_swap(struct dasd_device *device, char *prim_busid,
 				    char *sec_busid)
 {
+	struct dasd_eckd_private *prim_priv, *sec_priv;
 	struct dasd_device *primary, *secondary;
 	struct dasd_copy_relation *copy;
 	struct dasd_block *block;
@@ -6155,6 +6156,9 @@ static int dasd_eckd_copy_pair_swap(stru
 	if (!secondary)
 		return DASD_COPYPAIRSWAP_SECONDARY;
 
+	prim_priv = primary->private;
+	sec_priv = secondary->private;
+
 	/*
 	 * usually the device should be quiesced for swap
 	 * for paranoia stop device and requeue requests again
@@ -6187,6 +6191,13 @@ static int dasd_eckd_copy_pair_swap(stru
 		dasd_device_remove_stop_bits(primary, DASD_STOPPED_QUIESCE);
 	}
 
+	/*
+	 * The secondary device never got through format detection, but since it
+	 * is a copy of the primary device, the format is exactly the same;
+	 * therefore, the detected layout can simply be copied.
+	 */
+	sec_priv->uses_cdl = prim_priv->uses_cdl;
+
 	/* re-enable device */
 	dasd_device_remove_stop_bits(primary, DASD_STOPPED_PPRC);
 	dasd_device_remove_stop_bits(secondary, DASD_STOPPED_PPRC);


