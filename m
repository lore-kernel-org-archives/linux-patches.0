Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D283A3C3F4C;
	Thu, 30 Jul 2026 14:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421883; cv=none; b=Bzi6CEERb6RQHTlQi6hXs9c9folS+GCOx7p8JIaVTpOoUTFwlU8S1XwQYqjU309u1gS9q8cIZisI8Z7RwL13TVAJ1BepSN5TElhPdv/cKKTaAYnJq54K1evnot7nfMAXEO3wqqUUancGUJ7qir00I8CbMxYwqWuEvE7FRRRKYPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421883; c=relaxed/simple;
	bh=7prQEPtWI59oT5oppAMe/BqLCOPMmn6EZN89q3I0FSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXVMiBD1RtamQGuDEGfBK8siFRDbreiGa+hVbjfAcFsO/+oSEjwEYp/mIgbJPfGwoydil2vKH32hPaSi4OTgGVvv4PSe07/0ZY58LIu0tbogvDZ3+B/SS2J52VvDg118ql/ZJb+TfNl5nxASaObWaQpD4/sMtsML5wYHq505LPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7O9mCJz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7O9mCJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394DF1F000E9;
	Thu, 30 Jul 2026 14:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421882;
	bh=QRvuoBO/kNo7uaYrt/bIalaOdFrj3Aqsuh28nEheJsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7O9mCJzbbNSwrcYm/dWhR7Rnm99QiWAUm2s7HneZDFDzysSssFkPELS0bl2H0Inc
	 i8ZDDKYNXJy4f6w9e4/a8dn3J4SLkD5o5x6EXR0vBY6JuUkJ/t3kCXHVYmqXeiLdP5
	 zWfjckasJMgWXAgj34F9ixi50HZbVPswK8w46fas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 251/744] iommu/intel: Fix out-of-bounds memset in dmar_latency_disable()
Date: Thu, 30 Jul 2026 16:08:44 +0200
Message-ID: <20260730141449.628221404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 02168f2f20a43f..bec98dcbb9ecae 100644
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



