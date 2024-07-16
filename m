Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3A0E541;
	Tue, 16 Jul 2024 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144248; cv=none; b=OC+EZMCFMzPEcvrxQhCbZwuDwuMsAHz0S1R6E87fcyWOphTW0tLdT/Kkfz7Xsre25DJ6vlEE5WvzCFlFqn7EwM8pR2DrKijnSjlKG7jo7sV1T/EcH+Ub8LZp9GkRGAAVZkLbUdOV+0gkZGma+vVVmmAdN5WXZjZTyXHwJhlvR+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144248; c=relaxed/simple;
	bh=eLtU7gArPbwEBjwiGiyLoqgOR/vFBSog1DeHonOAspY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEtvBGfqJz2ax1H6KBLlojQMkVXX7bzNdBbybwp5ZngkN7yAzN0Mih2Q/bt+5yP9WJnvuEeJGGIHs0pckVN+dhnXclF2tmD8lEYMBe54zykbpc6x/oQaew9Z2fO0s3DYiAnKdSiTP9PZjWt4z+LnLLTYsBPd4/qBmB/bKqYtF78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJzJG/SQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJzJG/SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837A9C116B1;
	Tue, 16 Jul 2024 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144247;
	bh=eLtU7gArPbwEBjwiGiyLoqgOR/vFBSog1DeHonOAspY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJzJG/SQyHBAV8Inyu+3JppCHQbwp/zNUI0o7kwQU4VPL+htBfymP1llFMy0UDJG6
	 BOmXsFy8zzlywC+TV9kraiecmIUBscZ+3k3TgI0AXd5HsDbgs0+fJeaQaYhaVALbLe
	 MflPh37hEW6uQaJI6Ur0wd2bfNMlAkYuCRyCIn9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erico Nunes <nunes.erico@gmail.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/78] drm/lima: fix shared irq handling on driver remove
Date: Tue, 16 Jul 2024 17:30:33 +0200
Message-ID: <20240716152740.685623220@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ccf49faedebf8..3fca560087c97 100644
--- a/drivers/gpu/drm/lima/lima_gp.c
+++ b/drivers/gpu/drm/lima/lima_gp.c
@@ -244,7 +244,9 @@ int lima_gp_init(struct lima_ip *ip)
 
 void lima_gp_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 int lima_gp_pipe_init(struct lima_device *dev)
diff --git a/drivers/gpu/drm/lima/lima_mmu.c b/drivers/gpu/drm/lima/lima_mmu.c
index 8e1651d6a61fa..04e6090cce595 100644
--- a/drivers/gpu/drm/lima/lima_mmu.c
+++ b/drivers/gpu/drm/lima/lima_mmu.c
@@ -97,7 +97,12 @@ int lima_mmu_init(struct lima_ip *ip)
 
 void lima_mmu_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
+
+	if (ip->id == lima_ip_ppmmu_bcast)
+		return;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 void lima_mmu_switch_vm(struct lima_ip *ip, struct lima_vm *vm)
diff --git a/drivers/gpu/drm/lima/lima_pp.c b/drivers/gpu/drm/lima/lima_pp.c
index 8fef224b93c85..1dacca8bffe1a 100644
--- a/drivers/gpu/drm/lima/lima_pp.c
+++ b/drivers/gpu/drm/lima/lima_pp.c
@@ -251,7 +251,9 @@ int lima_pp_init(struct lima_ip *ip)
 
 void lima_pp_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 int lima_pp_bcast_init(struct lima_ip *ip)
@@ -272,7 +274,9 @@ int lima_pp_bcast_init(struct lima_ip *ip)
 
 void lima_pp_bcast_fini(struct lima_ip *ip)
 {
+	struct lima_device *dev = ip->dev;
 
+	devm_free_irq(dev->dev, ip->irq, ip);
 }
 
 static int lima_pp_task_validate(struct lima_sched_pipe *pipe,
-- 
2.43.0



