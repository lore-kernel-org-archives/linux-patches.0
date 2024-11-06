Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C691DF98C;
	Wed,  6 Nov 2024 12:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895786; cv=none; b=i79f2rCqA74hSrYhdKBUSJGPagDM/lmLc2FM89A1y/uOgxjLSHAXtFthGOQvKn9JxP8nBocnmM0T4OLfOLElJ/cqiyMTjMfPBwfmvhIiFGY4dGfvsc9HI46WYUPjDuK13GIJHvjvRp3MKW+rUJlWvR6FQpqy3jLyVL+Fqh7L3n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895786; c=relaxed/simple;
	bh=fxYRA4BLwXm/3d3x5J0pAFBZz2vRy36rmPAewEt0rys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPnZDH/StiPVzm8gBem13z78lhQPbLl2LB+2mJqAVjQ0K5P3ZvtjyvlMwTwMFR/aNmXbM4Z+mrsSwtA2ieVdR5ZnCOsjRPoXwGErdUbU3FIvONha54ZNID/pkZKcjuCjSXf3i1NRubsKS3FVCJdLixYIpl3R/J7QYoiE4ojKdWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANFouyYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANFouyYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C578CC4CED3;
	Wed,  6 Nov 2024 12:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895786;
	bh=fxYRA4BLwXm/3d3x5J0pAFBZz2vRy36rmPAewEt0rys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANFouyYhmhZ3qptbYWw+LDy1my8I89uSglEoXwPwzFEZCJDy16SSR49AK5QqdBBdF
	 GFPHJL9AtKD0r3hqSf6Upd5x+mjrRO/LZiq6myq0GxY64kmYv89ySfx6wAUylZfaNi
	 8xNejU18/9LFGr9pIM0Y5QAdU6z6i6RhFi56GKtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 336/350] firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()
Date: Wed,  6 Nov 2024 13:04:24 +0100
Message-ID: <20241106120329.010768126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ea2c2bdcf4f7f..eb99a02e51141 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -800,7 +800,7 @@ static int sdei_device_freeze(struct device *dev)
 	int err;
 
 	/* unregister private events */
-	cpuhp_remove_state(sdei_entry_point);
+	cpuhp_remove_state(sdei_hp_state);
 
 	err = sdei_unregister_shared();
 	if (err)
-- 
2.43.0



