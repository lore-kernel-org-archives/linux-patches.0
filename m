Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C8D36C9EB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302311; cv=none; b=H0zvQGDufgLO29Ao//+a0xxjX4qtQR3blSLsrdY70SSJwrc2f2T4Sl8bL6lRfubMY3WDmvnsUPynZDJPtYu9HjQgWeIlQfuba3Q4wEB6JTp207MB0fyY3rgzA48tP8RDVmbr7eZscgMlt9nuDQ6fpdpUsB/OcJlbxAGYJfUYrBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302311; c=relaxed/simple;
	bh=RD/GpCQ36bV2Ee+VnF53WUW8n94fM7DX5JEwJhm1X3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTAlmCMzoPplHcyo0abUFEenpOFEyp2Oj7XYqzbsjx+EusF1Jy5/K2hLtOcqulI8WHfd3Uxf+eZbYVpGoZEyQi6Pztu9CGbwtNZdnLWGNxMNF3Zuuc3y/7cNGufLqhMZylaBUBiIIeO2bV9BN8Jmwci8qQSMuXbr4tIRjCUGb8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGpPlM2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGpPlM2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D35C116D0;
	Sat, 28 Feb 2026 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302311;
	bh=RD/GpCQ36bV2Ee+VnF53WUW8n94fM7DX5JEwJhm1X3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGpPlM2hNKg2f4I7iHn0wzQbLgpGqGT8N+UOLzc/b9z8Sg0Kn8xr1JPeHnbo46wQ5
	 U4qE4vBW9pDP8mfpK0aG937Ns3K48u3QeRUvzdmntz8EfkCxRf/Kinqq/WL6vdiE6f
	 /XWTg9fw/gSf5SxDp6tE8ZIsgyhjw01rJwCc3nEQWA/cZ3rEkc2THOxZwBPExkP6Gb
	 esyHNNUgPJnHVH9xa+yqJealLMBQc8IUv+tce4vOiPjT9YgSKnJPP6C8E4DPr3U3Uw
	 tztbFgmOQoXt4E1nDwTSeYrEaQVmFf/nic6uO/dXzw0adQCHFkRMmXGEVzAcALUBoR
	 5uSMzYaNjhcVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Salah Triki <salah.triki@gmail.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/232] s390/cio: Fix device lifecycle handling in css_alloc_subchannel()
Date: Sat, 28 Feb 2026 13:08:00 -0500
Message-ID: <20260228181127.1592657-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit f65c75b0b9b5a390bc3beadcde0a6fbc3ad118f7 ]

`css_alloc_subchannel()` calls `device_initialize()` before setting up
the DMA masks. If `dma_set_coherent_mask()` or `dma_set_mask()` fails,
the error path frees the subchannel structure directly, bypassing
the device model reference counting.

Once `device_initialize()` has been called, the embedded struct device
must be released via `put_device()`, allowing the release callback to
free the container structure.

Fix the error path by dropping the initial device reference with
`put_device()` instead of calling `kfree()` directly.

This ensures correct device lifetime handling and avoids potential
use-after-free or double-free issues.

Fixes: e5dcf0025d7af ("s390/css: move subchannel lock allocation")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 98a14c1f3d672..85c1734ebfe88 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -247,7 +247,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 err_lock:
 	kfree(sch->lock);
 err:
-	kfree(sch);
+	put_device(&sch->dev);
 	return ERR_PTR(ret);
 }
 
-- 
2.51.0

