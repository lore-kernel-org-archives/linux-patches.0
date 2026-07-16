Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32975A79B;
	Thu, 16 Jul 2026 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210633; cv=none; b=cAUQ7wdCse3rGX5pYuf+sEhAmEOPb4dV5YaKCT/eiHMz0QwRcqSMYe6fslkoUAA+C5xwzLuPjFWNNtPeIxyc3TT/SheG09O30LYgnpaWoS/78in9vcH42WBT4BUqIXfyo91KNPpP5AR5coe/kFKdszbvuF58kKNJxlSGTmLNhlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210633; c=relaxed/simple;
	bh=jTLHwIWHi8h4vtFAeAWzAP5BGKQcndY9cUiQ9pvnr38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtnfy+nejiP6065X0P7Q3Xtf4Ov8V4BsMfqv8co29B0LJLcqyEgyrT3DBpKqetc9kuo4TNSTEdUdV6FxWdWyB5B1wZLuUkZmT4Snf67slFAax2FfRecM0e9LTR4eHCLmf6mL9N4uk/zSTJ2ypb94fIQAm9dFZ19Sxp40eg//ifU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7MfycPB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7MfycPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E881F000E9;
	Thu, 16 Jul 2026 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210631;
	bh=4sec89oHX9LuVNv5S+T3nU5LUAqXg4X5DoRWghbNuK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7MfycPBZ3CT+jUTGtAxSVbaUFUsLLICM86bqD/SndVtEBU5hrvLEevIUa2aZcIWF
	 wCdCRpRnU9E6ZhxidDhszVPqMLmcYtapNFW8XSnhtbGS1NocWrTBbJ69NnSNjp6cYu
	 PL6SeKkM6xeBYl+qM8A7fpn8yVFj6r9J/u2hhmMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.18 120/480] vfio: prevent infinite loop in vfio_mig_get_next_state() on blocked arc
Date: Thu, 16 Jul 2026 15:27:47 +0200
Message-ID: <20260716133047.302360680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -846,7 +846,8 @@ int vfio_mig_get_next_state(struct vfio_
 	 * logical state, as per the above comment.
 	 */
 	*next_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
-	while ((state_flags_table[*next_fsm] & device->migration_flags) !=
+	while (*next_fsm != VFIO_DEVICE_STATE_ERROR &&
+	       (state_flags_table[*next_fsm] & device->migration_flags) !=
 			state_flags_table[*next_fsm])
 		*next_fsm = vfio_from_fsm_table[*next_fsm][new_fsm];
 


