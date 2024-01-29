Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B12158D68;
	Mon, 29 Jan 2024 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548322; cv=none; b=sBKYEZbNW+HUBZ8pQ/AXP3BPsJQTNp49LBLBHZo2VwZhRFmxG22HkGGB/qUp9j40JZfQqcKrNa/u2or20aAMZ0jhzUOZqzqTacdVAZcuhhchZOG0QkOQ88F+sfy8cV7m47TyiWlBnkP87TrUKxLjrHCUGdfW6ilABLemnoUC4Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548322; c=relaxed/simple;
	bh=0/Z6oG2siQuOTB4805l7vdPsmC8tx5IK71iESFT5xtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjvvyihespacYAldUnUhLEuRpF0mXuYOzLNRJaEg4fcb5Rkb3WFf+7Zam1VrgZjfLX9aZcGDZvr+JoN3qbHA+ADwhZyYuumkitDdDgBZ/sBi/jekHSfaFacXBezqnfgdB+8lVK2FHtINB9r51OOgquCQMH0gssKn6tJoOXXLmsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0SvEljE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0SvEljE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D5EC433F1;
	Mon, 29 Jan 2024 17:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548321;
	bh=0/Z6oG2siQuOTB4805l7vdPsmC8tx5IK71iESFT5xtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0SvEljE2Rx89s4xOADdGJfq7IuK17dP6soxl5HBSU0AWm5Iqrqyjh9TljBwd1s6z
	 oNlFBJVfQeEEr8nMFPv9xu9Oa0ThFbEEUX3YOIRsoanHZNYfiWFAVmVeSOKYLkr+7s
	 VBbfYWK6yds8fYY0SIX5JlMwJsrXr3dihdIj6S/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 323/346] firmware: arm_ffa: Check xa_load() return value
Date: Mon, 29 Jan 2024 09:05:54 -0800
Message-ID: <20240129170025.975954440@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit c00d9738fd5fce15dc5494d05b7599dce23e8146 ]

Add a check to verify the result of xa_load() during the partition
lookups done while registering/unregistering the scheduler receiver
interrupt callbacks and while executing the main scheduler receiver
interrupt callback handler.

Fixes: 0184450b8b1e ("firmware: arm_ffa: Add schedule receiver callback mechanism")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240108-ffa_fixes_6-8-v1-3-75bf7035bc50@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 8df92c9521f4..0ea1dd6e55c4 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -733,6 +733,11 @@ static void __do_sched_recv_cb(u16 part_id, u16 vcpu, bool is_per_vcpu)
 	void *cb_data;
 
 	partition = xa_load(&drv_info->partition_info, part_id);
+	if (!partition) {
+		pr_err("%s: Invalid partition ID 0x%x\n", __func__, part_id);
+		return;
+	}
+
 	read_lock(&partition->rw_lock);
 	callback = partition->callback;
 	cb_data = partition->cb_data;
@@ -915,6 +920,11 @@ static int ffa_sched_recv_cb_update(u16 part_id, ffa_sched_recv_cb callback,
 		return -EOPNOTSUPP;
 
 	partition = xa_load(&drv_info->partition_info, part_id);
+	if (!partition) {
+		pr_err("%s: Invalid partition ID 0x%x\n", __func__, part_id);
+		return -EINVAL;
+	}
+
 	write_lock(&partition->rw_lock);
 
 	cb_valid = !!partition->callback;
-- 
2.43.0



