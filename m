Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79A91DED58;
	Wed,  6 Nov 2024 12:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896024; cv=none; b=sjbZbR8ZfzW+dXnA1+bsYhsBZH5wuV1dv3JflRk9XGobwaXLIe8xOkEYDrbQSag5C8bTbb2Fd31MQQgBCY8G0CdMVF8IXyYQfkbfAuEZTSU7++3Svot1oOdoIjN0IApLlvNw9CaBpiro3R5+KpzpMJ2OL1f1xrKHWmGoNertatI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896024; c=relaxed/simple;
	bh=zLs9yJvZ9b8TPhARydtbZs/NgH0oA2GX7uhAA1Psdk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US+3jJg8y4YxlqZBhJ2lFRLakllZXJjpN5KXhSiOMjMq1WLZuaFq1Vmx3ZavglpMF3DorxiMlP+eeVfFuOMwuMuUTpQAYwr6UST2mllDJ+QAsVIsAx6xNCaZ2KhJ+LXlYE9qIAn2/T12AXWka0GK9Xr0sN9d8LVRbrGpe6uY1k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrZEKele; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrZEKele"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB10C4CECD;
	Wed,  6 Nov 2024 12:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896024;
	bh=zLs9yJvZ9b8TPhARydtbZs/NgH0oA2GX7uhAA1Psdk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrZEKelemfn+8fJZ4hsM9P81uSh8SJ9Jlwv5ZjwdVdP+4oBnqGUyuG1qxFFbbN5VA
	 00UaowaSbfPZdQ97LjqA4uY3uzz7Ht7koJ6gc71A+/GWvr8qT/X+R2Jn3P+RMjyTAb
	 fhmW03NY5yfAh67zL9LDaE4PCZJYpIWEJzPG0EyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 064/245] firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()
Date: Wed,  6 Nov 2024 13:01:57 +0100
Message-ID: <20241106120320.782220101@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit c83212d79be2c9886d3e6039759ecd388fd5fed1 ]

In sdei_device_freeze(), the input parameter of cpuhp_remove_state() is
passed as 'sdei_entry_point' by mistake. Change it to 'sdei_hp_state'.

Fixes: d2c48b2387eb ("firmware: arm_sdei: Fix sleep from invalid context BUG")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Reviewed-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20241016084740.183353-1-wangxiongfeng2@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_sdei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 285fe7ad490d1..3e8051fe82965 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -763,7 +763,7 @@ static int sdei_device_freeze(struct device *dev)
 	int err;
 
 	/* unregister private events */
-	cpuhp_remove_state(sdei_entry_point);
+	cpuhp_remove_state(sdei_hp_state);
 
 	err = sdei_unregister_shared();
 	if (err)
-- 
2.43.0



