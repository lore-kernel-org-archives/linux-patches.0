Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3AF2512EB;
	Wed,  5 Mar 2025 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197526; cv=none; b=SS9R6E4OxRnBaUzUy7/OtsxKxX28XD161nsapvh/gH51oB6YoWxcfsAQ9LXMZ92k7Q+KFnOah9qeLhuavGj+oEJTAHfc6nZF5K1oidXn93jKKogW2nnOx5eiCEvjukL/nVnIr2DZ+O80Jdpv2XLBrrQrYdBokQwCCDyAbhylRqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197526; c=relaxed/simple;
	bh=PB6D8/X98Pf64qmCgB6p/1fxDWt97zVOiQPRl0DkIBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ae3SvvXcLMvos87idJH3MabbgB3V15ESf77KI9XuymS7gm0ALX/5mnrp+Oc6lKFzywvLaLRm529lmH7ZxT1i4sjKI6sakcEUp3ud+T1UX3QUXixCtWSZ185Bl2CCpoocu7U6DqOC8oJrYvU4lFDu3bC/K6x31jZr+C/uKXUD7rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1RtXIgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1RtXIgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C12C4CED1;
	Wed,  5 Mar 2025 17:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197525;
	bh=PB6D8/X98Pf64qmCgB6p/1fxDWt97zVOiQPRl0DkIBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1RtXIgNfi79kSiJOr9T6yssWvqNd2pMHP6IfBQ7r5eQZvblQkbenKcURvgMxR/M3
	 TAPJ+aDkcWpUFBPzARkH0a4Dod34LlzHNRjDdZwnPjRfUXl9FvcN9p7IHB6IR4/9Kg
	 Wy7GJxHgwq5oLgrbNnYvFnro/ooPeq4yQlfemjeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/142] RDMA/mana_ib: Allocate PAGE aligned doorbell index
Date: Wed,  5 Mar 2025 18:47:01 +0100
Message-ID: <20250305174500.433019291@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 29b7bb98234cc287cebef9bccf638c2e3f39be71 ]

Allocate a PAGE aligned doorbell index to ensure each process gets a
separate PAGE sized doorbell area space remapped to it in mana_ib_mmap

Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1738751405-15041-1-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 85717482a616e..6fa9b12532997 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -180,7 +180,7 @@ static int mana_gd_allocate_doorbell_page(struct gdma_context *gc,
 
 	req.resource_type = GDMA_RESOURCE_DOORBELL_PAGE;
 	req.num_resources = 1;
-	req.alignment = 1;
+	req.alignment = PAGE_SIZE / MANA_PAGE_SIZE;
 
 	/* Have GDMA start searching from 0 */
 	req.allocated_resources = 0;
-- 
2.39.5



