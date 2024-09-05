Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2B0194A45;
	Thu,  5 Sep 2024 09:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529892; cv=none; b=nBTDPUfAJpTiTJx0UWSxwOYjfgdptusxLjb3YDmKldpFDsqv19t/ELXvV+7OPvNCsYkGTp45eV8bstw8etzj2uszBJh8k2kg9JZD4RfRpernpsm+qBjsZhCOeX+NvZ739Hvy+bQPOa3djJVe8IBvnt7JbAWSE8O+b9WeZE/rnb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529892; c=relaxed/simple;
	bh=pRUJu7dErdJ3NMFq2wnMek5Ipxfph1U6RBY/1HuLhZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X04tFU/jcJLRr9wY4l9sPZgWUhM2qutSF4HxbEvhUdXGSzqp5ZQ8HNf82t/W1ZYVvdE+Xwt+0+9aUUKeJJ6PFQGGcGreooP6UOTDJhzZjGSnufcKYIvzvmz6diu81vyn3B/fnpVv5NjuqCu1tDii0out2w6AOndkURSJR5dQZlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuS/Gqr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuS/Gqr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9777FC4CEC3;
	Thu,  5 Sep 2024 09:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529892;
	bh=pRUJu7dErdJ3NMFq2wnMek5Ipxfph1U6RBY/1HuLhZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuS/Gqr2UG/qD8jx/mDVgoA4VEViCvFTb52v+4U5Lf3HqRTjfCt9wTsX6y654W9uM
	 8qbqpv6S0EAb7AMM70B99XWhR7oxqA1zGjiUyPkskNQDiNLCEaHwedm7CZqcSXg+BZ
	 kNAx2iDJmkcHOTvr5TqGbegNfvtqxPQTgT4/R/Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 175/184] drm/amdkfd: use mode1 reset for RAS poison consumption
Date: Thu,  5 Sep 2024 11:41:28 +0200
Message-ID: <20240905093739.166975534@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit 4280f60e8e7caa5160135223e486545893bc9013 ]

Per firmware's requirement, replace mode2 with mode1.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
index e1c21d250611..78dde62fb04a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
@@ -164,7 +164,7 @@ static void event_interrupt_poison_consumption_v9(struct kfd_node *dev,
 	case SOC15_IH_CLIENTID_SE3SH:
 	case SOC15_IH_CLIENTID_UTCL2:
 		block = AMDGPU_RAS_BLOCK__GFX;
-		reset = AMDGPU_RAS_GPU_RESET_MODE2_RESET;
+		reset = AMDGPU_RAS_GPU_RESET_MODE1_RESET;
 		break;
 	case SOC15_IH_CLIENTID_VMC:
 	case SOC15_IH_CLIENTID_VMC1:
@@ -177,7 +177,7 @@ static void event_interrupt_poison_consumption_v9(struct kfd_node *dev,
 	case SOC15_IH_CLIENTID_SDMA3:
 	case SOC15_IH_CLIENTID_SDMA4:
 		block = AMDGPU_RAS_BLOCK__SDMA;
-		reset = AMDGPU_RAS_GPU_RESET_MODE2_RESET;
+		reset = AMDGPU_RAS_GPU_RESET_MODE1_RESET;
 		break;
 	default:
 		dev_warn(dev->adev->dev,
-- 
2.43.0



