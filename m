Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F886218580;
	Mon, 23 Jun 2025 22:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716412; cv=none; b=cLqj2fkVbsdl9Bt+BgJPFAH4cXkQ68ZivGO1jZaGfOGcMC2dGq7MRlmRa9+quMRcMVgt7pQZg+DRVK/egYkJE7c7Vy2llmMbJ6wxUYRMHpokqofs6nmhHfw2u6uOpgJMLm7hOoFiO5C3/zezRhYa1O2lUgvx5Mr7eSGwVcmLhSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716412; c=relaxed/simple;
	bh=gY9n7KAw6PvB1DtNHWQ9VeIlJEb5lpLl0UGegSmE+H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMTghoquaf+svGlO/jby/RAAza5klyBead7nn0eDxaP/PN3BdJya42nSmPM41c3fXxaTrt5LykXT3l3NUThErdYtH0p/LPo/aT+LZXUP23MxA2ll2NZmls6Zg1HcH+MrgMP3gRIzbDUnq10TbRyV5ui6TcvkYd2rgitfkECYYBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6hzksoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6hzksoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB31AC4CEEA;
	Mon, 23 Jun 2025 22:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716412;
	bh=gY9n7KAw6PvB1DtNHWQ9VeIlJEb5lpLl0UGegSmE+H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6hzksozvWqdnV0lPqvh9d45v4CLMtr+Cky+g6lCBpjPz4Af5n4oAhtT7C87+//25
	 xEWnOkcnO/qZst0vjKIW06uIPpz4AehMxnAehGpjbZUE/bc/l2FYw0PUTFeex6+0yj
	 rQWq28jIIe7dKcNypaQCMjji1yX9WWRTIEsCjc9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/411] iommu/amd: Ensure GA log notifier callbacks finish running before module unload
Date: Mon, 23 Jun 2025 15:07:51 +0200
Message-ID: <20250623130641.874225490@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7d38cc5c04e68..714c78bf69db0 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -679,6 +679,14 @@ int amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
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



