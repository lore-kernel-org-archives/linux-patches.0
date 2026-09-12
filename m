Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5B72BDC0E;
	Sat, 12 Sep 2026 07:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197779; cv=none; b=b4SXaQl0gI3jgum7Bg5nzZlwenizcMvY8DFkYcgQ34KQp8BWN0Cny0LFtJCu8XQO5EV1HKvUqrFu/Wz7nXsBKLN25LG6lJFH/DoExi3r+2xhAPTW2qdF3qxEqIeGMb63uABc2Y9/4drNvT85wk+6x5YT9s/9PtGRAL5q0QgOmjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197779; c=relaxed/simple;
	bh=Sm5oyjoztT8Ud+WxyJeNu5blPL8Hxbon5dl1HnGWr9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geVazoz39wd5bP9EWUx+3scVYEXYFxAO8MQNZIfkdmTTJikQSXUKsBh0n1eHbejlsPJzKuTGBXMU/Ywwdep7ve0XjwTHzgb42ryH4J7jWUg6VYnn8u2dGu4gxoCHvA4yUK+v4CfI/MkfWT8AYOjQo5wB5A0x0xfO9UPuepFxwN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXRU/xva; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXRU/xva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1A51F000FF;
	Sat, 12 Sep 2026 07:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197778;
	bh=IiJIv+IXcX03ZeBhE/R1L1j8Mq22COLDMu5JBSwOqxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXRU/xvaDAiryVANfcJkd6E47LU/8nqK0fBYgGlqq1nBl4l4OwgbV056zL81V1fZn
	 UlVoXGJUx6kqNxqJ7wViB1xl2Diy7LgsiP4C1uDF5UKOEF8TUpGvtJKxAF3a7C19+e
	 U9B7BbksjyFML4JUFnOC7sI3CwqXZSCDZ/9UgfnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0245/1815] irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()
Date: Sat, 12 Sep 2026 08:33:15 +0200
Message-ID: <20260912065654.738853849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7298e8d71867f..439dad40cef4f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5741,9 +5741,13 @@ static int __init gic_acpi_parse_madt_its(union acpi_subtable_headers *header,
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



