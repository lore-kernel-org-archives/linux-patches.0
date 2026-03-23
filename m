Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678272C0298;
	Mon, 23 Mar 2026 16:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282704; cv=none; b=NcGQNpyeYhLjsgYduSMwkcxoMQfNioJzDhwSrOell/XfJRFgmXMuqDhwy+7H/KTe6adn8LKVxZ42fyJZMYdgoGQku1jAL/hsvc1gBfeR6uqRqB5uy6fie9IZfajJ92tyUgsibS7rgpAXNt8AimM00/fmp/4vhGS09UR6/IlQdtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282704; c=relaxed/simple;
	bh=iz+tDc3JqXg3XWU+9UksYzYeacaSvUVt2j5YNs+JsKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSKL/ZiP/HpJMW2zFVDgSvgq0ZtUQx5WqUNBcIybFrRyDt1FnTAKa/JVjNUz7D9Jcq0UizgeD+oz9SJLkiK+fbux5kKufvy2GRAjyRq1PWjs7iNbEMlNCuu2Su8eqLqE75uVvjnvB4maTaSd0+iCmUyXd0SkokD/tsWqvsDsZ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zw1VcEwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zw1VcEwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E69C4CEF7;
	Mon, 23 Mar 2026 16:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282704;
	bh=iz+tDc3JqXg3XWU+9UksYzYeacaSvUVt2j5YNs+JsKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zw1VcEwtNJ0rFzulN27A/ZOk4J1T8JUS0brYZ7YTeh5jaFyKPYlo3HZkYApTfiAOJ
	 wh4jwk88ASMocxACdAaWJn4jY20oGhJKrR5pI5qhqHC1r3rqVje/ednk/KYRXUMvmi
	 +LV5yj3BdYWb0q7+f261QohzOvcDY1F9kKrFqyhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Eduard Shishkin <edward6@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 255/481] s390/dasd: Copy detected format information to secondary device
Date: Mon, 23 Mar 2026 14:43:57 +0100
Message-ID: <20260323134531.369917072@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6186,6 +6186,7 @@ static void copy_pair_set_active(struct
 static int dasd_eckd_copy_pair_swap(struct dasd_device *device, char *prim_busid,
 				    char *sec_busid)
 {
+	struct dasd_eckd_private *prim_priv, *sec_priv;
 	struct dasd_device *primary, *secondary;
 	struct dasd_copy_relation *copy;
 	struct dasd_block *block;
@@ -6206,6 +6207,9 @@ static int dasd_eckd_copy_pair_swap(stru
 	if (!secondary)
 		return DASD_COPYPAIRSWAP_SECONDARY;
 
+	prim_priv = primary->private;
+	sec_priv = secondary->private;
+
 	/*
 	 * usually the device should be quiesced for swap
 	 * for paranoia stop device and requeue requests again
@@ -6238,6 +6242,13 @@ static int dasd_eckd_copy_pair_swap(stru
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


