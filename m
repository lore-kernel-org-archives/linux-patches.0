Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582A6158A33;
	Tue,  9 Jul 2024 11:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523974; cv=none; b=hOr5oFdP39LvJs0BxIzHu52lmm9XkWmOCSJKFjsNCkMVc8b77J2vmAIvSd1TzftYTRsOaGkQD5ARcPvzHPxoS2UF2civSJIe7XB4gbWPkQ8xP3gVSIYcf58ZtxCal5I4z4WqNmlI2wRJOyekDHPYzbVS/6oCJqaaXtKGkhxiD2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523974; c=relaxed/simple;
	bh=AuutegoDsvpVD2ClJ7LzOP5rs8J01FEoIdmD5knhjBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TM0CDm3EsP3WJ35w78AJWQQgHo62/DuqtfD9jTaMtzbNoTkEAfx8ex0p16dT9oCYRZsap0e9ywSR7lPuTT9cWy8oEPzTBVJ/8zfzUirMz08KEHbFL2j1EzBRKvvnUVhakS1QaPqAkRtiKXewhOMyXYl87ToZXTPv6TT54Ky0hfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWxG0rCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWxG0rCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C4BC4AF0B;
	Tue,  9 Jul 2024 11:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523973;
	bh=AuutegoDsvpVD2ClJ7LzOP5rs8J01FEoIdmD5knhjBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWxG0rCe5dsBM0Ir1IN1EpwQFzGia0jyZ1dNc8YPfLBTSY5U4HtZe4PdQmLicukqL
	 EdRQCajHIygo/ngfhw2U5xGtMT5tRQq1vdTnv939zy/Sh/sG0kVU94pIbtlFr/9oQy
	 61PHC6DB4s1WBsSbAaggBxJPxW7WuV8UCrbV9nSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erico Nunes <nunes.erico@gmail.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 006/197] drm/lima: fix shared irq handling on driver remove
Date: Tue,  9 Jul 2024 13:07:40 +0200
Message-ID: <20240709110709.155819203@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erico Nunes <nunes.erico@gmail.com>

[ Upstream commit a6683c690bbfd1f371510cb051e8fa49507f3f5e ]

lima uses a shared interrupt, so the interrupt handlers must be prepared
to be called at any time. At driver removal time, the clocks are
disabled early and the interrupts stay registered until the very end of
the remove process due to the devm usage.
This is potentially a bug as the interrupts access device registers
which assumes clocks are enabled. A crash can be triggered by removing
the driver in a kernel with CONFIG_DEBUG_SHIRQ enabled.
This patch frees the interrupts at each lima device finishing callback
so that the handlers are already unregistered by the time we fully
disable clocks.

Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240401224329.1228468-2-nunes.erico@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_gp.c  | 2 ++
 drivers/gpu/drm/lima/lima_mmu.c | 5 +++++
 drivers/gpu/drm/lima/lima_pp.c  | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/lima/lima_gp.c b/drivers/gpu/drm/lima/lima_gp.c
index e15295071533b..3282997a0358d 100644
--- a/drivers/gpu/drm/lima/lima_gp.c
+++ b/drivers/gpu/drm/lima/lima_gp.c
@@ -345,7 +345,9 @@ int lima_gp_init(struct lima_ip *ip)
 
 void lima_gp_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 int lima_gp_pipe_init(struct lima_device *dev)
diff --git a/drivers/gpu/drm/lima/lima_mmu.c b/drivers/gpu/drm/lima/lima_mmu.c
index e18317c5ca8c1..6611e2836bf0d 100644
--- a/drivers/gpu/drm/lima/lima_mmu.c
+++ b/drivers/gpu/drm/lima/lima_mmu.c
@@ -118,7 +118,12 @@ int lima_mmu_init(struct lima_ip *ip)
 
 void lima_mmu_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
+
+	if (ip->id == lima_ip_ppmmu_bcast)
+		return;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 void lima_mmu_flush_tlb(struct lima_ip *ip)
diff --git a/drivers/gpu/drm/lima/lima_pp.c b/drivers/gpu/drm/lima/lima_pp.c
index a4a2ffe6527c2..eaab4788dff49 100644
--- a/drivers/gpu/drm/lima/lima_pp.c
+++ b/drivers/gpu/drm/lima/lima_pp.c
@@ -286,7 +286,9 @@ int lima_pp_init(struct lima_ip *ip)
 
 void lima_pp_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 int lima_pp_bcast_resume(struct lima_ip *ip)
@@ -319,7 +321,9 @@ int lima_pp_bcast_init(struct lima_ip *ip)
 
 void lima_pp_bcast_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 static int lima_pp_task_validate(struct lima_sched_pipe *pipe,
-- 
2.43.0



