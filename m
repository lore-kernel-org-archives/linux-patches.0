Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E830468C35;
	Tue, 25 Aug 2026 13:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665685; cv=none; b=ESpR4nu7MHicaHPd3s/Z4+YljRoeTolIOtsjJ1ZVXq7fY1iI9SDD5g/6dnBDN3kntm4Dl7QVxS4y7DsALBsBv841IxCN3q6hj7DsuFPhdleCEqgVobrDjB6r7BDT3nEig4XmuuqwV0l6uA5IZ1PISNcBfx5NXBfyOVEI7krV/UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665685; c=relaxed/simple;
	bh=/Kw6FNW0yFvdmh1XYZKTChym++wiSEMXfgQvUnUrhMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq3AEVWayZjSlGX7O9DCAs3Y6CdFWVc22fV05d50k8ihzdCfxMNh/qcMke/FQE1ZK9/gsdsF+JX5plfTfXA7kvJ5jGX7WKCnvFF8vtfnIDcfGdE5Dxo4lODIALzW7c0iSlhP/ZbdmkQntZb4RL9QFpPzt8YZuCtdcfQ/utrlDaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weNH77p1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weNH77p1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459651F00A3D;
	Tue, 25 Aug 2026 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665683;
	bh=fAiKGFvLYnfzoohe0ED5It0klyfdXc4qddTfgYJzAt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weNH77p1Z6LANqdnl/Ep9kZHIrNZKrKq3m3Vm3F1+ZN9OU6Kskk5RNlzKCuwFUa2/
	 phUUV1DQA+w9ZRumBvoYxWMtiJ35TqpshdgHJjpwdES/qFvTClkdcRFNdzyDSe33KJ
	 WLOyuSaWGGFq1X+j6vFj6vj51MVowqqO/zKGmysk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.6 32/87] s390/vfio_ccw: Calculate idal length based on idaw type
Date: Tue, 25 Aug 2026 15:25:55 +0200
Message-ID: <20260825132543.106725537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

From: Eric Farman <farman@linux.ibm.com>

commit 4f6fdc6e1a7fbfa36b945af33c65a417948feac0 upstream.

Sashiko pointed out that get_guest_idal() unconditionally calculates
the length of the IDAL presuming everything is a Format-2 IDAW.

The output of vfio-ccw is always Format-2, but the input can be either
Format-1 (31-bit addresses) or Format-2 (64-bit addresses). As a result,
the size of the guest IDAL may be incorrect and should be trimmed down.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260720203400.7328E1F000E9@smtp.kernel.org/
Fixes: 1b676fe3d9d3 ("vfio/ccw: handle a guest Format-1 IDAL")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
[farman@linux.ibm.com: resolved merge conflict]
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_cp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -233,6 +233,7 @@ static void convert_ccw0_to_ccw1(struct
 }
 
 #define idal_is_2k(_cp) (!(_cp)->orb.cmd.c64 || (_cp)->orb.cmd.i2k)
+#define get_idaw_size(_cp) ((_cp)->orb.cmd.c64 ? sizeof(u64) : sizeof(u32))
 
 /*
  * Helpers to operate ccwchain.
@@ -522,7 +523,7 @@ static unsigned long *get_guest_idal(str
 	unsigned long *idaws;
 	unsigned int *idaws_f1;
 	u64 first_idaw;
-	int idal_len = idaw_nr * sizeof(*idaws);
+	int idal_len = idaw_nr * get_idaw_size(cp);
 	int idaw_size = idal_is_2k(cp) ? PAGE_SIZE / 2 : PAGE_SIZE;
 	int idaw_mask = ~(idaw_size - 1);
 	int i, ret;
@@ -587,7 +588,7 @@ static int ccw_count_idaws(struct ccw1 *
 	struct vfio_device *vdev =
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	u64 iova;
-	int size = cp->orb.cmd.c64 ? sizeof(u64) : sizeof(u32);
+	int size = get_idaw_size(cp);
 	int ret;
 	int bytes = 1;
 


