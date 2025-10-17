Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5373C330B10;
	Fri, 17 Oct 2025 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715467; cv=none; b=J5QXdY1UK7MBf4U/Ff4lLS9jh58HRdzPIQ8AQ6aejfy31JYPDNATbhc4syG30cepC5NOXHUz4G8J7zWxDnf5pfbq3wnYfni5eevzB1d8AO96gihCTA3ud2AeN/QM4b9jVgUvVt7kcWV+e+bsfU8rqDdnSCHrLIvOqqVkCJUGvzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715467; c=relaxed/simple;
	bh=rXoC1t9Ki6FevNmG1ZTotz+LBUHHiUTRvUbETT0R/+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0Mc0Gc4gTxpK3PWFt9aLMYs63EBOKlZAEjniNqTBhDaDUuKWLmexlAUCpUkm5CNMcwcZ5dEHAiM+hTnF68hYFGf2C84tM5+wVGo8B/dUt6YCsnuE5EVtJ1lJiRMLRhMY5DD6Wu5wRkyHGQ60a6bI6Nuh8k0CANOs3P7d4hXOto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bo0U73g3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bo0U73g3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0A5C4CEE7;
	Fri, 17 Oct 2025 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715467;
	bh=rXoC1t9Ki6FevNmG1ZTotz+LBUHHiUTRvUbETT0R/+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bo0U73g3rGE5Rkm8Sw6jM61F8R/e0uWqcZAQLsgZcEjSVg4A2w32/iu2EXu14Us7e
	 AdfgxQMcvhlwNhHZdHy4r9Ws/SAIeFEU0klOUuZgazTAmqv0UymYFamXGGqsmvgKo/
	 1ipRyEh5RyJWr0Vuj2LX4tgmykTmsfTR7JTW6IB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH 6.17 199/371] cdx: Fix device node reference leak in cdx_msi_domain_init
Date: Fri, 17 Oct 2025 16:52:54 +0200
Message-ID: <20251017145209.125674566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 76254bc489d39dae9a3427f0984fe64213d20548 upstream.

Add missing of_node_put() call to release
the device node reference obtained via of_parse_phandle().

Fixes: 0e439ba38e61 ("cdx: add MSI support for CDX bus")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Nipun Gupta <nipun.gupta@amd.com>
Link: https://lore.kernel.org/r/20250902084933.2418264-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdx/cdx_msi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cdx/cdx_msi.c
+++ b/drivers/cdx/cdx_msi.c
@@ -174,6 +174,7 @@ struct irq_domain *cdx_msi_domain_init(s
 	}
 
 	parent = irq_find_matching_fwnode(of_fwnode_handle(parent_node), DOMAIN_BUS_NEXUS);
+	of_node_put(parent_node);
 	if (!parent || !msi_get_domain_info(parent)) {
 		dev_err(dev, "unable to locate ITS domain\n");
 		return NULL;


