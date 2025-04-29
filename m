Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0994525485C;
	Tue, 29 Apr 2025 18:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950779; cv=none; b=Y5GOIesCjIMmBzCBF6fLfeFuSrc9tJpkFQwdpipmP3W6+QEnkt8ZA/jVqK68kSpjqVNsm9X/4XnMm06RwIZzZZmr1iasyaEzMQkzbwrqxodUeHZUToSod8KvNqPxXu3+AYseS7IKUD1Y7qbywW7IhBQ808lWkY+bBsjoT2V6x+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950779; c=relaxed/simple;
	bh=8futKKL2/6BQXdCjmlF73DkbwKZYy1ZTIwtL9uKUFF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsR7Ckar+d9ad5pLsEQsA0HGnAI/yv5OPse5IWi2Gk2R5DFuvUXRF2jL5SbkmVGle7GKuF2V28oB6su2/KgytABMWUJk/FQwXcFLnKjcF2yKKLYyVkY8Hs22D65TO4F+TQnSJfoba4VDxdrPtNxOLi1Nbev5I9TwTbAPLx/dpP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5yAMo7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5yAMo7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60148C4CEEA;
	Tue, 29 Apr 2025 18:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950778;
	bh=8futKKL2/6BQXdCjmlF73DkbwKZYy1ZTIwtL9uKUFF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5yAMo7Cw3itlh0WVpY1XxURP8oV1lQK2ZWHB48zDN7rOWsa+U8F6O7GJSv4IU/aw
	 tlm+d7C3O8jYUvkWbrFvKzNOo9pf1AWv6TsynMiTUz1EwD45jLH2ZesyqboDPzqdXX
	 LyRJWFM7psTMUZjGvUOtl/t00iyKDTbLsVBlGKgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Srikanth Aithal <sraithal@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 6.6 202/204] nvme: fixup scan failure for non-ANA multipath controllers
Date: Tue, 29 Apr 2025 18:44:50 +0200
Message-ID: <20250429161107.644248146@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

commit 26d7fb4fd4ca1180e2fa96587dea544563b4962a upstream.

Commit 62baf70c3274 caused the ANA log page to be re-read, even on
controllers that do not support ANA.  While this should generally
harmless, some controllers hang on the unsupported log page and
never finish probing.

Fixes: 62baf70c3274 ("nvme: re-read ANA log page after ns scan completes")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Srikanth Aithal <sraithal@amd.com>
[hch: more detailed commit message]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3977,7 +3977,7 @@ static void nvme_scan_work(struct work_s
 	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
 		nvme_queue_scan(ctrl);
 #ifdef CONFIG_NVME_MULTIPATH
-	else
+	else if (ctrl->ana_log_buf)
 		/* Re-read the ANA log page to not miss updates */
 		queue_work(nvme_wq, &ctrl->ana_work);
 #endif


