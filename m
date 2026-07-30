Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C7C37883C;
	Thu, 30 Jul 2026 14:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423206; cv=none; b=PC+w73NFUjKZFlO3r9TOHIi88XjJkTStGVMBPNBZ4nTUCIiOMsmNom29ZAlTI/GjmVCmieZ1tbXS3wABM6qGWjGDNlnowlEV17j5Hd2LzI1/mN3osCEHNf8ZbsDAfgJbIYvBu89+0sjgDubfsYIrl258jPqG+6WekmEm0jEaMTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423206; c=relaxed/simple;
	bh=OElYQGCUobQiei0LDt7XDS65HB/VJG/5LwPmdPCJ64Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sor9KDtFyYMPTfF6jXGy2mC4lF2ff2Hci5e3i4wvVNUCXmCsjV3rmqetACRBn+PRZbADr8rXJFbsEfBrJ0VnTgsrAHRRPJDEverWIf87I/jmtj4mhodLyoNBxtnZyDRifxxZlN/14rxIKoZxRM98J07wJbkekZGq46FgqGUcPDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k38Yo6th; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k38Yo6th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E0D1F000E9;
	Thu, 30 Jul 2026 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423205;
	bh=ND/20u0/TmbKajPmcG5/vAzkN9mcBiXmbS7G9Qwy/I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k38Yo6thderOxNFwCDpYIXhbGOICiY68GCGc0t6PEsp+gphoeAUilmNPquDPkFgHO
	 IvbkZCPNGI5BOLP+mAE9iVK1J0pj/H46YGjDx93ez0YCCILtSUg9S0MCtwzsCwp2mM
	 +LCS5NeAUvKD20PEmw4XeGAHpLjxClgoqGqqgj6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 704/744] drm/amdgpu/jpeg: fix jpeg_v5_0_1_is_idle detection
Date: Thu, 30 Jul 2026 16:16:17 +0200
Message-ID: <20260730141459.239240357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Boyuan Zhang <boyuan.zhang@amd.com>

commit efcedeececcf995fcf717b21e39aa7c446fa3bf7 upstream.

jpeg_v5_0_1_is_idle() initializes ret to false and then accumulates ring
idle status using &=. Since false & condition always remains false, the
function can never report the JPEG block as idle.

Initialize ret to true so the function returns true only when all JPEG
rings report RB_JOB_DONE.

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Reviewed-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 680adf5faeeabb4585f7aeb53681719e2d6c2f41)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -657,7 +657,7 @@ static void jpeg_v5_0_1_dec_ring_set_wpt
 static bool jpeg_v5_0_1_is_idle(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
-	bool ret = false;
+	bool ret = true;
 	int i, j;
 
 	for (i = 0; i < adev->jpeg.num_jpeg_inst; ++i) {


