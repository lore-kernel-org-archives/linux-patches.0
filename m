Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C83D37F31A;
	Thu, 20 Aug 2026 15:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238746; cv=none; b=B6YlD/SaYQkV00/Dl0umhtvUouQpqSpJW305trlIEU6Zj/T8iym3DpyJIIorhKNg8mUYnpc2LEc3EavcW8Yl3DmA1q0oMOI6Zvz//5jcxfMsGaCLFTdgt/tHdhOcBd3csd785nDHTAWEIXJJDS91b5YE0QT3AXjZI8pQNEnGfks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238746; c=relaxed/simple;
	bh=KnPmlBi/Wsvi6hPHYKjNrzE2XW8nwwYKmNNU4s8bGlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZqTE1XT6AtFGMZKFnp8HF9LO4dJlgBBMSrU5yNkishtbEpTkuRukqiwqbk+n/Y2vF81jZGFQRiNRqYSqntZZY7E2rTgrQORDaF+ZrMTfK99Xapq/42tXv2WwHyq1hI6gEELME6w4NB4Mi0ZSpaq96uvG06QD7mJENBBgT0wLOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UidR5RrX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UidR5RrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BBC1F000E9;
	Thu, 20 Aug 2026 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238745;
	bh=29GMfVaH0U9h7NG+gQBQrORi/raNozTnIvXFWKg4hVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UidR5RrXPNndRdEIeR2kCJdskFd+a7mpnz9QOU0ViGel+4NJ8F17/ULpVmaqKamW/
	 UiJuBPiJzqafZWa4XxFwq76A0DTmB7hqm+31T0ZopeYHxBMpo35a0cSp0bw3OyXDFj
	 z5sctsO6oMAlqoui7NC8HMEqARZ6RYxvOV1MFjc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 026/217] drm/amdgpu: reject oversized IBs with per-ring packet limits
Date: Thu, 20 Aug 2026 16:53:14 +0200
Message-ID: <20260820145238.405862293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
 #include "amdgpu_gem.h"
 #include "amdgpu_ras.h"
 
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
@@ -358,7 +378,6 @@ static int amdgpu_cs_p2_ib(struct amdgpu
 
 	job = p->jobs[r];
 	ring = amdgpu_job_ring(job);
-	ib = &job->ibs[job->num_ibs++];
 
 	/* submissions to kernel queues are disabled */
 	if (ring->no_user_submission)
@@ -387,6 +406,12 @@ static int amdgpu_cs_p2_ib(struct amdgpu
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
 


