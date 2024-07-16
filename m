Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CAE1DDCE;
	Tue, 16 Jul 2024 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145977; cv=none; b=gniFBCZ6MDor/7bEkzvch+ugnV7Z+mJqbToGzUORIWmKuce5dS8CE1CDldpHi5PEnAcwo/McjvQSVXei2W+Vjy2AHuG7D82U69L69VpE/30D4fealUSNaf+mXbUyxO2JZxdjhUBjn8g4p+/C/iJMHcUEKqx7YTJjpPH8yo92/Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145977; c=relaxed/simple;
	bh=LKm23UAJQhPHrFGqqx7R0NSXx0IrF5dC3u9Zk/0Q6gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miJbqRam5STq2l6Aq8jikCmDcOa3TKAK1t13MGbM0hJoxxvdPd0UtRS3fXY1fRw+O01S9gPB1CTe8m5MIrMOCb7HZNLwxm750KwTWL5Rflw7QhFjovn3nt18utkL8jTTZ6HErnXJCpKUvDqwg0p7pvekMHCYc/Y5U6ysrK9Qt54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsonmLZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsonmLZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3577C116B1;
	Tue, 16 Jul 2024 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145977;
	bh=LKm23UAJQhPHrFGqqx7R0NSXx0IrF5dC3u9Zk/0Q6gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsonmLZERtwJJCTDZh7cAxjvNd0eQ/UBQixoXUuvWUgkBNZXx+ZVdom8UzLjLaAZh
	 Gy7n0mYU2GGm0bAbmP//pFbq+pIf+SO4zFmqgwiYL/AE3IVTy4P8jJYnTbjQOx5s20
	 LUAjCokm4cRvaVpBy7m6YaeYDDDyUpUZCyIISDe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erico Nunes <nunes.erico@gmail.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/144] drm/lima: fix shared irq handling on driver remove
Date: Tue, 16 Jul 2024 17:31:11 +0200
Message-ID: <20240716152752.621296510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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



