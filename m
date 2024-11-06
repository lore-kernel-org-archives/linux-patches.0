Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F410A1DE2CF;
	Wed,  6 Nov 2024 13:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899187; cv=none; b=OMdC0GGS1jWdYss8LP6uhwC9ZumB2xOfIMUjLqJMHVpzROGb6Z9Jd/Rw2fzamW8i6dO3B3xzkVSONFUp/GAMqb2uhF2v//vQqPkxAAgjQGiVjm3CUd0m5lqOz0tnNWEVnYq4Vv9WSVb8HDDm7vAPv5b77a1Ke2NMa3922oF0YrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899187; c=relaxed/simple;
	bh=aQFSvQ4Sk7jlyFs/hPyQ1NRMb049S6GUQ4J3Vjk8odM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Awv2zzpkMVQKe5DY9qZHMV+kS06u1q9pKPxnorMPIJZYuxERfz7bS7H6/TPPSzOkjprTt6rkyCxMYWv06MrxrTEaUcjS9cYvu/c0prK3H4uwvybimN4JPN/IqOWZuk/mxmauro5lsSqU59D24joytX6qOoh9wDNKsgtJILR6VvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nie2tWZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nie2tWZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DA5C4CECD;
	Wed,  6 Nov 2024 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899186;
	bh=aQFSvQ4Sk7jlyFs/hPyQ1NRMb049S6GUQ4J3Vjk8odM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nie2tWZjthQh2areH/35v4ITokZMpsyV+x6FqhvVnZNQuj9x3AgkOnl38rhp+7VJF
	 ssAmbo07vD/YusQaUR96wY4bgf2XHk2VwWirKOnJCbhgSvPkYVSxf6CiK4DT8CP2+M
	 uHl0j71yqJchE2riNFmLt/QAv9Zj82oUood1XpuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/73] firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()
Date: Wed,  6 Nov 2024 13:05:32 +0100
Message-ID: <20241106120300.803820641@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



