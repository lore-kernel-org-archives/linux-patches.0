Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704842;
	b=RqablZ8Rp6uN8mEUgtsOHt+XX9z6NnRTE/MQuiqX5ICt+XWR8ES6cbfnYs2N2CRs/hci
	 LNO69ks4GxQd6X+GzSN8xFgSBJdA4BqP6uI78SPgb8bUAvMKMji5qlH+k+cRx/OnjxQ5d
	 gXNf2cKeByBrZ9a0RRAsuXMWJzr4+cMU/vplWjY3m22/VV1P9B/6SLHREml/gM6rQfguJ
	 yb+or3mFFhPIPGNX2HpCBaDFicG6ck3R2ZjXjjjCA31FjnrsqZOKnF+AMh1mhCkdG0GRg
	 NJuiiapiRa/OvhetCvcsSJpdl8zroiqGK9dpyV+bVpvcWO4W6QVzl8JQrtEfLtInX9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vHzE5PiLqzHyKl+OVRoYl+sJQiSiockqyVu5cFSBwPc=;
	b=h8/Eq+6AW5lZQTkW+vDX08/h43KFQQVY2IvzvgUdvYExdDsmrcGQxqvHDadNX/QqX9Tu
	 Fg1JVGXonaWdtja1E1N/1IQF+XIZEy2quD6Ndm4iv8nLZpwUTjxQYvsMkcxy35huohPSz
	 hIkIWXmGi6oz7U67TUt3Fypgdwen8CQPpLz4DkdL+QEVaGt/Xv4NdfpeVegxFp6OSnC2Z
	 Yeeau8MwDnFUOoyGic7Zd7BEaorJGTAEGrll9KAu0cgLdbbaUmIQLeQXVIpjXTlBVbp4b
	 X7d6bNW4KYhnpv2RsnXZPos6iGJN8fRYTrvTiv+v1VEurgYGLqCqbFQ70ft7X+WM1bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E4z/UTzx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006BC606A31C;
	Thu, 26 Nov 2026 14:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4z/UTzx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954941F000C4;
	Thu, 26 Nov 2026 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704841;
	bh=vHzE5PiLqzHyKl+OVRoYl+sJQiSiockqyVu5cFSBwPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4z/UTzxh9i9APeA3N3psBQn9lm8N5Z3QZVMmY/27KCDMPRJ8pswDWG+OfAoYnApp
	 TZK0Ckx2abEh0ZrwluTcpSHHozrI0rWLavoQyEWmug+ITrs13sX/9EJW1fjOQXrdRq
	 t7f3aMHX/DC3xXX0y1tZyDWnRm9jbxuoMo9jopSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Pranjal Shrivastava <praan@google.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>
Subject: [PATCH 5.10 260/265] vfio/platform: prevent read-only region mappings from becoming writable
Date: Thu, 26 Nov 2026 15:39:50 +0100
Message-ID: <20261126143623.415909711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

commit 420bed9131dbbe37abe9d6b32af51219875811e0 upstream.

vfio_platform_mmap() rejects writable mappings of regions without the
WRITE flag, but leaves VM_MAYWRITE set.  Userspace can map such a region
read-only and then upgrade the mapping to writable with mprotect().

Clear VM_MAYWRITE for regions without the WRITE flag, as i915 does for
its read-only objects and as fixed in drm/vc4 (CVE-2026-68445),
drm/panthor (CVE-2024-53071) and commit a5edadbae57e ("ptp: vmclock:
prevent read-only mappings from becoming writable").

Note this is defensive hardening: no in-tree platform driver currently
publishes a region without the WRITE flag.  The guard costs nothing and
keeps the mmap() interface honest if a read-only region ever appears.

Fixes: fad4d5b1f042 ("vfio/platform: support MMAP of MMIO regions")
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Link: https://lore.kernel.org/r/20260929094848.7439-2-suruurism@gmail.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/platform/vfio_platform_common.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -617,9 +617,13 @@ static int vfio_platform_mmap(void *devi
 			&& (vma->vm_flags & VM_READ))
 		return -EINVAL;
 
-	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)
-			&& (vma->vm_flags & VM_WRITE))
-		return -EINVAL;
+	/* Prevent read-only region mappings from being upgraded with mprotect() */
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)) {
+		if (vma->vm_flags & VM_WRITE)
+			return -EINVAL;
+
+		vma->vm_flags &= ~VM_MAYWRITE;
+	}
 
 	vma->vm_private_data = vdev;
 


