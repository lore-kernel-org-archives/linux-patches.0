Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA1B47A879;
	Sat, 12 Sep 2026 12:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214970; cv=none; b=Osdxygec0vktPbxezVp9s8g0h+64tHXVl4M9ZG8rEpjlET0ud2mEEafH3X9YSeU5PUu1wqD5jENS7Y9bgYClWJ6LL6pceJ+eTUF5YE5GJ9hbc4fWbTTyZjSiPO3nTRIZ48D8r+i5Cb5N2rvedT0fiF3HWqYr86uwUskNOFpIfUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214970; c=relaxed/simple;
	bh=AmyX0PDNbM3nPL1nzXz6s6NtjW/ADUs+Is3RFPoHnbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G51999QdM0mcMM+SbHtrcEDs16RHAB+CMpKoi9+WaVI0Nn/Xcch/FvTToUpsJoTA2XM0g/CJsZSM9O+cSS/JMIXRBnsPXP6DdlAsneTmzvrM5TBEsPzKWfZTEhqTUjmywUw8HvfbaqMZyCv2Auxd5cxmx6AjaJxOdCFjTNBShiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNxp+BVn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNxp+BVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71141F000FF;
	Sat, 12 Sep 2026 12:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214967;
	bh=s3sLQKoACKHIF63O0l8r+gnck4eCqEDyCcfzwCxvFN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNxp+BVnMAiafDtVoFQugeZtUE4zsZ9hQgFWMqwbZyVUS7RkPLi2NOM8vvPbchQz/
	 fRtLbkvrG+FOlC9qJYxwy5d+5RJj15oQXt5arVLGZXVJWzXlC5XVHr/mZovr5HczDv
	 N9KYw94QTlFr7dFrKC6upE85quxnIYt3TC9CG8KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0436/1376] irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()
Date: Sat, 12 Sep 2026 08:47:42 +0200
Message-ID: <20260912065617.251379789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index da9490dc14b92..7050bf88b87d3 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5638,9 +5638,13 @@ static int __init gic_acpi_parse_madt_its(union acpi_subtable_headers *header,
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



