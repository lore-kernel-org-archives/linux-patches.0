Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740C23B42DC;
	Mon, 17 Aug 2026 14:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976909; cv=none; b=qt8c72cRUhR8chwLaI6esN3P9Z5L1yHbDgNrTCgU7loK4cKLGrNKXr9mE/DlWnyJ84ajnISuv13yceEOX0M3142ePoYJSQQitU4isOn1eFKy5i++hQmzjrXxquSwU6BXQOa+RwbOYXebyTMYlSY0g8TE88HhpqtSWD8H/+nMRtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976909; c=relaxed/simple;
	bh=B0GD8jiESdg/TZrdgd/hnoNSUc2cbCd9WyhIlot9rOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fILHRTaoeS22ONGr9/jV/yoKHIv8PRdV5AGXb24ZF8sLin5F3W75GwHlHZ9Pl7K7R8gldV4Z4qGl6FciqAucGyxYN5o7BxCQUWedWixx7jfb4skyc7RtkS3JP9SlrFI560sJE5RY+RrzlfbhS/s4+6S49pg1ria61lJXhebXoxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOsy/8oA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOsy/8oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4F41F000E9;
	Mon, 17 Aug 2026 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976908;
	bh=6T/vIHczgDNO7oj6sAglOrobQRYkDYEMoQqwFm4G6aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOsy/8oAt2la623Q9T2E+qUKhztoVJ/o0cZkwUGNTJvV1Ox4eg/s/RoWCPUXewj0z
	 GeUwYdFxTZFGCbBo9nn3rNfSi2kg1AssDYs+MPrJYBrlfEPP5iIX+28f5Q731PJY9B
	 +S7EaMybZR3YrXn19ewXu/1zDbkBSscenHLnNQaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/456] iommu/intel: Fix out-of-bounds memset in dmar_latency_disable()
Date: Mon, 17 Aug 2026 15:28:17 +0200
Message-ID: <20260817132544.281307726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 700eeb07bda0a0..d7b2818649b818 100644
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



