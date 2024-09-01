Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE93208A7;
	Sun,  1 Sep 2024 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209886; cv=none; b=uxulDw8xK99NjTBl9kH+CKUlugAqcraP0CK5asE9Fcx+mDD7ryyoV4ODZhBKY8SwYq74vNncVoPd0kNhqP5HamUTvzu0mj8ZXy7a0OWVzA+rJKNaVJGU9dH4cjtScZT7nrElzy/zsDJmZfTifqUfbqX40RVBoZEhUSK+EnYD/dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209886; c=relaxed/simple;
	bh=QUthQExYXC4IrjYr3atM94zh31DDwOXTYsTD9LCs7T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBMmDtZ4EKR6qqC1XwwnBY8QDzE5VB50enOjQ6Eok7vWfL7qenAmCBr0/XAtKRb9rnDQhwcsApZEiKmbIqew691DWvHwMNujyMjqL/WduEwdDK/kDS6jbECgFrghMJVb920r+42L7yPwODIeOh5SvhUyysgv+ykVLbWUQHr+KeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMZKdCEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMZKdCEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136A2C4CEC3;
	Sun,  1 Sep 2024 16:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209886;
	bh=QUthQExYXC4IrjYr3atM94zh31DDwOXTYsTD9LCs7T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wMZKdCEzwv3g1FWU1c60sz3W1FaW0KfNjBKMfwoe3BZL4P6+4mOhRiCHLmTWLkiLy
	 ZApt0NbRN2QUv1fkHwZ52lrpzhJRzoUmwxEouZeogxYnGuvXZ09jW3SoGxiON4Wd2Q
	 tNDDoelirw/APswKzbFhn6ZUxO24aoYLOXrtsrB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 023/215] drm/amdgpu/jpeg2: properly set atomics vmid field
Date: Sun,  1 Sep 2024 18:15:35 +0200
Message-ID: <20240901160824.138227596@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e414a304f2c5368a84f03ad34d29b89f965a33c9 upstream.

This needs to be set as well if the IB uses atomics.

Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 35c628774e50b3784c59e8ca7973f03bcb067132)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -557,11 +557,11 @@ void jpeg_v2_0_dec_ring_emit_ib(struct a
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JPEG_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring,	PACKETJ(mmUVD_LMI_JRBC_IB_64BIT_BAR_LOW_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));


