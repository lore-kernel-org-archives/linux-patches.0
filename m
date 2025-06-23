Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72C9C2E0;
	Mon, 23 Jun 2025 21:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714301; cv=none; b=sLqFJSmEOdt9/ZNar/d2PcIIA387+oMCaaVQhEpafetZFmc+hrsYmUQtb1CxTh08yCknXFjqsQVEgYKrlDwiS56W9OUczHH1aK+q5SAC7pEBEwfBB74U4Ac1OQIarA1Mf2ql9ZifQkeVw6ptlUhESJ7qkDJt/dwSb08LHE0FGVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714301; c=relaxed/simple;
	bh=lZPpmI71g/UchR0G1Q4bqrJB/VA4gKLCwze9QvJ4Qs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GD7yJQGpxZQDHP6l58XM2Iayz6KATPN910MWzzHiLrBIISODfbS+Cltjq9Wmt4fNvF/16lfbtVv//0kY2CM415gjGGnFHvJ6ZtnQ0nMFtmdSm49KwKSOY6P8FeJFnZXhOV9Pu4MiFhM1qXKSW+buiESQxG98kZBWNikpOaxFYa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnwAp7lU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnwAp7lU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC18C4CEEA;
	Mon, 23 Jun 2025 21:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714301;
	bh=lZPpmI71g/UchR0G1Q4bqrJB/VA4gKLCwze9QvJ4Qs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnwAp7lUMb7kg08sEagedyKXTa9Xn1H1verDbrNwPATTxzOPx2G1y4vARCztHhteO
	 xF24WsN/OnKSFi1UTkILkjVJJmt98LjkSxSzsc+4hRZP7Vw5+PluPKfKDSYTPrWAsC
	 330UZiAU/GnFhxALKXJwz5MlB6ZKHbUqYgtGKpbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 382/592] iommu/amd: Ensure GA log notifier callbacks finish running before module unload
Date: Mon, 23 Jun 2025 15:05:40 +0200
Message-ID: <20250623130709.528376775@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 94c721ea03c7078163f41dbaa101ac721ddac329 ]

Synchronize RCU when unregistering KVM's GA log notifier to ensure all
in-flight interrupt handlers complete before KVM-the module is unloaded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250315031048.2374109-1-seanjc@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a05e0eb1729bf..31f8d208dedb7 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1005,6 +1005,14 @@ int amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
 {
 	iommu_ga_log_notifier = notifier;
 
+	/*
+	 * Ensure all in-flight IRQ handlers run to completion before returning
+	 * to the caller, e.g. to ensure module code isn't unloaded while it's
+	 * being executed in the IRQ handler.
+	 */
+	if (!notifier)
+		synchronize_rcu();
+
 	return 0;
 }
 EXPORT_SYMBOL(amd_iommu_register_ga_log_notifier);
-- 
2.39.5



