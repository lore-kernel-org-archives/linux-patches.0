Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6208743F0B0;
	Thu, 30 Jul 2026 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425790; cv=none; b=sz+D1Nv6BZ4lH0iEzZXri9qE/j1nU02KUDyGt3O0SdtqluW79rFsbSiibza5n1bVQ7qPi3DaExtfi6bpTYJ7FkshVdYTiAN/PZaplrgYba5HM/yly0Tcn+FsXtwagCH6V78kE4Jy+9JLag7NnqJ2ESYmsTUUWvs+zTmpCvmvRng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425790; c=relaxed/simple;
	bh=ZTQ9ky1oU8/GG20SP4MrkudZ3RwldIpOQ6tbMqohaAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6CnZvzZ9jVsV7LgW9f4gtvOOH1yqzFQQSqqH8QQvoKX+m6i7aLx4rEp2iBrJTlVBkvybbDWrd27o9bB87G4kFtNsG/qaexugt3H2Qsu3o+ohLd/smAhIcYuR9Ssq0XueA40W4QiVNHeTIAlNcmQVp6hDZJPPF7ZjEtLZ1/QO78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKFi3HcW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKFi3HcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0FB1F000E9;
	Thu, 30 Jul 2026 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425789;
	bh=QIyE0/t/otV/j+WFXAHVJ+TECLYNXzPSf9enIumEDxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKFi3HcW/3umhhXsNFgT+UK0RnhoZt2EFsb9XiTVyQUpepe1pG/3sRSlqYDdRlL90
	 HsAEFMQxj7BhQ3o7FkPK6+HGkswwIq2aUp9sbXZj/mauzXwRp5317EHElThbUxi+rG
	 uHoQ8Nltwu0wnRL20PZdQi9aVByH4dVBrnDl5rSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/602] iommu/intel: Fix out-of-bounds memset in dmar_latency_disable()
Date: Thu, 30 Jul 2026 16:09:37 +0200
Message-ID: <20260730141439.848557828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 754f8efe45f87e3a9c6871b645b2f9d46d1b407b ]

dmar_latency_disable() intends to zero out only the single
latency_statistic entry for the given type, but the memset size was
computed as sizeof(*lstat) * DMAR_LATENCY_NUM, which clears the entire
array starting from &lstat[type].

When type > 0, this writes beyond the end of the allocated array,
corrupting adjacent memory.

Fix by using sizeof(*lstat) to clear only the target entry.

Fixes: 55ee5e67a59a ("iommu/vt-d: Add common code for dmar latency performance monitors")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/perf.c b/drivers/iommu/intel/perf.c
index dceeadc3ee7cdd..6afb55073e9f10 100644
--- a/drivers/iommu/intel/perf.c
+++ b/drivers/iommu/intel/perf.c
@@ -63,7 +63,7 @@ void dmar_latency_disable(struct intel_iommu *iommu, enum latency_type type)
 		return;
 
 	spin_lock_irqsave(&latency_lock, flags);
-	memset(&lstat[type], 0, sizeof(*lstat) * DMAR_LATENCY_NUM);
+	memset(&lstat[type], 0, sizeof(*lstat));
 	spin_unlock_irqrestore(&latency_lock, flags);
 }
 
-- 
2.53.0



