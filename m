Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2DC1AA7A6;
	Tue, 17 Mar 2026 17:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768066; cv=none; b=XZeePuYome2jbY9+gzIiFGsgpeogJrir5PhqnaqD5dj0dFGNj7gvWTH+iCXCwCrnEPIJPBQoWh5i6oSFcgCAba8KwfxL+b+o/BQCxKSIp8YVWVjNTdAA5kXqavCQQfSwMfCMrzylp8kYMSQTbwoIqQk2jWrm5txa0Qj+zpM0J/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768066; c=relaxed/simple;
	bh=n/IxQ3Pjztk20sGafLWxi4jmOdR5TuOOWamJfyO0uoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBclCwdqr5gOc3Hs4F6O6oTqJjV4WqZwc5KRiZ9kbpii7r0VH5hl4Awd+VFE9VfeNNVW3gcfLJsfdmkJHL9pKmZhQfdlER1O+yfYe1a3iv/NbpUUGqyEw1Vdp2IGPBypweSkY0136lh9EEvr2+Do/khqe3JQV45jej6D7NU3alg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ykl8zt1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ykl8zt1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0444BC4CEF7;
	Tue, 17 Mar 2026 17:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768066;
	bh=n/IxQ3Pjztk20sGafLWxi4jmOdR5TuOOWamJfyO0uoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ykl8zt1h5A0iS6MnWrObujCaNW3xm4A5flQQtDZzL8g4i+jkBSjJRzmQIYLe4XeOI
	 RUmJQpT0M9fTgeeljmllel7eDY8pM6KuO/XcFJFzL5zVFi4WOYSVwvQGiOQDF7c/T/
	 hW5OO5/8X3QhqCBAEWv0asQDNh2tUciCe1pV/Gr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 224/333] nouveau/dpcd: return EBUSY for aux xfer if the device is asleep
Date: Tue, 17 Mar 2026 17:34:13 +0100
Message-ID: <20260317163007.670911114@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Dave Airlie <airlied@redhat.com>

commit 8f3c6f08ababad2e3bdd239728cf66a9949446b4 upstream.

If we have runtime suspended, and userspace wants to use /dev/drm_dp_*
then just tell it the device is busy instead of crashing in the GSP
code.

WARNING: CPU: 2 PID: 565741 at drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c:164 r535_gsp_msgq_wait+0x9a/0xb0 [nouveau]
CPU: 2 UID: 0 PID: 565741 Comm: fwupd Not tainted 6.18.10-200.fc43.x86_64 #1 PREEMPT(lazy)
Hardware name: LENOVO 20QTS0PQ00/20QTS0PQ00, BIOS N2OET65W (1.52 ) 08/05/2024
RIP: 0010:r535_gsp_msgq_wait+0x9a/0xb0 [nouveau]

This is a simple fix to get backported. We should probably engineer a
proper power domain solution to wake up devices and keep them awake
while fw updates are happening.

Cc: stable@vger.kernel.org
Fixes: 8894f4919bc4 ("drm/nouveau: register a drm_dp_aux channel for each dp connector")
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260224031750.791621-1-airlied@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1230,6 +1230,9 @@ nouveau_connector_aux_xfer(struct drm_dp
 	u8 size = msg->size;
 	int ret;
 
+	if (pm_runtime_suspended(nv_connector->base.dev->dev))
+		return -EBUSY;
+
 	nv_encoder = find_encoder(&nv_connector->base, DCB_OUTPUT_DP);
 	if (!nv_encoder)
 		return -ENODEV;


