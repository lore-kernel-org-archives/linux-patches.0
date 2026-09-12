Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E831B10B;
	Sat, 12 Sep 2026 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222862; cv=none; b=d6oRWz6obpuGmYwmEp7uGsYjfT1y+SQ7q1/RRE4Hw8kjQ4R3mPu6azU93uSToBUrW6y9byK298jx3Fg9o6Cuk5Tc5lTZjm/Hm5uf0U956Zl36fgd41MGPx2UkAvAqIFa+YRmi8PQgOd+8chRd2JhBF/OL4e+DDplV6SitMvvn6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222862; c=relaxed/simple;
	bh=DME7m89qbOhiqD3A0TyJuKHLdfU9p4kFFAN17aMyCss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYadCmZp15ruTkbf13GNh8wEbLvJsGsiUKiJVkk+cX3YHwdswtZmu8jAaUpE5XV2VMVV+nL8ggAXyd2eTJGzIhxzHYH1s2yTuFQ3Ppc4vwvP0m1seu/sCmt+x3UR+WVv0ZFJ5Of2krRp/dwOzWvO03XJZzzKkH1HCg8/xqgdXVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjOuRXHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjOuRXHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95E61F00893;
	Sat, 12 Sep 2026 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222861;
	bh=510kf3+hSpOwByVUsRS3CQnSfV1leCg9JjepN/nWKvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjOuRXHhjyVDNRfwZL+HtL8nodXLu4Mh4rwUNO4jOXzxXjKa3qyVltsKMsYlBTSSD
	 ygs78K+zvn/3k1aHQUuei0vLzVQET/dFJ8q/jg5sx2JTkNypqTXTcELWwtqKsro9pE
	 hvWZpxSIu/uKszyljG4o6sSxnTR1leb18GyxHI08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0670/1424] irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()
Date: Sat, 12 Sep 2026 08:51:42 +0200
Message-ID: <20260912065622.300962515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8160557c1acd4..b79a018f79dc1 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5586,9 +5586,13 @@ static int __init gic_acpi_parse_madt_its(union acpi_subtable_headers *header,
 	}
 
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



