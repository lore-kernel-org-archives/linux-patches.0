Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9966F37E5CB;
	Thu, 20 Aug 2026 15:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238085; cv=none; b=X6acfQim9OOdkJWY/LZCxFPiXvMBecbfADtJrjflWFQQDrPtRyrGF9mes+49+iaNj1ZTHijlLqNbdh/mDQ6lz4q9ASeFQ5YC95bh2Gmd/VN3jzxOTorD8Ry2s6xThJmD78X4q+wfdUu8YxdcU7edftiLPG0GcWGvT28DZm3AqJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238085; c=relaxed/simple;
	bh=osHhAL65XcdD4go/8dbsecod6WXPAeR+iRh6JqaCFiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nISATSS2HUeKwh4tk3D9PISWqU6MoDMTPploZish4P7g/HnfuJEOyOJikliE473XbGPLR4J+yuNhyvQasZQ2h9O6anLQHpdM7JjbPBCLFOlyAkadxk2lmtKz2XxnBAomoMK78PItBJwRsDEGjbjA3Shc+fTe3DZAQv/JLkcdrRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysISTaPN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysISTaPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0031C1F000E9;
	Thu, 20 Aug 2026 15:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238082;
	bh=sbAcO+Zf25gazc9HpCs4+6G4xX+UZ5Vw9nO09Wku8bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysISTaPN1GKSjHaEbSyUbANuzXMrYkp2c4e2Q57w6AB3S8EVk4OC6VM1GajKO0YRW
	 aG9xfZ5UlYOasIeRQKpVTBUIbf/g6TYMHg9p9avxs85uC72FLdPGpaCCRjkdv+Ha3S
	 8KHDRBBN2ON0+3u8+dZud9PFDra5rql5WLaaJSaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 027/228] drm/amdgpu: reject oversized IBs with per-ring packet limits
Date: Thu, 20 Aug 2026 16:52:49 +0200
Message-ID: <20260820145245.281948203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Candice Li <candice.li@amd.com>

commit fd37f9dd5b5ab70a46fa7bc76623c0528d602b27 upstream.

On GFX rings, amdgpu_cs_p2_ib() passed user-supplied ib_bytes through
to ib->length_dw without a limit, while ring_emit_ib() encodes length
into packet fields. Oversized values can corrupt adjacent control bits
and destabilize command submission.

Add a per-ring IB packet size limit helper and reject command
submissions exceeding the corresponding dword limit before IB
allocation. Use the documented 20-bit limit for GFX/compute/SDMA/VPE,
and apply the MM fallback limit for other ring types.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7f48fa2cf62e3fa6c9c3870aa74988f773247e52)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -42,6 +42,26 @@
 #include "amdgpu_ras.h"
 #include "amdgpu_hmm.h"
 
+/*
+ * Maximum IB length (dwords) for rings whose emit_ib packet format
+ * documents a 20-bit size field.
+ */
+#define AMDGPU_GFX_SDMA_IB_PACKET_SIZE_MAX_DW	0xFFFFF
+#define AMDGPU_MM_IB_PACKET_SIZE_MAX_DW	0x7FFFF0
+
+static u32 amdgpu_cs_ib_packet_size_max_dw(enum amdgpu_ring_type type)
+{
+	switch (type) {
+	case AMDGPU_RING_TYPE_GFX:
+	case AMDGPU_RING_TYPE_COMPUTE:
+	case AMDGPU_RING_TYPE_SDMA:
+	case AMDGPU_RING_TYPE_VPE:
+		return AMDGPU_GFX_SDMA_IB_PACKET_SIZE_MAX_DW;
+	default:
+		return AMDGPU_MM_IB_PACKET_SIZE_MAX_DW;
+	}
+}
+
 static int amdgpu_cs_parser_init(struct amdgpu_cs_parser *p,
 				 struct amdgpu_device *adev,
 				 struct drm_file *filp,
@@ -350,7 +370,6 @@ static int amdgpu_cs_p2_ib(struct amdgpu
 
 	job = p->jobs[r];
 	ring = amdgpu_job_ring(job);
-	ib = &job->ibs[job->num_ibs++];
 
 	/* submissions to kernel queues are disabled */
 	if (ring->no_user_submission)
@@ -379,6 +398,12 @@ static int amdgpu_cs_p2_ib(struct amdgpu
 			return -EINVAL;
 	}
 
+	if (chunk_ib->ib_bytes / 4 >
+	    amdgpu_cs_ib_packet_size_max_dw(ring->funcs->type))
+		return -EINVAL;
+
+	ib = &job->ibs[job->num_ibs++];
+
 	if (chunk_ib->flags & AMDGPU_IB_FLAG_PREAMBLE)
 		job->preamble_status |= AMDGPU_PREAMBLE_IB_PRESENT;
 


