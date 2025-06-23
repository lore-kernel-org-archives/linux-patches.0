Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03D115ADB4;
	Mon, 23 Jun 2025 22:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717394; cv=none; b=Mo1B2+KgH5EDePe5YctVgezNg3jSBAJCvzVEt63jLWPgoz8O+9CqYoLG2I0DIaQxP25RR2CcyYtZ+XHKluDB1fKS1K0bkDVQU+0KDpmwPHyMeDwWTiwwJjOf0mEgZQvgsFz7k3fcoG2KAoEQI3gNPx7bQoAJyYDQEPxF9iupkqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717394; c=relaxed/simple;
	bh=EkmIAZXVfu34XsEjL+mNsbRQ3gcos+cLoLhTZoPmbFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iX2FVwNPPdhnL6MEK+c6rdtfK5lxoF6LwHhSVLPgBTAE7UOHpHaqTZH+oPpBtsGyrfW4OSlNTvgpgKgBoqxEzw8RizdZCz3u+FXbRclY6S1SuY4F7XEVLADmJRFmsF+wwAWhDvLEPpD1bhG1N9/xfa9AMB5A8uQz2w16GspdhuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2gFrax2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2gFrax2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EE0C4CEEA;
	Mon, 23 Jun 2025 22:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717394;
	bh=EkmIAZXVfu34XsEjL+mNsbRQ3gcos+cLoLhTZoPmbFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2gFrax2Fy5FrK+M1GyderY3zZ2Dea3aLLRvfa/yGKiwn4ptXNgX2Zf8sy0Rd5M84
	 Ur7LRd+PS4D+ggArimIUElLd0r6PZwmzXPfOQwm70mIBoctkOkCPC8uFtkUSG7MCEJ
	 lwAPOXuTM54Wtnmw37xrtufKXWUWVamY9r7mwVHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 418/508] iommu/amd: Ensure GA log notifier callbacks finish running before module unload
Date: Mon, 23 Jun 2025 15:07:43 +0200
Message-ID: <20250623130655.486338172@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4421b464947b8..b778023388715 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -770,6 +770,14 @@ int amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
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



