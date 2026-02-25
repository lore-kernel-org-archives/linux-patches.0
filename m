Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8FD242D9B;
	Wed, 25 Feb 2026 01:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983061; cv=none; b=GIRpm2EWTI89IkHEoMD9IwQ7wbUNuf3xF9TgHDHeg4BhzBCLKTmG1Ee0Uc7sxB4GfR2W4eb5wP61wmkGChwVI151Of8x3d89JV/YuEKDbfYLKyWvy5ZqhRQNT5mSwgsTfA6+5B+uWowkcLC083S5lbQZ/iPt5i0U+pYESHyMpkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983061; c=relaxed/simple;
	bh=HACOBU0PkeCXYIEwN0xeDGuZBQV3QuswPVk2JTSazQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEc/6gFWOPTKKmiad2jZM82kYHphNtt7s4gCMyxdrV84yqqdwoGiUc0hgVS//bIR26r+IaqwqjCXufX2mkUUmD6Rr2rVDkaA1+RusXjZNTOjpfMOEDUtlWMP9MeUUghy53tLVt0/Xpzc5SrwZo8HYXNCoHGYmmsjYh3Ugh4klHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CovG9P0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CovG9P0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6885C116D0;
	Wed, 25 Feb 2026 01:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983060;
	bh=HACOBU0PkeCXYIEwN0xeDGuZBQV3QuswPVk2JTSazQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CovG9P0yyU/Lrxrxr66j7B2RlHuJkvIt/eSQ0+IXunX4iEYsa9EgD9eKZ3Q1fLgu+
	 Spn+wKhkxFb8MvGBw3+pghV+eITyvaJXrM+mQFszpFdZu98FH5lkSxZ8v8+FHbSFAa
	 PGEoyHiClS5V9c/aHi+Umv7IInwyQ+b0P9O1O77I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Karunika Choo <karunika.choo@arm.com>,
	Liviu Dudau <liviu@dudau.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 225/781] drm/panthor: Fix NULL pointer dereference on panthor_fw_unplug
Date: Tue, 24 Feb 2026 17:15:34 -0800
Message-ID: <20260225012405.231027428@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karunika Choo <karunika.choo@arm.com>

[ Upstream commit 920c6af98e98e6afedf6318a75bac95af8415c6c ]

This patch removes the MCU halt and wait for halt procedures during
panthor_fw_unplug() as the MCU can be in a variety of states or the FW
may not even be loaded/initialized at all, the latter of which can lead
to a NULL pointer dereference.

It should be safe on unplug to just disable the MCU without waiting for
it to halt as it may not be able to.

Fixes: 514072549865 ("drm/panthor: Support GLB_REQ.STATE field for Mali-G1 GPUs")
Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Karunika Choo <karunika.choo@arm.com>
Reviewed-by: Liviu Dudau <liviu@dudau.co.uk>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20251215203312.1084182-1-karunika.choo@arm.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_fw.c b/drivers/gpu/drm/panthor/panthor_fw.c
index 94a3cd6dfa6de..9533b1a31820e 100644
--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -1260,10 +1260,6 @@ void panthor_fw_unplug(struct panthor_device *ptdev)
 		if (ptdev->fw->irq.irq)
 			panthor_job_irq_suspend(&ptdev->fw->irq);
 
-		panthor_fw_halt_mcu(ptdev);
-		if (!panthor_fw_wait_mcu_halted(ptdev))
-			drm_warn(&ptdev->base, "Failed to halt MCU on unplug");
-
 		panthor_fw_stop(ptdev);
 	}
 
-- 
2.51.0



