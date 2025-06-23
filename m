Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4234315A;
	Mon, 23 Jun 2025 21:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714929; cv=none; b=NrcXxOZ4Ipk4R26jMIPXwekbUN0+/MbVOV1SlokK8xnlXSNDHPvn8dVeZFg7luHIkt5rgsFTc2SzM4sMThUfL9Q/Bazg7UgmPB1J2wNz9IKZV/Ys4cBeQ6Bp60Ziu90iQe/WB9acKTplqYgMajs84VYcc1lc4joWdisfEbJLo3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714929; c=relaxed/simple;
	bh=PLwdwgWSE4ctemOaWl9CO3KzkLbNOB9DA4fgl/ialWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFeHSFyU3d2bM/tn3yShSsNnkr1oN4otQ+GbYXuSlzfN8/jw6gdsGn+zwaUNLJEa+9rV+pc1GGcJyVSn/tCM6YSmCHctB0qmPMcwDhOBWGX06uwMCoRScHrLn2S94u8fC8YA6dsqWoQyc1Pc+G5oRqd2hcUYDxkRSzs8+3ksGEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Th01mgP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Th01mgP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF3FC4CEEA;
	Mon, 23 Jun 2025 21:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714928;
	bh=PLwdwgWSE4ctemOaWl9CO3KzkLbNOB9DA4fgl/ialWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Th01mgP93qhH0IeDsSo55MKuRD5v2LFQpAPURldLhzjBz0A03yqLhFxXXstsZxs8n
	 9NJ72+1IxraDxKKSNocmx7HbaBfVzZ50gmPPAByBwHFwyZjaVfBcQjA0cgIZ3HdYTd
	 iiaz81kQcGGDGdAXq0EsCT1WZNcujJgNL8U+gixg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/290] iommu/amd: Ensure GA log notifier callbacks finish running before module unload
Date: Mon, 23 Jun 2025 15:07:10 +0200
Message-ID: <20250623130631.974962608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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
index 83c5d786686d0..a5d6d786dba52 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -780,6 +780,14 @@ int amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
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



