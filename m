Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9903442FBC;
	Thu, 30 Jul 2026 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424964; cv=none; b=hK06ZXziX2YRjW6NhBZYfQ2OpwaOZ7nN+bIAf8OSwyo27zDCTl1OYOWoeXdOCtxDA4MqLbaajeAHbEAYxMsBOTZBCLij+h4C29W2ZV7DKdponcBNfDyH2VZP7vvS5aaOOqdJU3CYIyXyYsBiUXOooDZ5mUWWkoDEJMfQPp02TQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424964; c=relaxed/simple;
	bh=c8LyCWLpf2x1APztHsrDwUkOFIGrz90WCjePb36MMSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4jfN91UcPEFK5nbEwyXydRYy73hbOGoylmmEQd6QvzBMleUG6BmX8pcGnQ3oaSSVM3bFGWCe6T/5G3J1X8x4SwDNFKuvc4RLsq6ZONdKhtXb5J9mdmIKS/EHUodVs0vjGkrNT1Oy9FW/zLytoFkeCyq32GuyN5tah4mv3Fl5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlFsETcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlFsETcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506171F000E9;
	Thu, 30 Jul 2026 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424962;
	bh=WIiKk5Z7k3T9Kxb9yggyFPQijNK7nhtsbW6ZkUChTVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlFsETcVtL9TgW0QRZZB9S4S1pjFD6YJXqizA46eG+++EWDXwtByO/LQqnpmX9oO0
	 Ln6hEQbYg9TG8cvcKZAMhz2CRV7NBO26L0xb43Yu9+PdCtdvWIHjaDINiYQvq32iop
	 4gycWW77gEHLhtP0JUWbJ102IZJUYJRxXLbUvEAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 578/675] drm/amdgpu/jpeg: fix jpeg_v4_0_3_is_idle detection
Date: Thu, 30 Jul 2026 16:15:08 +0200
Message-ID: <20260730141457.413949217@linuxfoundation.org>
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

commit c44af3810fc8b3adf6910a332038aa566560c8fa upstream.

jpeg_v4_0_3_is_idle() initializes ret to false and then accumulates ring
idle status using &=. Since false & condition always remains false, the
function can never report the JPEG block as idle.

Initialize ret to true so the function returns true only when all JPEG
rings report RB_JOB_DONE.

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e9df8e9d04e0593d17ddb069f3b7958991cd18c9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -1010,7 +1010,7 @@ void jpeg_v4_0_3_dec_ring_nop(struct amd
 static bool jpeg_v4_0_3_is_idle(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
-	bool ret = false;
+	bool ret = true;
 	int i, j;
 
 	for (i = 0; i < adev->jpeg.num_jpeg_inst; ++i) {


