Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCA042F707;
	Thu, 30 Jul 2026 15:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424969; cv=none; b=evsilNZS3KgnN21IHhK3e6ltKCVGutWwUPJ4hz8Cb2dntCRynekswWeZnAneSMMAgx2wsHrddfX1R0AtaqigT3QSFK5MpJmDvHWrCFIWOkdafkNJrqd+Zd0+GLXkBkg1L+hqS2J7WR26cbAfYli7tKLP3dY4bP6q2OcQm/8qbZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424969; c=relaxed/simple;
	bh=ipDja2onpl+3QMQdRSx5iLnblxxooZ6Fi3jHnD/URzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4XEGvtXRuTwSmPkWZ3WJavGY3cKen3Q/isVMFwW26zjCU5xrULWh3cuOnWErdXLhmi5pqIKiULeCGdQwyDwgKxAd1lsTiutsUOK++1wtVmFI9naAf/528a7jgs+P4gJgEJNSdU3HwEvvoCiJpQfcZS9LGg+sAc7aDDHH+hNGts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMcePlCN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMcePlCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5401F000E9;
	Thu, 30 Jul 2026 15:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424968;
	bh=yt7r8ZHcSXmvSdjQ2EklVfby0+aXmgdP7al4Qwix3qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMcePlCN35FeBFDZFPKUptT80o4dTFd6/NvFgWXK2Xxtl9e29n84AcMlmlRJy5Fvl
	 fL4edj+FN2JplXH402qRcDJIRNDterOGUbnO2eI1KMcC9lE3kElBTEiA3V/G6nAyN9
	 owW7IufWxSlWAuv5Y7BIo4cc8pAuvZJA58gBubzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 579/675] drm/amdgpu/jpeg: fix jpeg_v5_0_1_is_idle detection
Date: Thu, 30 Jul 2026 16:15:09 +0200
Message-ID: <20260730141457.434225681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


