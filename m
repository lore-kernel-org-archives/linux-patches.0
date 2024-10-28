Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9935D18CC1F;
	Mon, 28 Oct 2024 06:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096877; cv=none; b=p7enoInx2YfUGOPCKF2h95a43uJfNkgW24LL+ZcfsKfjcD+++FLACc6CC33i83iKVTPRHO1cDKpt6UmmgJVBVohNmdsUaWriyelj3L1UHnj7UZK/s66ikatThFDWK8coGwhB6IpwEJNKGIr+kNog8UL8v6kHtYfBDw9aHpChipw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096877; c=relaxed/simple;
	bh=bch3WT1tTx7/aXJf8d58MioK1pQML/+tYvCWPXbkQQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgdkvr20C8akvzrlt6OhOpjcWaRbIsXyVOtq0qxSguGAFP1Xi+OGfjmYoRKGIK1ABWxjaMzLMrkD/NtncD7Vwzg0LY1sj4tfR9LXoqCYrgm1zlukA1NR+wiIKO60OEYrpAeuVFTn5hlojTx50tyOdpqlRLZ83LKQLk9kZhLUmhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE764crO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE764crO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A57C4CEC3;
	Mon, 28 Oct 2024 06:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096877;
	bh=bch3WT1tTx7/aXJf8d58MioK1pQML/+tYvCWPXbkQQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE764crOEBPo/ewf/jrSBHCRaIyKf6wZazKjwxPeYa9JgRbQYlqAirFbsOPi9mczi
	 ttzHAdaiotI1gOj7f7Wqo7kMFmYF77QeHUjHIAMu+qOJoArsqjkyPcPcFtKD6tZXMh
	 MH9XFgh6jj29TjimbSp3xCwLyCwjeyKgEb0q6U/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/80] scsi: target: core: Fix null-ptr-deref in target_alloc_device()
Date: Mon, 28 Oct 2024 07:25:05 +0100
Message-ID: <20241028062253.329173186@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit fca6caeb4a61d240f031914413fcc69534f6dc03 ]

There is a null-ptr-deref issue reported by KASAN:

BUG: KASAN: null-ptr-deref in target_alloc_device+0xbc4/0xbe0 [target_core_mod]
...
 kasan_report+0xb9/0xf0
 target_alloc_device+0xbc4/0xbe0 [target_core_mod]
 core_dev_setup_virtual_lun0+0xef/0x1f0 [target_core_mod]
 target_core_init_configfs+0x205/0x420 [target_core_mod]
 do_one_initcall+0xdd/0x4e0
...
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

In target_alloc_device(), if allocing memory for dev queues fails, then
dev will be freed by dev->transport->free_device(), but dev->transport
is not initialized at that time, which will lead to a null pointer
reference problem.

Fixing this bug by freeing dev with hba->backend->ops->free_device().

Fixes: 1526d9f10c61 ("scsi: target: Make state_list per CPU")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20241011113444.40749-1-wanghai38@huawei.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index d4185c1bed8a8..1fcac654cfaa4 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -724,7 +724,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
 	if (!dev->queues) {
-		dev->transport->free_device(dev);
+		hba->backend->ops->free_device(dev);
 		return NULL;
 	}
 
-- 
2.43.0



