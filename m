Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CBD3B9D8F;
	Mon, 23 Mar 2026 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274392; cv=none; b=FSOfYMSDv2i6D/lcO9vDevwgtVE6BuHIJhLQLNVevExsSMHPoJeNYH/ahWJM6tZSxERr/Clf0k6CfylubzGmB+1PZszvWNgDvhygpVs2Wi11OtCP9XDdrX7pHKxbXbZ0behn6BLKL/ETDGEC0mbQDy4GCKxgwK+vwZTy+3ac/TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274392; c=relaxed/simple;
	bh=x0+1FWgBQoB60MM7o5dSB/Ut5c3DqL2IRwA2XeURWCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEtriAN9tmjcmBXfroJWlQGI8kxhr1CVIPOL4ZYa7nBZ3YPS8a279MbUqni64ZT2BFb8io95hfF7e5pmBseBPE33GhVlJzsCngumhSa+8sIjPbj0A6W8ihiHbsJylk5ibYB59M6Rf/faMuWahtXWiQKNEb2eLkInIcNW7ZbdosE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1t9w0JMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1t9w0JMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC701C2BCB1;
	Mon, 23 Mar 2026 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274392;
	bh=x0+1FWgBQoB60MM7o5dSB/Ut5c3DqL2IRwA2XeURWCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1t9w0JMpcmwK/ipwkVaHAhY4JLB9CofquQ1Lwx8JYJo0Q8cw8VbXpBQP07ituVdtr
	 Dd/II0BkAo5B4Xtd55Io8KMoYSBmWjUb23HxwhTZGhDhrdRVRzLZnrX/lpP1337DS0
	 owGCXzd6/TKJfiwtmMhjPCqS0IjfX/XMawmasUEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 202/220] mshv: Fix use-after-free in mshv_map_user_memory error path
Date: Mon, 23 Mar 2026 14:46:19 +0100
Message-ID: <20260323134510.953520770@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit 6922db250422a0dfee34de322f86b7a73d713d33 ]

In the error path of mshv_map_user_memory(), calling vfree() directly on
the region leaves the MMU notifier registered. When userspace later unmaps
the memory, the notifier fires and accesses the freed region, causing a
use-after-free and potential kernel panic.

Replace vfree() with mshv_partition_put() to properly unregister
the MMU notifier before freeing the region.

Fixes: b9a66cd5ccbb9 ("mshv: Add support for movable memory regions")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_root_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index d3e8a66443ad6..45cf086ad430d 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -1334,7 +1334,7 @@ mshv_map_user_memory(struct mshv_partition *partition,
 	return 0;
 
 errout:
-	vfree(region);
+	mshv_region_put(region);
 	return ret;
 }
 
-- 
2.51.0



