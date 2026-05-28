Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3769257854;
	Thu, 28 May 2026 20:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999762; cv=none; b=js9TeadN4LmWP4r5turcszkXGAYu6oouEH6T3eDbJDsRO5HTJ82s0rnyWpXhdWvC8TmRQp/Pkcelyc5hx9EKXQyHuShLMCCzZlWGKx+UAaU5y9HnKyU3c/zVMUcno3JY6yHg/7qYtzgzSJcngeDvskEZ/4SGBMxqLkk9ui//1g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999762; c=relaxed/simple;
	bh=KP3GIbXO2P2UXsefGzocHk7ihWjVHqDU8qQS9y04hdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uetDI/YSZ20S6IXJfkOmMp+R7z/5WmbPC1dPBqo3BiLAHiqaaajxqVRI3EqKzARnR81VwxKDC6i23tyFMVP7F4c5YZsVa7k6JJToQ1v11M4+FlAN6mFzAWZgEwF6EbqlYOQefyOd3h1ZFGesszyMlLxF1t+gUROYmDwhAQb4XSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9wToKYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9wToKYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDF71F000E9;
	Thu, 28 May 2026 20:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999761;
	bh=Ppydo9njYeU6EUj0xPN9zGG12OuHOPjIe5y/iqt2HwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9wToKYvBBppgs8NHig+856n5r1KVt8+HZWJroneZPE8n39V8Rpy+Qv9g0A/GL69J
	 JTeGc5hJwyTAo0KoOJ6vO0/xBupMah/ewplmrDpj+uvd2HlyE69ShkhFpEErKeTS+5
	 3HWv93oeBTA+jqiqQ1KXk+5HUi2mgFMklNPTJ8jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/377] firmware: arm_ffa: Fix per-vcpu self notifications handling in workqueue
Date: Thu, 28 May 2026 21:46:59 +0200
Message-ID: <20260528194643.663826130@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 9985d5357ed93af0d1933969c247e966957730e1 ]

Per-vcpu notification handling already runs from a per-cpu work item on
the target cpu. Routing that path back through smp_call_function_single()
re-enters the call-function IPI path and executes the notification
handler with interrupts disabled. That makes the framework path unsafe,
since it takes a mutex, allocates memory with GFP_KERNEL, and invokes
client callbacks.

Handle per-vcpu self notifications directly from the existing per-cpu
work item instead. This keeps the per-vcpu path in task context and
avoids the extra IPI hop entirely.

Fixes: 3a3e2b83e805 ("firmware: arm_ffa: Avoid queuing work when running on the worker queue")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-4-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index cf7f913a55b6e..30f8e0ff694fb 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1538,7 +1538,7 @@ static void notif_pcpu_irq_work_fn(struct work_struct *work)
 	struct ffa_drv_info *info = container_of(work, struct ffa_drv_info,
 						 notif_pcpu_work);
 
-	ffa_self_notif_handle(smp_processor_id(), true, info);
+	notif_get_and_handle(info);
 }
 
 static const struct ffa_info_ops ffa_drv_info_ops = {
-- 
2.53.0



