Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBB91586C3;
	Tue,  9 Jul 2024 11:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523497; cv=none; b=Oq/gsOO46EM1tHMH1gRfVsGB++G7s5/zvNtI8IhEebaigwcg4GU98e23SMUleBLSL2BTDsBb4Ad8TkcgbiYYlIyyxajv6A1YaQtHrT3bD7CASxLB52yA73plygtQnHjVuMTxTS9sJEU8aFqPuWWGlB3rUFQyYackFQ1LeER4g30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523497; c=relaxed/simple;
	bh=KrW/jko8x2zpz3WoHaN1r/2sgvVjPt8pWZFKBHEgZ4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZhmV7W/AYvywUXFHMzgcub8WYEf3/xtyJRs04OMVCZVZL1mRdyScGwNvOKyG4717H49ZP0MkbJKSBVQx/Y7o8zqzCEbT9jhyCji9gjt2/ExMWrI0Dqu1gktdqSrwQxtXkg0OCe1nmOF8ytXrC9z75OGUBDw/cW2ZJspPg59YU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JI3R19P1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JI3R19P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C216EC32786;
	Tue,  9 Jul 2024 11:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523497;
	bh=KrW/jko8x2zpz3WoHaN1r/2sgvVjPt8pWZFKBHEgZ4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JI3R19P1AJQRkYTIIzNtG5oXdbTPEpesbJiOA/rN8K+sp5EwWI1YQbj5mFgFy30Jd
	 PD4LW2M/+I9Lwy6k1BujnLw1wq36fCO9pjVefRzMtOrow2FxfdnOLH9N0w7WbVLtVI
	 gIHj0JzDGUxMsp4k+QcM3KqV/C5edk0z+XyodzmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erico Nunes <nunes.erico@gmail.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/139] drm/lima: fix shared irq handling on driver remove
Date: Tue,  9 Jul 2024 13:08:24 +0200
Message-ID: <20240709110658.320447134@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6cf46b653e810..ca3842f719842 100644
--- a/drivers/gpu/drm/lima/lima_gp.c
+++ b/drivers/gpu/drm/lima/lima_gp.c
@@ -324,7 +324,9 @@ int lima_gp_init(struct lima_ip *ip)
 
 void lima_gp_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 int lima_gp_pipe_init(struct lima_device *dev)
diff --git a/drivers/gpu/drm/lima/lima_mmu.c b/drivers/gpu/drm/lima/lima_mmu.c
index a1ae6c252dc2b..8ca7047adbaca 100644
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
index 54b208a4a768e..d34c9e8840f45 100644
--- a/drivers/gpu/drm/lima/lima_pp.c
+++ b/drivers/gpu/drm/lima/lima_pp.c
@@ -266,7 +266,9 @@ int lima_pp_init(struct lima_ip *ip)
 
 void lima_pp_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 int lima_pp_bcast_resume(struct lima_ip *ip)
@@ -299,7 +301,9 @@ int lima_pp_bcast_init(struct lima_ip *ip)
 
 void lima_pp_bcast_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 static int lima_pp_task_validate(struct lima_sched_pipe *pipe,
-- 
2.43.0



