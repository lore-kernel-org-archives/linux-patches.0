Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2760424A078;
	Tue, 21 Jul 2026 20:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664956; cv=none; b=NWZbjIjc5RZqWkAT0f5gLIKpf5tsXIoGDbLNvIy6VSwZwmgRiSs3+/vaKR1K2+6UtFHOH8cqRIMqPftZtzhEMz08tk1hw1O7VSAr0yT0lQ67GMbSlRlGxVozpaEoKDdKWcdsBWmYrs8NynEnotX79ffKVmY3DNM8Cm12S1zFv8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664956; c=relaxed/simple;
	bh=MgfxCrYsQtY2YaZDy7DwJlxHn+Et58YQ+fJL01L/Yf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFitS1Q9cWALlBIOqqq8SZAfyMhGlstW2udFmTmPTTJvNtrIRvjtiF+s3s6VYv5ekGk82kJcaKgpOIoe9sU1CCdFqAQcy5PFHCQlCTYYji6WuSFXeEyEDE+Zo5uXGs0dBnPCBS7/DcInfzNqMTC2eYx5mG+JSV1JZjo9U3UaD6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzY5rLru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzY5rLru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEA81F000E9;
	Tue, 21 Jul 2026 20:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664955;
	bh=TjZbudQKQ2Iykh1dvooiWoW66xdYYMjYaFUwuKUxtvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzY5rLruCFhphmxxLi15VkHKC0tSaC9FKTWMn3c1UKaNfhDWKV1gthpO6l78XH+pd
	 s6emBkldyMB/tsPAW56XZQqZHzpc1Npj5AEsIQQ0V2l8vwlxreru2D8jYCKew3dtU7
	 tp3/r7T1WiLMiEpMyEfdO8EDvb61AMV4IyurGmJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.6 0121/1266] vfio: prevent infinite loop in vfio_mig_get_next_state() on blocked arc
Date: Tue, 21 Jul 2026 17:09:18 +0200
Message-ID: <20260721152444.508888828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit a26b499b757cfc8bbff1088bb1b844639e250893 upstream.

vfio_mig_get_next_state() walks vfio_from_fsm_table[] one step at a time,
looping to skip optional states the device does not support until
*next_fsm is supported. A blocked transition is encoded as
VFIO_DEVICE_STATE_ERROR, which the trailing return reports as -EINVAL.

The skip loop does not account for the ERROR sentinel.
state_flags_table[ERROR] is ~0U and vfio_from_fsm_table[ERROR][*] is
ERROR, so once *next_fsm becomes ERROR the loop condition stays true and
*next_fsm never changes. The blocked arcs STOP_COPY -> PRE_COPY and
STOP_COPY -> PRE_COPY_P2P map to ERROR yet pass the support check on a
precopy-capable device, causing the loop to spin forever while holding
the driver state mutex. This can result in a soft lockup, and a panic
with softlockup_panic set.

Terminate the skip loop on the ERROR sentinel so a blocked transition
falls through to the existing return and reports -EINVAL.

Fixes: 4db52602a607 ("vfio: Extend the device migration protocol with PRE_COPY")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/SYBPR01MB7881290BBDE79B61AE6A017FAF122@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/vfio_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -843,7 +843,8 @@ int vfio_mig_get_next_state(struct vfio_
 	 * logical state, as per the above comment.
 	 */
 	*next_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
-	while ((state_flags_table[*next_fsm] & device->migration_flags) !=
+	while (*next_fsm != VFIO_DEVICE_STATE_ERROR &&
+	       (state_flags_table[*next_fsm] & device->migration_flags) !=
 			state_flags_table[*next_fsm])
 		*next_fsm = vfio_from_fsm_table[*next_fsm][new_fsm];
 


