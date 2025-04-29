Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025CD24503E;
	Tue, 29 Apr 2025 17:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947713; cv=none; b=R5gexr5fW8QanuUAqr4YjNr51+MgObQ0yrpukhyhRK8KPQg8XdvXcIwZLP/k0E4W8Q9f/GclE81ALhOpBxGRTaL21CF1ToeDKFGdioGiBneb7a9VNL3FlWJJI+DVWojtPlPlZ9KhilU+02WUJdrAoNoKfzd77oCCpDVpP0R10r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947713; c=relaxed/simple;
	bh=PbqOQNLQW39Ukz/LPlP5AZMcEC3ap+wKTUofykBZDuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSRZjhcWufpHfZHmi28HDTJQLYEArtP0/y/E7rerGKoTrwUGsbngyBjTZoYtaO+UYqSGpYUZnta0huFdKmEitUKNg0osemSBo8qPUFeMHNEosXM32vLPdgicVLHI1srtVmcRhQSgCdGInjAZySrUALNXag4gSd/0zYwSwZPuUgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7YJjEI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7YJjEI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0A3C4CEE9;
	Tue, 29 Apr 2025 17:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947712;
	bh=PbqOQNLQW39Ukz/LPlP5AZMcEC3ap+wKTUofykBZDuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7YJjEI+j3HZXv+6qi7IoUdJlVfeRDQIFUdhKLqZARfbweSeMtDdNYsXYzphlJZY/
	 oGpExooz1OYT05HsT818R0vr4qJM/CpYHQK8V7Vu5Mpd91a4BuXqQU6NZou1OU2UFc
	 4XYdBz9jQJUmYd8UvM80v5EaN79X8/mOWUiPdW0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/280] iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE
Date: Tue, 29 Apr 2025 18:40:24 +0200
Message-ID: <20250429161118.508827952@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 07172206a26dcf3f0bf7c3ecaadd4242b008ea54 ]

Return -EINVAL instead of success if amd_ir_set_vcpu_affinity() is
invoked without use_vapic; lying to KVM about whether or not the IRTE was
configured to post IRQs is all kinds of bad.

Fixes: d98de49a53e4 ("iommu/amd: Enable vAPIC interrupt remapping mode by default")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250404193923.1413163-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a24a97a2c6469..f61e48f237324 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3660,7 +3660,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 	 * we should not modify the IRTE
 	 */
 	if (!dev_data || !dev_data->use_vapic)
-		return 0;
+		return -EINVAL;
 
 	ir_data->cfg = irqd_cfg(data);
 	pi_data->ir_data = ir_data;
-- 
2.39.5



