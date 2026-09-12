Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35054BEE32;
	Sat, 12 Sep 2026 11:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211838; cv=none; b=SG6ovSxxZ3fRi5Od9AiFFYoZkG6qGWu2IH9ZTWYdTAvWvgTzoJ60wAzEjL/xYGA1qRFtoOx8cpQ7SKDZrIt4oOq2fEL9e3n0AI5owWVXdqDgmKbEV4UrTxB3zgV6po4V9z1mWj0oxZxabnVlbUXIWre6fZtTRwA1w2ihsKMeXdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211838; c=relaxed/simple;
	bh=c8UfEB9eP2W8R+x8RFcg7dSN24yCQ6PMTIGEsVIUkDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixE8BpqcL9vBINumsaAS0JsJtkGGcyBxDX6fMIjyU4oisii54Zyh0Fb8okCXZ7cM14hjXE5mdsEeVJHUamEHsDJ/tfZdbmI2wEdJvcM1MNTz1n7imcg7smmj9ugpjIRVJJB9yHqqPG9VYKottA/x5gn9Wfi21bfltV04f+aN/nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXRmNN/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXRmNN/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49E51F000FF;
	Sat, 12 Sep 2026 11:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211836;
	bh=4wZNNF0Qfo8aVxvdhi4KJ+DQx4nllbd2JGnw8FDAGto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXRmNN/RCd9z7O5ct2zMwtPPNqcc76wlgEIlnAoUed9zhkq+MzrI2DB2ihIwh42p7
	 n2jWjNMyqrxw9jQfR1pT1W2phdWc26W8+UTHJ1KYHIhyFK8whc2MZryMvXpA8id/9q
	 ToJe4JgVp/REY49fvdaX6qMAQV/IgTB39XT3kEHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1313/1518] irqchip/gic-v5: Check for NULL LPI domain on domain teardown
Date: Sat, 12 Sep 2026 08:58:02 +0200
Message-ID: <20260912065653.228352234@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit aa079dbf4c2598c2613a0e464efcb2c232753c51 ]

In gicv5_free_lpi_domain() the LPI domain being freed can be NULL.

Check it and return before trying to free it if it is.

Fixes: 0f0101325876 ("irqchip/gic-v5: Add GICv5 LPI/IPI support")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://sashiko.dev/#/message/20260810104747.E5CE71F000E9%40smtp.kernel.org
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-2-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index a04dd56652027..a4997b3235b08 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -811,6 +811,9 @@ void __init gicv5_init_lpi_domain(void)
 
 void __init gicv5_free_lpi_domain(void)
 {
+	if (!gicv5_global_data.lpi_domain)
+		return;
+
 	irq_domain_remove(gicv5_global_data.lpi_domain);
 	gicv5_global_data.lpi_domain = NULL;
 }
-- 
2.53.0



