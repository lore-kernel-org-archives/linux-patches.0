Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1746376A0B;
	Thu, 30 Jul 2026 16:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427400; cv=none; b=EEM7cFLcm89jSwvF21+PdLF+MnAOR2dvjz58Y93tzneXAiEYYGlKpV+I0W0VYY1/jgnMjjdT4h2g5XphJv4aGNODxcQbDFSUFk2jj45wVMfd/0rmS90689xPzd+eRkyIA9JlPpin5bFuRN7UHVeUVyBcTFmLuKHc25fjBsNjD3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427400; c=relaxed/simple;
	bh=L3B6gQSTVvKA1yzF5ENsh/aRu7KJ5PIvYNhtR0Rra7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1/+kvqjz6ASiJo+m814XaocoNoujaZDTJNrQOFmKWwF7jBD/enI2Ce55uET3D4KaGk/JNBrU/Y/uynzNCxcj6hY4SlWhyCMVbWV1O9jj6ItqkPLzWPcu+oaMgkPdS2y3y2chM3AFKHz0V6bPTc9YCW7j5C3b9NoRWr6T77HGEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzUtQWC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzUtQWC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6211F00A3A;
	Thu, 30 Jul 2026 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427399;
	bh=FMEW+goAeJbbCSOCuX0A3Aw8Yw24lONi3tE341SDLBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzUtQWC+FvPbkHguIQ4MOHyOw3gJSxPaPlxwrvzni3gPCNctwbEiJYolVPKvYUD0Z
	 acDyJ2sl+ZiDiyn+s30tytB+cWi4v0rmO4yibdNV7DUb7F/2OfSvJpqV1ipbns+TYP
	 JE5sVD3IEVTiq3wsSk93CP2jxQB87dRvwNuX+HJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/484] iommu/intel: Fix out-of-bounds memset in dmar_latency_disable()
Date: Thu, 30 Jul 2026 16:10:54 +0200
Message-ID: <20260730141426.876444409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ae64e1123f2571..08ffebdbd09cec 100644
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



