Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EC72248B0;
	Mon, 23 Jun 2025 21:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715326; cv=none; b=haXdWlLhcwTFWEE1ha25lguUI0BqRIngDschhT+vZMgBEl5jftEpBRx2XX5cSNGZyny27IPEO9a0XrMJNFHMbfJrVN4G7/Lt1OOG+JFfuTlzYlxXneiz+7E7vhlfjpvJoaFH351fzcTkiEfPQw0M2oN37PdOna+BGHtUcR1ViCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715326; c=relaxed/simple;
	bh=UDdOv/MaeoXgA3xu1Gdkl39TWqqngjOTDGCNZ8B/Vz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeMh3Zn3zp8+4YAFowQxuA4RYSJ3ZwGDPsnVDn+gmSnNose5QFUn6GCVbmTttcT1Wyq5Sst2RmVFH7tMXfSH1tQf52XOlqEZN8fULBy7iacTOj6rcwv/x8ieS1qeXjmpuPzf48G57JBZc3VEqbcAdf0nAtTvrZ/XciEG/gMoeUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBmUnlM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBmUnlM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680F2C4CEF1;
	Mon, 23 Jun 2025 21:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715326;
	bh=UDdOv/MaeoXgA3xu1Gdkl39TWqqngjOTDGCNZ8B/Vz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBmUnlM/zxeZXyJ/IX5mqDkgJWWQZmDv7bXPw2Kni8wji49JXIbh8WFa1MG35XpxA
	 D6tTnu/rpLpvCcDADJe07KaztL3pWgp57jxWjLhB6DRKBdBxykuzU35rpLQUfKrT21
	 aE3QrSwbZ4/8nww+548uz2mfi87sOvhq0vHsFDFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/355] iommu/amd: Ensure GA log notifier callbacks finish running before module unload
Date: Mon, 23 Jun 2025 15:07:49 +0200
Message-ID: <20250623130634.812604035@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a9a3f9c649c7e..334303b1d27bb 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -750,6 +750,14 @@ int amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
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



