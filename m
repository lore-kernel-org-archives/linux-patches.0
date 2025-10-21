Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABCF145A1F;
	Tue, 21 Oct 2025 20:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076882; cv=none; b=QF9lF7t4j76gD05et4v3lJ3UGvQIOe+9W0Ic1fDwW2fq0AQjfcF6S5r351KwABACfbmUThBfyZ1KTqm2Yp5nBfwSiUS2+ksokGDZtuHZrHNZH5KIlxizu5pky17iPA3yRcZfZDslgY2NNyi3aMQRFXwZrwCzSmNUXfq/afLOFiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076882; c=relaxed/simple;
	bh=F4CXBQlZannanc7D5G6j3BhgoqehzJhV6OLz1cf441A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj66hR2cfNQbCIyEGWhVIC0gEbeUagpd69bJsVgD5cdxxAuTIvNrE3OVNHsAHJDnrmqX5EhZRcqVacPYu8trq8AtZMvCZYiT0Ana9lCIVgbuniVLoT2WlDWk1WrM4+iTKmU3tklhfYy5kM7Xm21nBRMmGhuSZ9KncIs0TccYsOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZWLqLyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZWLqLyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7708C4CEF1;
	Tue, 21 Oct 2025 20:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076882;
	bh=F4CXBQlZannanc7D5G6j3BhgoqehzJhV6OLz1cf441A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZWLqLyvOfkBxgl+BCQPpGAYQriptyf1Eh62hOGhz/GeHFpBjD6VF17rUPQK9NlHN
	 aorb9lo2s/O5pKjCrvG6AoOe08+UWelv/JxhRl230VToIpfKYGDgqmc1V69jj4tfHl
	 0Uzw+FjDzPELpak9sIFP46ysFYUwlHBgT5fZURsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ketil Johnsen <ketil.johnsen@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/136] drm/panthor: Ensure MCU is disabled on suspend
Date: Tue, 21 Oct 2025 21:50:55 +0200
Message-ID: <20251021195037.586464770@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ketil Johnsen <ketil.johnsen@arm.com>

[ Upstream commit e07e10ae83bdf429f59c8c149173a8c4f29c481e ]

Currently the Panthor driver needs the GPU to be powered down
between suspend and resume. If this is not done, then the
MCU_CONTROL register will be preserved as AUTO, which again will
cause a premature FW boot on resume. The FW will go directly into
fatal state in this case.

This case needs to be handled as there is no guarantee that the
GPU will be powered down after the suspend callback on all platforms.

The fix is to call panthor_fw_stop() in "pre-reset" path to ensure
the MCU_CONTROL register is cleared (set DISABLE). This matches
well with the already existing call to panthor_fw_start() from the
"post-reset" path.

Signed-off-by: Ketil Johnsen <ketil.johnsen@arm.com>
Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20251008105112.4077015-1-ketil.johnsen@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panthor/panthor_fw.c b/drivers/gpu/drm/panthor/panthor_fw.c
index 4e2d3a02ea068..cdd6e1c08cebd 100644
--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -1057,6 +1057,7 @@ void panthor_fw_pre_reset(struct panthor_device *ptdev, bool on_hang)
 	}
 
 	panthor_job_irq_suspend(&ptdev->fw->irq);
+	panthor_fw_stop(ptdev);
 }
 
 /**
-- 
2.51.0



