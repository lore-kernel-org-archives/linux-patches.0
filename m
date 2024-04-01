Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0222C1CA8F;
	Mon,  1 Apr 2024 16:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987667; cv=none; b=OFlNGZCxQLhueL8eN7MZ6BTCsRsdof2RI/52w5b/1+nBwSDS21aHaSamX1kIgoAO7EZveDluOgjoUTxTOtbGVddHpEMyRCdPUK3bOliFtNiqfdWB0YVsZ1DxaXH5MDM6VVdrE2BGQx93i6TIG/NC+G3WFbC17NGTORE8/Ng2tqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987667; c=relaxed/simple;
	bh=LCaqcehe6zgMzU8M6AD2QIJglMxICDyh4foxauu2SC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/xk8Ko5cY53Dm5hBeXpYBepBc3EeKG+43hhqoGX1YB+pRtNVNbJpqER2HjYTyMrmag+0IYjluJPFg/e+U9L2g/RqDlV2qxkt6x96n6M/+x4TuU4PkaVu7NFbS3QFMtzOSBMFnOLhlWmvnlQgXjqymVOHsVkab8VC6FONFQB/5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pw1nVzyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pw1nVzyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630C6C433F1;
	Mon,  1 Apr 2024 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987666;
	bh=LCaqcehe6zgMzU8M6AD2QIJglMxICDyh4foxauu2SC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pw1nVzyZ1pTJ2iowIT0ZD4PGRL8r9isSJzd5jvfwH2tr/+BGS8AL6hClTfYP0Y+PM
	 nBHBBcmooDUz5ITixYsm/IbRiA5CcWWAYN1+7cNknvW/n2KNAeFcH10HYIYgB8+CFS
	 MeRKw7bzYHUWTv23Pn7App7AQBNWZf8jXHmVzlhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 326/399] drm/amdkfd: fix TLB flush after unmap for GFX9.4.2
Date: Mon,  1 Apr 2024 17:44:52 +0200
Message-ID: <20240401152558.910920090@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Huang <jinhuieric.huang@amd.com>

commit 1210e2f1033dc56b666c9f6dfb761a2d3f9f5d6c upstream.

TLB flush after unmap accidentially was removed on
gfx9.4.2. It is to add it back.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1473,7 +1473,7 @@ static inline void kfd_flush_tlb(struct
 
 static inline bool kfd_flush_tlb_after_unmap(struct kfd_dev *dev)
 {
-	return KFD_GC_VERSION(dev) > IP_VERSION(9, 4, 2) ||
+	return KFD_GC_VERSION(dev) >= IP_VERSION(9, 4, 2) ||
 	       (KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 1) && dev->sdma_fw_version >= 18) ||
 	       KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 0);
 }


