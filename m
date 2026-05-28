Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B171DE4E0;
	Thu, 28 May 2026 20:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000729; cv=none; b=EVY2c/MsxU3BIDrySGXNMmygRTiQ5bz5wMDWPmeMAf1y2h1mYrQbPOV7gynN1nhYsHxXtEkCAQfyxzMuOBN/djaSw4q8i0PokRzvDjQ9jahbe1/uYL/2/qsFfBEcHofkZ2KU75Pm7+fAGr8wxCj79d6UhSygw8IpRC3R94RFKMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000729; c=relaxed/simple;
	bh=rMa4zBDMgUOaKF99+6TkGMWpXTiU3MoZ/djo18MeXus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keRvdiGvG7g28iwDiiX9gXML/5Fo+oRAYotgerMJ9b40fmsxW/wnu774wmpZNf87w3gPGK8LTgLKhesSfQRAs0u2FQxjrYiTPZUt8gVcFvNxQmwQycmS8HpgxIOC+xw3YHcJ4+UPCm1orNFeduY/8dy4zgp5Yo8SSZNz/SLtZPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtxuG7Xq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtxuG7Xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052771F000E9;
	Thu, 28 May 2026 20:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000728;
	bh=j7id6sH68gOHeo7IxKyutd+A3i9e1ubRRgBf8mlUkQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtxuG7Xq6iO3oia1x7SUGAJG2Qh/RWNj6c1+HIFtKTLqxZEPyq1kFU+jEdDiL43PR
	 GVWdzFU2PxUPzR9vZtDWmaEcMWqeIHqzW6RB8c4HkkSW95k66eRDQfXnC3cfz5jR+7
	 fbRXb90BVh5XaXCRG3cpkr1AHCBCby/yTMjhJ/ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/272] firmware: arm_ffa: Fix per-vcpu self notifications handling in workqueue
Date: Thu, 28 May 2026 21:48:42 +0200
Message-ID: <20260528194633.516102012@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 61d4a4b7d97b6..39f19acdce904 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1336,7 +1336,7 @@ static void notif_pcpu_irq_work_fn(struct work_struct *work)
 	struct ffa_drv_info *info = container_of(work, struct ffa_drv_info,
 						 notif_pcpu_work);
 
-	ffa_self_notif_handle(smp_processor_id(), true, info);
+	notif_get_and_handle(info);
 }
 
 static const struct ffa_info_ops ffa_drv_info_ops = {
-- 
2.53.0



