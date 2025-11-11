Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C95D1D6DB5;
	Tue, 11 Nov 2025 00:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822341; cv=none; b=NO/hlbzWH4D+2T1gc6gRvG2mgpt7JwNWD6omdXHBOPHy/PilOcGDjOfZ2N367jTR5hJD8gnNFJ78eH9l10OaGaB3QhtqLjYBpqlFyttYUQ0VN7y29A7zaZqqGx5gmdcLrlpjw0Kf3XsgxMqA8Am7K2wloGQ7AZk4TVrFyLV132o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822341; c=relaxed/simple;
	bh=RRj0TMCskm6QXOJZDTBLdRZlixorOleDy3pPV0RGN18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUSEjoqwcGaTxPYXFJ7i7Vr80BmAVwkomZLftodRt5CTg1Ga7bfDvXM4I4dtuKJq2On5O4jluqazRdjjbuHyfHFkEBWaF2nc9WHhsCY2dFu7NXYF/00+6+rEmtD7cDVaxSAaYuqjotiofGPr3X2nucZxapM0vt2+ivVMQktPbnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBQBmaUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBQBmaUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FC0C19425;
	Tue, 11 Nov 2025 00:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822341;
	bh=RRj0TMCskm6QXOJZDTBLdRZlixorOleDy3pPV0RGN18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBQBmaUHH/fePqKbRS5CAp36HWdBMPFUM47oxvMIirLn7iitCm9zK84mH0/yd2l+O
	 bXXQ1Ui/fgthRmHhgL5Qch+NEYkbygEyfcy6l3xGNPc1ClnYStXgf5OrnjCSYFoLQK
	 CnvohYgIsuVXvrEmSkxVpNmX4sRlR0szE/wnkHAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 079/849] drm/radeon: Do not kfree() devres managed rdev
Date: Tue, 11 Nov 2025 09:34:09 +0900
Message-ID: <20251111004538.329376573@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 3328443363a0895fd9c096edfe8ecd372ca9145e ]

Since the allocation of the drivers main structure was changed to
devm_drm_dev_alloc() rdev is managed by devres and we shouldn't be calling
kfree() on it.

This fixes things exploding if the driver probe fails and devres cleans up
the rdev after we already free'd it.

Fixes: a9ed2f052c5c ("drm/radeon: change drm_dev_alloc to devm_drm_dev_alloc")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 16c0681617b8a045773d4d87b6140002fa75b03b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 645e33bf7947e..ba1446acd7032 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -84,7 +84,6 @@ void radeon_driver_unload_kms(struct drm_device *dev)
 	rdev->agp = NULL;
 
 done_free:
-	kfree(rdev);
 	dev->dev_private = NULL;
 }
 
-- 
2.51.0



