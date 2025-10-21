Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF6B2797B5;
	Tue, 21 Oct 2025 20:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077536; cv=none; b=K/efDwEM/MosVqMf/A/MoX3igo7STbOPEsUzpxSbEmjIu7A8OxyRozC2eMcuw0eGETum4Z4A8KGCw94/VHZZ96/AcBmzT591iRKRB+2i1ZLcXLPf0NYnBxdsCMVMCkPWNeq+josjHWUihgxkPDj6suyDwrjJaV201B92IiC5nWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077536; c=relaxed/simple;
	bh=0oW+TTq0/lrg6dgtcJUohYX6hG0p0R+0+Unhlr2fQ4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzA2fXZyotV9oliEU6eGSpWi5h6O7tK0CESQcPa4toeR3CjXKaKQnNBk9u4BIQQakicTjlVWfHS8Bg6I+zNzuxqeEVrK8n3b+QVbNJ2hnKhaqSrflLTHK9P09r7HELTI6QcHjgq6xewZ4gaAR0xCpALApAOc3njhmn1sTlhg24E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iX42YahK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iX42YahK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B5CC4CEF7;
	Tue, 21 Oct 2025 20:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077536;
	bh=0oW+TTq0/lrg6dgtcJUohYX6hG0p0R+0+Unhlr2fQ4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iX42YahK5LWPUrBGTPy+DRi3K8cVZdjDQlVL9LOUvddfypFX6E49nnSS3zKUd0xbD
	 S9UF5jslwmtH14JpDxNYp9X5eQm0jKN1i/SwMR7DH12Nb1/a+uBLW0J3NK9eY/q/SE
	 d6Kkb0PdugWgMKvLEG5VUTMh/OQALXDC9/6H2GP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ketil Johnsen <ketil.johnsen@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 092/159] drm/panthor: Ensure MCU is disabled on suspend
Date: Tue, 21 Oct 2025 21:51:09 +0200
Message-ID: <20251021195045.400753798@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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
index 36f1034839c27..44a9958351889 100644
--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -1099,6 +1099,7 @@ void panthor_fw_pre_reset(struct panthor_device *ptdev, bool on_hang)
 	}
 
 	panthor_job_irq_suspend(&ptdev->fw->irq);
+	panthor_fw_stop(ptdev);
 }
 
 /**
-- 
2.51.0



