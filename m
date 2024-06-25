Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0D8FBEF;
	Tue, 25 Jun 2024 09:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308241; cv=none; b=t81NAzix2u5/3iBoiATLIGbj2E45R1FQRcuie+St060iqsJUEqosXqd126+5SCrIJ7sbFaWWhH2hwxe0T89Sn+kjjjLkd1sv3LAf47sMiDdY4WoAkLPlnqwYqGMCAcovgKxQHcrGJ1GV9NK1DNRO/Hk5aUOu7BNLeDl8PsRbPXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308241; c=relaxed/simple;
	bh=AI78WzMVQxi4lawqaFXd1seJfWpNyNLBUNOd277zqYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkQgddg2VsIOsL8aS/rh5tO1OrsZXNQvBMwvv1p17o63wss3xSWeEscGfj1SqRf+ZUUs6pt0cbu8IOgL6ewWYvFjf4DcCSrGQ9Ad8qR6HD0tE1FzZx4tzvLGBitRlRRJkqGayEWoiFQPodgYcXPgzSw/s6AaohrZoajxeSXzhPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoD3WFTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoD3WFTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A48C32781;
	Tue, 25 Jun 2024 09:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308241;
	bh=AI78WzMVQxi4lawqaFXd1seJfWpNyNLBUNOd277zqYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoD3WFTmwW0wCVvgXwrYhaf73G7TrTGlGdZq9UmSMD70BaanYGbcQKPXcRG+YmtPK
	 3fDwMEsP5bEnDMoxMWGP2ZsRZGvsb8rxXnMoMTCoVDYJ9iE7YNFibMwGUVwdvYGQFd
	 RKNA3EWNUy7QUqJs0R8QWUdy3F5iHqeHE2+7c5yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erico Nunes <nunes.erico@gmail.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 054/250] drm/lima: include pp bcast irq in timeout handler check
Date: Tue, 25 Jun 2024 11:30:12 +0200
Message-ID: <20240625085550.135658412@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

[ Upstream commit d8100caf40a35904d27ce446fb2088b54277997a ]

In commit 53cb55b20208 ("drm/lima: handle spurious timeouts due to high
irq latency") a check was added to detect an unexpectedly high interrupt
latency timeout.
With further investigation it was noted that on Mali-450 the pp bcast
irq may also be a trigger of race conditions against the timeout
handler, so add it to this check too.

Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240405152951.1531555-3-nunes.erico@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/lima/lima_sched.c b/drivers/gpu/drm/lima/lima_sched.c
index 00b19adfc8881..66841503a6183 100644
--- a/drivers/gpu/drm/lima/lima_sched.c
+++ b/drivers/gpu/drm/lima/lima_sched.c
@@ -422,6 +422,8 @@ static enum drm_gpu_sched_stat lima_sched_timedout_job(struct drm_sched_job *job
 	 */
 	for (i = 0; i < pipe->num_processor; i++)
 		synchronize_irq(pipe->processor[i]->irq);
+	if (pipe->bcast_processor)
+		synchronize_irq(pipe->bcast_processor->irq);
 
 	if (dma_fence_is_signaled(task->fence)) {
 		DRM_WARN("%s unexpectedly high interrupt latency\n", lima_ip_name(ip));
-- 
2.43.0



