Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EE31AA1D2;
	Thu, 28 May 2026 20:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998485; cv=none; b=NxshNCGZ6uPpw1m7kk2d5oquP5SppNprqpw2i4PCA0djl8MJK32dReCI8a3ZmxX4+jaMwsbzLhYtS+PJq/8WVIGZLmzrMpBQJL7bSYBIn4p1SgUfXQVhjWvMW2YN5RNwqUga6ukG9AvA37DsdLPum82yrtn2p6MFmVUqZdavcBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998485; c=relaxed/simple;
	bh=R6oboEaI0zCotOzHB9k4/ueKIFwm6hlE1sGBnepCRbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndw4XZNBLh4mRhWAJZYFkF36ClnUH6QmhjkDUUnbkQYoTqwWa55HW7cZk1/EOJxXC2CO1kXkadbK1p7bl4VDjO5+CDx0WTFnZR5dsMLdVHXr+4nGfpOC9hD7MSt3b9nqn+UuBEA+Pv4nLbS1HrEQQuoKssfdxUcok6KHWYlUSQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAQWsKh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAQWsKh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EABE1F000E9;
	Thu, 28 May 2026 20:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998484;
	bh=AxzO/onW9+vtUmTWpE2Fk870Col93ebkBgxGzpgJ8KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAQWsKh2zzpt6b1kAbtsMCFXOzWHkbZvCUE7q5ZPVz9hpkBsGyHbmpO3s0g84iaNf
	 XQM9edOHMO2xs3BJvDa/9m2igHpDpNQhRRVtAjeBSKilL1u2pwukTdKlUcfTI3QR0U
	 3H0YobgMoya7MQ0mZOd6GDW/rL8sIiBk/jwY61sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 189/461] firmware: arm_ffa: Fix per-vcpu self notifications handling in workqueue
Date: Thu, 28 May 2026 21:45:18 +0200
Message-ID: <20260528194652.548081790@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index e6a051b20cb72..59d12facb7dd6 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1542,7 +1542,7 @@ static void notif_pcpu_irq_work_fn(struct work_struct *work)
 	struct ffa_drv_info *info = container_of(work, struct ffa_drv_info,
 						 notif_pcpu_work);
 
-	ffa_self_notif_handle(smp_processor_id(), true, info);
+	notif_get_and_handle(info);
 }
 
 static const struct ffa_info_ops ffa_drv_info_ops = {
-- 
2.53.0



