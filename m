Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC98D246798;
	Tue, 21 Oct 2025 19:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076756; cv=none; b=CEP+dw1qO52Tm7TbRP4TQcYGqSVpxI52Gz7I6XGBFsx5HoYMKCKYSRJJ32XZSu/clU91+s2RbTHoaAqmBA3QvTmw9rr184hIuL6dg+iFsJu+q5nZ1ytULrOe4wZhSJNMVifzsTr5l3voJiNxcQiNz5nZd0BRbeDlU9wjdMGddMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076756; c=relaxed/simple;
	bh=M/wl4SaaWCirOOPq3Qe4RbpshXGbamFmIHnjZMMTiUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC4yseEgT9LKqxH+g4ivbu+XzN2J2+zv06i3PgSQYT+WbbQDoAkEZM1jRS6haszvJyHZsQO7CwjuUm3/z77rhNB8At5SGNzqpMoAQgeKTDAgviruyaBOVRoGn1aUikCOT2LLCNXBrM1ioKlrtlozQ31irLueF4X9XxHPdtjvpg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuCf2AjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuCf2AjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CA5C4CEF1;
	Tue, 21 Oct 2025 19:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076756;
	bh=M/wl4SaaWCirOOPq3Qe4RbpshXGbamFmIHnjZMMTiUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuCf2AjVmrz31qq+CDV5C8UppMWmVxrpfIZZARHPkfCMRBnSkOtizMjYnWNg6io6H
	 Cfc3a73GDWabMAcrC0fid0Ke0hDNECLiUJaBQpB80Xl5eogvPyhkxERNIQoTKmFx1R
	 DPIScQ5B3S0jQINCzLfws9x6V19m49rm367i4dXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/136] cdx: Fix device node reference leak in cdx_msi_domain_init
Date: Tue, 21 Oct 2025 21:50:16 +0200
Message-ID: <20251021195036.651485083@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 76254bc489d39dae9a3427f0984fe64213d20548 ]

Add missing of_node_put() call to release
the device node reference obtained via of_parse_phandle().

Fixes: 0e439ba38e61 ("cdx: add MSI support for CDX bus")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Nipun Gupta <nipun.gupta@amd.com>
Link: https://lore.kernel.org/r/20250902084933.2418264-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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


