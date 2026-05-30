Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E573148DA;
	Sat, 30 May 2026 17:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161117; cv=none; b=Li5+YNiv0FEIn0elbyjRLNqAkOdtMH3mZQJatBfPqyOmdWs3ykHhavtP00Hav1YxppGhMj+lUimqBGjVwqfTlpTLkV0Rb5ONTXJxS/ulSPgSM4HE5QpCGwg5sHYuUji2KadWlKTB8xgagLHo4Rg9DnODzLckeyDEuFNbdu6QM3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161117; c=relaxed/simple;
	bh=EPW5fgzJ0zXtsfBJsIeMSMPUWA5JbjOHl4F7v3PrQ6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qye/uSuAMhKvtzdQMc553wRvOHHYRUQYqKxcAhIdjnIJXrMMvNKhPLEQ1rA0yEicKibbl4yMFf+G3dMMAl5mTRPhc3GIG5cM7ms/Qv1ChdW5GknaRAiSK3CdPiIWYr8XQHtU4gNNR8zGmuhc5HpJxJgGmV0XmBvfWQaGaPoOkJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aa45h4zu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aa45h4zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143D51F00893;
	Sat, 30 May 2026 17:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161116;
	bh=ivpjZPYDPb2lawo4SQjwxuudGvXMoivrYN/N7njLjMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aa45h4zu9IO31zV5HguZD0TxQM56rbqB0pQYuM31TpvgHX8/yD1eDI3LjRgvvJrIe
	 1mXYVeP2Fm97aqep/AIuFgAq8tF5br7okOz135EU9yDk1eFTdFtwzfrEXvKCqnNz5U
	 xcgt1m/CbA56D9R1FAuTJ7R4S/I8LZFE3hb7LrWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 529/969] pmdomain: ti: omap_prm: Fix a reference leak on device node
Date: Sat, 30 May 2026 18:00:53 +0200
Message-ID: <20260530160314.967692213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit 44c28e1c52764fef6dd1c1ada3a248728812e67f ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In omap_prm_domain_attach_dev, it does not release the reference.

Fixes: 58cbff023bfa ("soc: ti: omap-prm: Add basic power domain support")
Signed-off-by: Felix Gu <gu_0233@qq.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/omap_prm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
index 33ef58195955d..1a85ae3507691 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -652,6 +652,7 @@ static int omap_prm_domain_attach_dev(struct generic_pm_domain *domain,
 	if (pd_args.args_count != 0)
 		dev_warn(dev, "%s: unusupported #power-domain-cells: %i\n",
 			 prmd->pd.name, pd_args.args_count);
+	of_node_put(pd_args.np);
 
 	genpd_data = dev_gpd_data(dev);
 	genpd_data->data = NULL;
-- 
2.53.0



