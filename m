Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA5C29CB24;
	Tue, 16 Dec 2025 12:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887315; cv=none; b=MO1ghlwT2SpJ+ZFcGMXYa9BoBli9b/+3vMFXTZr7vfDb2tab2qTNxQz3BERJ5rKLATdq5ve4IkxBxuDDzmVGbIaXzE6CWR29S+IUlQe+JkHSl8i4JrYazpc0HzlGtZp1Fy179bSijchb8dq54tQbK9Vw7gkNVmwbY7+aq1FglZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887315; c=relaxed/simple;
	bh=BMBK/lmbi8xVq53jaXaG6NYlx0ILHfZLkGhpX9HYFpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB+xm5ab9+zZd/+1Ra5j6PSLM2ozE9PpagBqMazY7EWQ6dYOkTBTfgfBkM3jUOIiyf26az4PrqtNmsX5QVSQ6tvPKWSxzagYNi7rnk8QRY57iU9/x8fsGnmu7D2eQq9jy4vvAIXhQS8Uk1sEYj1YKEuVPfSAJJX68iEMXTkjvDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGCvCcRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGCvCcRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69184C4CEF1;
	Tue, 16 Dec 2025 12:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887314;
	bh=BMBK/lmbi8xVq53jaXaG6NYlx0ILHfZLkGhpX9HYFpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGCvCcRo9tDWXh865C3xl0b4nBcVttrnXKs0PoECkYEo9TfjzBPp94soeAaX1i5Jx
	 mdsmS6lQF89PMQqu+m2k7GnKs7+2wD228MDgTRrpLS7GIy3h8tmvv4jewzbJFeTLMp
	 1PYS1JHQKAVsCFwZgivAWexPhf/mtBm868FQEQT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ketil Johnsen <ketil.johnsen@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 192/614] drm/panthor: Fix UAF race between device unplug and FW event processing
Date: Tue, 16 Dec 2025 12:09:19 +0100
Message-ID: <20251216111408.328022182@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ketil Johnsen <ketil.johnsen@arm.com>

[ Upstream commit 7051f6ba968fa69918d72cc26de4d6cf7ea05b90 ]

The function panthor_fw_unplug() will free the FW memory sections.
The problem is that there could still be pending FW events which are yet
not handled at this point. process_fw_events_work() can in this case try
to access said freed memory.

Simply call disable_work_sync() to both drain and prevent future
invocation of process_fw_events_work().

Signed-off-by: Ketil Johnsen <ketil.johnsen@arm.com>
Fixes: de85488138247 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20251027140217.121274-1-ketil.johnsen@arm.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index a39f0fb370dc6..0279e19aadae9 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3859,6 +3859,7 @@ void panthor_sched_unplug(struct panthor_device *ptdev)
 	struct panthor_scheduler *sched = ptdev->scheduler;
 
 	cancel_delayed_work_sync(&sched->tick_work);
+	disable_work_sync(&sched->fw_events_work);
 
 	mutex_lock(&sched->lock);
 	if (sched->pm.has_ref) {
-- 
2.51.0



