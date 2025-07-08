Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F942367CE;
	Tue,  8 Jul 2025 16:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992630; cv=none; b=TJQOtcsoxv97YpTTd9G9fUNkaayzA25RtpQ9JYpoMCx99vG9qY4nJBWIoDkbE2FxLg0tPoTZPi62KJc7mvsR/0wIBuCUFsy3h4bMwQFHr0+/WBA9Cr1pWZnY/GsQoaokOi9mR3KetyGfvMbCdy3CD5GpurWeSw545lRa/5tMfHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992630; c=relaxed/simple;
	bh=YgjFQ+R9kdNqj4/XXYjqUN4Bj1gKG0mB0hRtPMMjPDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3qiWT2sMB+SwygqJZZCOv7A889WCAJ9jyJlMK4Oikf1QVj8ygbJ9m96SHD3lD/sre8EWt0yLerKE5DCxfmvEqrArTiM24nv3rg3JZzgin86R267sTaStcqPHAGSeZnZNwVGYBDYRm3QwXCkCXsw+sCtUYQsWyAJQrnv7S2+j0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYEMPyPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYEMPyPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D154BC4CEED;
	Tue,  8 Jul 2025 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992630;
	bh=YgjFQ+R9kdNqj4/XXYjqUN4Bj1gKG0mB0hRtPMMjPDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYEMPyPFVcNXsWAjjsRizKpbHOlZK8UrFBtynHMx0xwmYbzE9156GBBOwkXWUptAP
	 4qAbI74EnrHPl66YE7jsj1lxGF5cjAwv1UsorxrPEUCQj8yeuxHrgy75JL5uLV7kS3
	 2/c3c+Xo2sdLMlg86aXUO+NlWY7Ec6n5ttGKXgwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/232] firmware: arm_ffa: Fix memory leak by freeing notifier callback node
Date: Tue,  8 Jul 2025 18:20:22 +0200
Message-ID: <20250708162242.116644195@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit a833d31ad867103ba72a0b73f3606f4ab8601719 ]

Commit e0573444edbf ("firmware: arm_ffa: Add interfaces to request
notification callbacks") adds support for notifier callbacks by allocating
and inserting a callback node into a hashtable during registration of
notifiers. However, during unregistration, the code only removes the
node from the hashtable without freeing the associated memory, resulting
in a memory leak.

Resolve the memory leak issue by ensuring the allocated notifier callback
node is properly freed after it is removed from the hashtable entry.

Fixes: e0573444edbf ("firmware: arm_ffa: Add interfaces to request notification callbacks")
Message-Id: <20250528-ffa_notif_fix-v1-1-5ed7bc7f8437@arm.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 47751b2c057ae..c0f3b7cdb6edb 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1166,6 +1166,7 @@ update_notifier_cb(int notify_id, enum notify_type type, ffa_notifier_cb cb,
 		hash_add(drv_info->notifier_hash, &cb_info->hnode, notify_id);
 	} else {
 		hash_del(&cb_info->hnode);
+		kfree(cb_info);
 	}
 
 	return 0;
-- 
2.39.5



