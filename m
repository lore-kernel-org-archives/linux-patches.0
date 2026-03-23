Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B0A387593;
	Mon, 23 Mar 2026 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276896; cv=none; b=Q+ZTgRdgzjsWR6xVOe2F3WRuwpUAkAitk3yOYMylfFN4pdSX7qGrOFhquUsQ8XEWIxoyQrr/2/6NhdDN84St9mSMw1HSzV5ltCPpWvxJz4/xWX1+VMw0AzFVrrEFSPDmHIwDVwsqgM8rKvW2XQlZL3OvFRys/JOWXETNcZ4LDwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276896; c=relaxed/simple;
	bh=YrqcFDENyNTIDeEqs7h/fqKJnF+RmsvPidVpiS93egk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZxOr0yUmC/eX84w3yH9g6l/EiB2hBt2A7J6noG2ff9171O7JMO/5e+/DTqITJnKoA11fG1pPVNLDqVOIitLiFxxuIgZuFYSnjXhyXmvbbtJpJ7OFq1/O161rXc61SNJ+fZKxf3ydIIMZLKs1kva8Ez9q3hy59yviG0xQBI4sxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KY1k1p9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KY1k1p9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DFAC4CEF7;
	Mon, 23 Mar 2026 14:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276896;
	bh=YrqcFDENyNTIDeEqs7h/fqKJnF+RmsvPidVpiS93egk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KY1k1p9J85mxwKdIoAkyftIWPJ4HQYPuSiatq7KImUOAE1bX6J4CaVGHXB6zQi53G
	 8JBweZB+yjj0Ah6T6Y2HQyGUnnGXVrP5SysVZjGY9l8vSiWUGGmkaY7UEa59I6g3nu
	 StbJbmP55aFrykndaIgKPpEoo0wGARbyorVtDwSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Eduard Shishkin <edward6@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 191/460] s390/dasd: Copy detected format information to secondary device
Date: Mon, 23 Mar 2026 14:43:07 +0100
Message-ID: <20260323134531.241162497@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
@@ -6145,6 +6145,7 @@ static void copy_pair_set_active(struct
 static int dasd_eckd_copy_pair_swap(struct dasd_device *device, char *prim_busid,
 				    char *sec_busid)
 {
+	struct dasd_eckd_private *prim_priv, *sec_priv;
 	struct dasd_device *primary, *secondary;
 	struct dasd_copy_relation *copy;
 	struct dasd_block *block;
@@ -6165,6 +6166,9 @@ static int dasd_eckd_copy_pair_swap(stru
 	if (!secondary)
 		return DASD_COPYPAIRSWAP_SECONDARY;
 
+	prim_priv = primary->private;
+	sec_priv = secondary->private;
+
 	/*
 	 * usually the device should be quiesced for swap
 	 * for paranoia stop device and requeue requests again
@@ -6197,6 +6201,13 @@ static int dasd_eckd_copy_pair_swap(stru
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


