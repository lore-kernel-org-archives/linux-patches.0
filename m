Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028F83FE348;
	Sat, 12 Sep 2026 09:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206599; cv=none; b=TfasiOsESjwAZ3sSQW4gO7ZmkWuhv1NG62yxeXZi4ATE7CznQsuLca23eusyuwXtNd1jRDzqk9sz24VGKfMth0ooPWyfEy2cMAySs8vvROKiBIFtxPZl5GDdYlkks0a44849lgsR+JGxIefjYHhdKDhBZETM6qS908WfqeXZLHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206599; c=relaxed/simple;
	bh=K3wCbz0OqyBoRPRHxhi9nVVbL9h4UkdKNgKZ5gQ2bxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qw14u1Ady7LJqmRHg/QcmDmEmWQwkk4qGQ6zCG5H3nNfRVqNlGTfLT0jmsTCgZ3DynflWVxsE+7h8R/ga2zZwRxbntycNG5i2vAObhD1dtJMN2YQD38pB1g3ntAKbbtQSFoabj7FhsgV1/MAhzmYaT906JeWE+/KA80vEbNKXak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qd+kkl/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qd+kkl/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DA21F000FF;
	Sat, 12 Sep 2026 09:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206597;
	bh=R87NsRmmpMUxGM6wiEY06ASqGopNK5DsItDuHbTuFMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qd+kkl/gwb28ZZ+rr57+uVJDJ1eMVaKmUt5KEG5SWbr78sD0xdlWL+QMlgjTPIiUk
	 RyZfBjgvBWFz3aU9QUfF6kiaO/9XlJiJ9a/3tAE3I1QUnHPwxn65vY5NIGBz/QPGCn
	 fHeuHIxeo2M2UWKXaoPz+GhqgYscANYrBCIAOBPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0241/1518] irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()
Date: Sat, 12 Sep 2026 08:40:10 +0200
Message-ID: <20260912065628.933831653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 698a8648ca8051d34722b09b8a8088c741120ac3 ]

Fix its node leak when its_probe_one() failed in
gic_acpi_parse_madt_its().

Fixes: 9585a495ac936 ("irqchip/gic-v3-its: Split allocation from initialisation of its_node")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260702033050.1583-3-shikemeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index fb67456e301e4..627b708c96264 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5744,9 +5744,13 @@ static int __init gic_acpi_parse_madt_its(union acpi_subtable_headers *header,
 		its->flags |= ITS_FLAGS_FORCE_NON_SHAREABLE;
 
 	err = its_probe_one(its);
-	if (!err)
-		return 0;
+	if (err)
+		goto probe_err;
+
+	return 0;
 
+probe_err:
+	its_node_destroy(its);
 node_err:
 	iort_deregister_domain_token(its_entry->translation_id);
 dom_err:
-- 
2.53.0



