Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3602E17FD;
	Thu, 13 Jun 2024 12:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282646; cv=none; b=sTfRz//wLQYK/AmEZ1EaHVfM+Rv/gm8T7vEMkd1YCXlY+Xp7inS7aM3v1ChSCKluuAnEtO7hnCXGR+8gDNkl+Stklzs16EqQTE1Sq1qu2lAXDJtnSWQJaSvPs/b3IXyyw9VPeC7K7qoA7oRFwL4l9aSgL88F8/maVZJc6xnjN2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282646; c=relaxed/simple;
	bh=+SyDDuJ6k7ILB9fKv4idXOw7i3ZOQ0XmUX7/CoiSB+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu5y2xfBhrkNlSPs5MP6n4j3Dxonx7WEtytR0B52q5gjmwTg0nY140n+ItW+FEIXG1xpWdbS7oOcqiJWuP5nIa/MTW9m9ryvWM7K7J+b3mx7YzDnmHdeWbNAW/g+uBTrf8gYPypL1/IXfafHc0hbhfIdeb/kEkMpCyLVQsLBEEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9J6Lkjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9J6Lkjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D76C2BBFC;
	Thu, 13 Jun 2024 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282646;
	bh=+SyDDuJ6k7ILB9fKv4idXOw7i3ZOQ0XmUX7/CoiSB+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9J6LkjlYz7Xku6Qym8Ze4wIjU8rvAatECkgtagIk+zBA8TngTRjWx2xTnVJ3ViWu
	 G9e8hI2k8T/A4i2jVB1UnY1D+S8zDokdqZKDws9Ptr17YU/GBec77PJM6EHBtLrYXL
	 n90lLbo6yL1zRczndnNRtBCaEZyLbtJJZwlu1ouo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Kauler <bkauler@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>
Subject: [PATCH 5.15 346/402] Revert "drm/amdgpu: init iommu after amdkfd device init"
Date: Thu, 13 Jun 2024 13:35:03 +0200
Message-ID: <20240613113315.629595843@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

This reverts commit 56b522f4668167096a50c39446d6263c96219f5f.

A user reported that this commit breaks the integrated gpu of his
notebook, causing a black screen. He was able to bisect the problematic
commit and verified that by reverting it the notebook works again.
He also confirmed that kernel 6.8.1 also works on his device, so the
upstream commit itself seems to be ok.

An amdgpu developer (Alex Deucher) confirmed that this patch should
have never been ported to 5.15 in the first place, so revert this
commit from the 5.15 stable series.

Reported-by: Barry Kauler <bkauler@gmail.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20240523173031.4212-1-W_Armin@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2487,6 +2487,10 @@ static int amdgpu_device_ip_init(struct
 	if (r)
 		goto init_failed;
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		goto init_failed;
+
 	r = amdgpu_device_ip_hw_init_phase1(adev);
 	if (r)
 		goto init_failed;
@@ -2525,10 +2529,6 @@ static int amdgpu_device_ip_init(struct
 	if (!adev->gmc.xgmi.pending_reset)
 		amdgpu_amdkfd_device_init(adev);
 
-	r = amdgpu_amdkfd_resume_iommu(adev);
-	if (r)
-		goto init_failed;
-
 	amdgpu_fru_get_product_info(adev);
 
 init_failed:


