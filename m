Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D423934250E;
	Sat, 12 Sep 2026 19:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239943; cv=none; b=ii9fpolzPcO26TdVHOqT6OpQhPWV0cUzH5le/DeBpMWKNBvJIb1MhNipb1rGU9AozHII/SymX9NQX39tdvOG9PxozTZQt+xscQKjIi/+Uf9zN9gKNQ6UZtPMI+IQs52ZvXmmvDM2JOWz7dOz3QHjRJVJscd4GWNL47HphXEkIeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239943; c=relaxed/simple;
	bh=2aJjZeN9RqPyH3pWmS/tgw+E6e1fBw2p3m1fXVtEtJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzOhgVSGEKy5LRaerPAsLWkSCOqT9bbXSWyOuyT8FnlIftmVWDRVe7tKjnhJadyXm3vCh6ukLk7cQTbWabuxqkuZ/ZdbsHiSCPMFKuf5Fhkif+0LI3m/K2m655t5g6qf5LJQU22oZA2xtg9/OM8GOAB1uhXt3qKUAa6hbuCgfHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTg6ftt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTg6ftt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528F21F000FF;
	Sat, 12 Sep 2026 19:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239942;
	bh=2GJXHvkwq9rpVPA6YGG2JwLDaQkCI7ZL8+KzBSGEIEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTg6ftt39lN4BfPc9StLXtmXCiL7ksD81u2QnNExQYLgkO4OV/yA7eDZpVK4kVPAI
	 lvZGSdTejCcq+Gc1NN096VX+ENmh6q0+FHVE1HF3tZVSmF4UxbiEMIJlnYqR3ZGe1r
	 AAVXFOH+MLi7kgYT2Q8NsrKBUZPnGCtwZccahlBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 724/935] arm64: hibernate: Restore DAIF state on error
Date: Sat, 12 Sep 2026 09:02:34 +0200
Message-ID: <20260912065543.439052631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 541549827889d0380fd73f8aacb5de6ef7a5a1ac ]

Sashiko AI has reported that if swsusp_mte_save_tags() for some reason
fails we return from swsusp_arch_suspend() with DAIF being masked -
that is not what we'd expect. Restore the saved DAIF state before
returning from the error path.

Fixes: ee11f332af96 ("arm64: mte: Save tags when hibernating")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hibernate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 4c7f97b7da1a4..d61a22cb89787 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -374,8 +374,10 @@ int swsusp_arch_suspend(void)
 		crash_prepare_suspend();
 
 		ret = swsusp_mte_save_tags();
-		if (ret)
+		if (ret) {
+			local_daif_restore(flags);
 			return ret;
+		}
 
 		sleep_cpu = smp_processor_id();
 		ret = swsusp_save();
-- 
2.53.0



