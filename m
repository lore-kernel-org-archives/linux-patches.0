Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EA21754B;
	Tue,  8 Jul 2025 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993320; cv=none; b=Ka3kKjbnKleNRLCzVaA3AXtMg6zkH9r+B8FZ532cHnGdrszeBizZiyHi3HF0/yEYmoQM2X4ZOVXtvFPDY3g0nBg1nOdK8BRSfqKow6Er0Wp/tFySCypvZVRLAa0MovLARiyCK0NzpoGYfW/AVW76MmVUbkT/gBpLsEGOcPGnA4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993320; c=relaxed/simple;
	bh=vPgRs4T2lJlsCazMeiG0fvjfHKwIjp82GvFAMDSHLjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1uPjS49Utlf+SPxS7nCbx5IrqHJ3a1Y1kn/eWPSdARANUhJAj/uHeg26i/qONxGk63ySEx0pNiU6wLsnC48yh0Pmn0+5IVixAA80GGtUXdk8VMX3jgqUypy2RUmBy8Yg5Up1Dm/yJjuk+2p6J1I0r5SoaWpXCCxiWkvxPvuXq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5/t+pxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5/t+pxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306F8C4CEED;
	Tue,  8 Jul 2025 16:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993320;
	bh=vPgRs4T2lJlsCazMeiG0fvjfHKwIjp82GvFAMDSHLjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5/t+pxc8vOaNga0DCjGdibMAsWuBqSsb7y3XK57MWZw90ut93Z/SPpYpZ0jIuDb+
	 yWQzZG/Du3+uET5UT5fpXQqx3U2IJ5YebMw3o+bTWefkvVGIOhIZYbX5g3mcamlSxj
	 WLD1oEKyjlvsnoaXMbQiWT7GZGRWG7Zv4SOQEKnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 033/178] firmware: arm_ffa: Fix memory leak by freeing notifier callback node
Date: Tue,  8 Jul 2025 18:21:10 +0200
Message-ID: <20250708162237.415950386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index fe55613a8ea99..6f75cdf297209 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1284,6 +1284,7 @@ update_notifier_cb(struct ffa_device *dev, int notify_id, void *cb,
 		hash_add(drv_info->notifier_hash, &cb_info->hnode, notify_id);
 	} else {
 		hash_del(&cb_info->hnode);
+		kfree(cb_info);
 	}
 
 	return 0;
-- 
2.39.5



