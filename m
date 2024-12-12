Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CEE215799;
	Thu, 12 Dec 2024 16:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022281; cv=none; b=bi0CQnGYOYg6Gutf2OQQcdNNQpXr1jDd/agZvm1Pge0vXJnyNH57slcL83FchgvFUae8eLAunA8bHJT8T+QFGxcPAeQ0+nSHPC4FcABYMKJApvvct0jZ7MFttXxHOsMvPKsPRKCSPO6xEaIWbosJp6vkM5WrlJpPy5zg6LoZR6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022281; c=relaxed/simple;
	bh=3lNxiGEJ7KkmRYPElCAU8H1ak7/gmAX5lTyRFb1F6NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knBPDoDgO5y2A0Ws77htj3skYLPB874VpfxaYNJrHtJuJe/jA4i7RQ3MQmOPy6PGKY7/uhPhj90r9zkFPitClrz/UZ8L/67klU1D2PD2aQxt55TCXV1GUYYI/boAdV10zelc9Ml72DtZ1s//xrQp+r9+f5piDExv5HbEAJT7WAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BRso1Ja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BRso1Ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1B8C4CED0;
	Thu, 12 Dec 2024 16:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022280;
	bh=3lNxiGEJ7KkmRYPElCAU8H1ak7/gmAX5lTyRFb1F6NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BRso1JaCRhRqRTZn/eD+dBfLlMAPgFs2avXxjLIhXUaAVL+W6eQHEmKqaGi7axIl
	 4XrfKk6nC/sAGGslIp+uuchghM+sRT/YhLlOPDDoLt50/Yjd87jFz7AdLLa76jTyjR
	 9nIiR5RNgtSTJNXfAk1CPBPJM5aBiMfA3fO2zc5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/565] drm/amdkfd: Fix wrong usage of INIT_WORK()
Date: Thu, 12 Dec 2024 15:56:33 +0100
Message-ID: <20241212144319.315204058@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 21cae8debc6a1d243f64fa82cd1b41cb612b5c61 ]

In kfd_procfs_show(), the sdma_activity_work_handler is a local variable
and the sdma_activity_work_handler.sdma_activity_work should initialize
with INIT_WORK_ONSTACK() instead of INIT_WORK().

Fixes: 32cb59f31362 ("drm/amdkfd: Track SDMA utilization per process")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 7f69031f2b61a..49810642bc2b8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -311,8 +311,8 @@ static ssize_t kfd_procfs_show(struct kobject *kobj, struct attribute *attr,
 							      attr_sdma);
 		struct kfd_sdma_activity_handler_workarea sdma_activity_work_handler;
 
-		INIT_WORK(&sdma_activity_work_handler.sdma_activity_work,
-					kfd_sdma_activity_worker);
+		INIT_WORK_ONSTACK(&sdma_activity_work_handler.sdma_activity_work,
+				  kfd_sdma_activity_worker);
 
 		sdma_activity_work_handler.pdd = pdd;
 		sdma_activity_work_handler.sdma_activity_counter = 0;
@@ -320,6 +320,7 @@ static ssize_t kfd_procfs_show(struct kobject *kobj, struct attribute *attr,
 		schedule_work(&sdma_activity_work_handler.sdma_activity_work);
 
 		flush_work(&sdma_activity_work_handler.sdma_activity_work);
+		destroy_work_on_stack(&sdma_activity_work_handler.sdma_activity_work);
 
 		return snprintf(buffer, PAGE_SIZE, "%llu\n",
 				(sdma_activity_work_handler.sdma_activity_counter)/
-- 
2.43.0



