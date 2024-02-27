Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA4B14534B;
	Tue, 27 Feb 2024 13:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042033; cv=none; b=MfnS4pJaBjSTMDZzXK8cxsYCBVNSpEK+ES4tiX9MPlbSxUMauwVFzZ4jBBmGD2QR8CYo9ZqnxvpGYw+xmM0CeJZN42T+DsDY5yEleuhoDeuyfIzlYC97LlXCFmf61APGz6bs3Dkr0YM2mHsQsOWXhU5v4MSTB3iJqfnDBEUHgLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042033; c=relaxed/simple;
	bh=bFAYN8I42tJpSwG4wfW+DDYfRlDIQOdKEAILLrr8XNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkM2Pbvh7y20wfV6kZ0ldjDZC13ALdaYhjyi/3285oviECYfypi0s4a5OCYhQezOEbChMOagMhb/rJQihwuP686+5MkYz/nrK1ozwpHFmPPmqgZjwKCk6l4KFKHPuQb8xeB+vlirLOqTwd3Da3OyLHrMuc5SDYjHwrS/zwAKE8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGi6XGmm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGi6XGmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7E9C433C7;
	Tue, 27 Feb 2024 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042033;
	bh=bFAYN8I42tJpSwG4wfW+DDYfRlDIQOdKEAILLrr8XNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGi6XGmml+CTkTTCuf4X4gKYyUZ/hCAVPQKKU3XJoo8QhVPsTj7tfxXoZ+QS98f/E
	 DIs2gXFJ4jigRC16M8yt72J43W6g9aujWWJ9qopkmA2qpeDTwDMEz79qy3NBtOZRtV
	 JVB29TwlPWLpS2lNQKXtEI6jXPIZV/x/70U2cnO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/299] xen: evtchn: Allow shared registration of IRQ handers
Date: Tue, 27 Feb 2024 14:23:58 +0100
Message-ID: <20240227131629.949900644@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 9e90e58c11b74c2bddac4b2702cf79d36b981278 ]

Currently the handling of events is supported either in the kernel or
userspace, but not both.

In order to support fast delivery of interrupts from the guest to the
backend, we need to handle the Queue notify part of Virtio protocol in
kernel and the rest in userspace.

Update the interrupt handler registration flag to IRQF_SHARED for event
channels, which would allow multiple entities to bind their interrupt
handler for the same event channel port.

Also increment the reference count of irq_info when multiple entities
try to bind event channel to irqchip, so the unbinding happens only
after all the users are gone.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/99b1edfd3147c6b5d22a5139dab5861e767dc34a.1697439990.git.viresh.kumar@linaro.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: fa765c4b4aed ("xen/events: close evtchn after mapping cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 3 ++-
 drivers/xen/evtchn.c             | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index c50419638ac0a..cd33a418344a8 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1235,7 +1235,8 @@ static int bind_evtchn_to_irq_chip(evtchn_port_t evtchn, struct irq_chip *chip,
 		bind_evtchn_to_cpu(evtchn, 0, false);
 	} else {
 		struct irq_info *info = info_for_irq(irq);
-		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
+		if (!WARN_ON(!info || info->type != IRQT_EVTCHN))
+			info->refcnt++;
 	}
 
 out:
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index 9139a7364df53..59717628ca42b 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -397,7 +397,7 @@ static int evtchn_bind_to_user(struct per_user_data *u, evtchn_port_t port,
 	if (rc < 0)
 		goto err;
 
-	rc = bind_evtchn_to_irqhandler_lateeoi(port, evtchn_interrupt, 0,
+	rc = bind_evtchn_to_irqhandler_lateeoi(port, evtchn_interrupt, IRQF_SHARED,
 					       u->name, evtchn);
 	if (rc < 0)
 		goto err;
-- 
2.43.0



