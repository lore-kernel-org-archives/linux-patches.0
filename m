Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2B82EEE85;
	Mon, 17 Aug 2026 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979168; cv=none; b=Y+5dLKAlgTyZ6n+vAA0cY3uUs5fuVXWURZzupZA+79XpeQScPKV+/DP3b9aYmEcjHzykwG4MWnmHzBtRFvGvfENJ1lFNcXTgHK8OXD2z4K4FauD8lEF21lWMVobZBMVtUnsZSXw1+peXPdqZqpDz5huWmhmwhR8yAelfVf+spKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979168; c=relaxed/simple;
	bh=p79x/5uAGnbAEvpQ/sTod6iW964Mnk1smrXDmq0rk+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dassLcQTTL3WpFZfZV5j74tuI56eEfFvsxJDFBZr4mwGwWoMbMGNERoNl9J3eXiAV/R0rA+qGgEl3e8MKV+epfgUxb/JEZrv7b333B0W5bCvBIwlaAfaax/lJTqQ08Np39bJ6qZ34uwqZ6u2fQ70n5mvjJoWSLTJCFdG4MAi08U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhCWwtsC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhCWwtsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43EA1F000E9;
	Mon, 17 Aug 2026 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979167;
	bh=WQVARaIEiBvkkc9xNDlp3b3oe0L9Qg7Vuxd/oze+h9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhCWwtsCW+IZ+hnvv/7xTkDLXV6stU3nF6rHitosHeb0xPYWcL8CyV14gK87tV2VD
	 r+DFTBkMBCqjBqktXPg/TDI2BhDnk2Suf12RDwRoQZ2hKshfvHKF0IpDYeM8OOSLFr
	 xl3wu0QxJ2q0y/FaQ70xWlGT3l8ZAwwnNkprnHYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/609] iommu/intel: Fix out-of-bounds memset in dmar_latency_disable()
Date: Mon, 17 Aug 2026 15:27:08 +0200
Message-ID: <20260817132548.331597629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



