Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB2441F5EC;
	Thu, 16 Jul 2026 13:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209243; cv=none; b=HPBSZFDT96OjlfeMuRuHdr2AaSE+CeDWRK9CfNc9OjggFyLrxF1+ZWK+4Lrf+kc+1bdrIApqt+rPuV/tkICvpcOEXMd5K7ColYB8NPQhmnvJfoeVW3BV1S9t2/2hAUsjfJMfzNG/xs8zaX//VrtiDqzuZQP9DhcjAPDKTEfXvgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209243; c=relaxed/simple;
	bh=wMOyKfAesPt3w1h5u1WqOgrU56E7IFyDsBsFOsDee5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPRmtKyxymg12DnpoT7p5h3cZdGp2OPFeO6/OT3aKGQHgE2kHvLQ3R7pJ63p+IXF7cj8BVHl58JKTlK9Ofajg8keCp8YaLXQw6mOUFkmQiSFsUNuY9UDqholNMj2FspDDnc+lFbBIIAoH0xhprhzBPwU6pGB6+D4jF3xTGK0xJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POYZHjDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POYZHjDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1D01F000E9;
	Thu, 16 Jul 2026 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209242;
	bh=g0Wwcmixyiw5/DFspMch3LWYNwN3J3W5liXIIAQPZck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POYZHjDx4he8bxqNeUkdR7YteiOETL6MiZcnpmqQ0FTjXMX0L23bmT+eau+qcsX2L
	 nNyEDI3kWkJS5MwHcwt+PQtI0s+npawVDBAJ7xf/DKEVxVsKgRQL/KTHppuCudDr+Q
	 UUyLCGCohIerk+dNElfjQD5Gsz/mZ08Q2KXm07Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 7.1 110/518] vfio: prevent infinite loop in vfio_mig_get_next_state() on blocked arc
Date: Thu, 16 Jul 2026 15:26:18 +0200
Message-ID: <20260716133050.260633614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -858,7 +858,8 @@ int vfio_mig_get_next_state(struct vfio_
 	 * logical state, as per the above comment.
 	 */
 	*next_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
-	while ((state_flags_table[*next_fsm] & device->migration_flags) !=
+	while (*next_fsm != VFIO_DEVICE_STATE_ERROR &&
+	       (state_flags_table[*next_fsm] & device->migration_flags) !=
 			state_flags_table[*next_fsm])
 		*next_fsm = vfio_from_fsm_table[*next_fsm][new_fsm];
 


