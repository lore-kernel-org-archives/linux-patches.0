Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057059;
	b=MgN0xDdd6R8RAnMHN/Q7b2M7MZS2m8f1Krp3NbsIW8gXuXVRQdeoLqlsDSbp/Nr54lHh
	 6dMHApYziX01WSK+8ZAbSKKQg1jT/ZwL7eX+cAtHGLtvITuvYrkR1sQS835piYiaYrptF
	 Aex60TXSO5iu1hMEX7jpeBY7pyws4RwXwgKeWQWwQKAXdOkLYD5p/POfQ4X2xvHjgASh2
	 Lw6vkFyANC+G8cNdNEMwZdprXkDyMTSw3OZwTBg2qc5fqmnkVrwxjAyY7c/Jfghhl7obk
	 O/NKsfgWy0Br16RPCS1+XuUDgIb5XGHd+bKPvTQbZBebsgv+IVFYHAVS43ufKY9jPGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GuGmbwNSxXn1QzTMD7kscFut3J3xkDwqipeujD+o7Aw=;
	b=wHSoYwZ3zMb4m/Nf/hFOVF/UixuMFs0zNNuBYh1XrsWZVQ8LOYGkjT9FVw4vljmq83L/
	 up9uRsjywdj2TArlUdoFSRlV4PVzcT4vv3QLM36waley5pol7+zV1idYLYMB2gwxrWe1H
	 +/mBK21NPsuasgPCXYVk0sCgMxAHEID07bxiRaPzsrp98Hkdt01y+pInMTIwuhGhcRyA4
	 XIccUwaelJP4LjfT1BtbgRKBbsotycLKPgNFF0xCRD3r5T9KTJXANudFs0zFjws5qQ8nf
	 E4RqC2dnmLnILXsp1nfFPMtfZvMq4hMb0tzhwsrfn1keBC0Tsg6gl2q1DSJaZPzdObw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OFj/md3B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FE1606A31C;
	Thu, 19 Nov 2026 02:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OFj/md3B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3581F000C4;
	Thu, 19 Nov 2026 02:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057058;
	bh=GuGmbwNSxXn1QzTMD7kscFut3J3xkDwqipeujD+o7Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFj/md3BTVBhcCkw9vn/R7Vhbmy+WLIGuJ/hwnyst91+xoQDzrC4YpzmtYZwoFnw0
	 s4hdhELMoNpOaXWRigSaRjVOtxOGjfBjvUnoAPMfXUsGBktB0C7Ucla0VsSGglHjkc
	 Mwtaee4Bv0psAinzea8KeO12TqVxPzoikeWRzfgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>
Subject: [PATCH 5.15 2207/2214] irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()
Date: Wed, 18 Nov 2026 16:04:43 +0100
Message-ID: <20261118150138.552900459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 698a8648ca8051d34722b09b8a8088c741120ac3 upstream.

Fix its node leak when its_probe_one() failed in
gic_acpi_parse_madt_its().

Fixes: 9585a495ac936 ("irqchip/gic-v3-its: Split allocation from initialisation of its_node")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260702033050.1583-3-shikemeng@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5627,9 +5627,13 @@ static int __init gic_acpi_parse_madt_it
 	}
 
 	err = its_probe_one(its);
-	if (!err)
-		return 0;
+	if (err)
+		goto probe_err;
 
+	return 0;
+
+probe_err:
+	its_node_destroy(its);
 node_err:
 	iort_deregister_domain_token(its_entry->translation_id);
 dom_err:


