Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CE84C6E;
	Mon, 23 Jun 2025 13:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685636; cv=none; b=b90vjP/gJ5stlSEf9c1EcEq9/E+MBW9P08xIeXDeLh2/kNyLhEJNxCZz385WzrmL1Wephk/xHHb6l8N5DeZlmD6DN1dLRod61CiRLqK0Pf4RhmJEz903K6CGqnbKoVst06BCz36P2V1FL7WUllrUQxzjtIvrIMp7toA6kBlNWvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685636; c=relaxed/simple;
	bh=VoWXVAJ9FGaAT/N1hBIjFxTXVmxj9Ssk7U5r7jN42Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAa3FOhklNIuRM3kFh4I7TwiUePKtM0mG4+9F/EZjPlVjLjI2DxDSRq5HPaautKt6VkYWbDz6jcXjMjoBe7o7X6kR1xnapnIGnDsl0zZ8cUuWvnSBRMNekOCw7lYh/cb70xlEoQ1/ABEkdCrNZhdm8MY5arAqREsDPrKG466ajY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJ0pEzaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJ0pEzaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079EAC4CEEA;
	Mon, 23 Jun 2025 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685636;
	bh=VoWXVAJ9FGaAT/N1hBIjFxTXVmxj9Ssk7U5r7jN42Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJ0pEzaHgvlI9GnwiA3H05t/iOzeac8b7oWc04OLzL4khJe2rLCCS3dcnn/JLt/OI
	 cMNb71hB95if+EpBC70yd/dzq49lyQB+jySj0jve1+GH4a1mEwVjjTwqkK6V+Tyyto
	 414cn+iirU17nmBMxdEKoe35e1luuB/ctDpPH5uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 249/592] drm/panthor: Dont update MMU_INT_MASK in panthor_mmu_irq_handler()
Date: Mon, 23 Jun 2025 15:03:27 +0200
Message-ID: <20250623130706.217313052@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 6c4a3fa26799785c1873aacabcfd9b2d27e8dc97 ]

Interrupts are automatically unmasked in
panthor_mmu_irq_threaded_handler() when the handler returns. Unmasking
prematurely might generate spurious interrupts if the IRQ line is
shared.

Changes in v2:
- New patch

Changes in v3:
- Add R-bs

Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250404080933.2912674-6-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 7cca97d298ea1..cc838bfc82e00 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1714,7 +1714,6 @@ static void panthor_mmu_irq_handler(struct panthor_device *ptdev, u32 status)
 		 * re-enabled.
 		 */
 		ptdev->mmu->irq.mask = new_int_mask;
-		gpu_write(ptdev, MMU_INT_MASK, new_int_mask);
 
 		if (ptdev->mmu->as.slots[as].vm)
 			ptdev->mmu->as.slots[as].vm->unhandled_fault = true;
-- 
2.39.5



