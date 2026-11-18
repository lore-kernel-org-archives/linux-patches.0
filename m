Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050851;
	b=mPOREmCfRTTgcC5yWAqLo4Q7GlhFd4sTWfyyY4cwbjhyqWYp2V3NY8ihV0Ms7EZZjlTW
	 4Cx72vwWHbsy31ELa2FQF4KfgiLiNoi6OYnFIu9lYDL0IBCrCXeHCAsmXjVhn/Vlox1pq
	 SU2K4koFDQxkHVFIwC5WheGkeQffF4/JXQHO/i1aEEL9mDbazqLK3x/AF6DwEXCuqveEd
	 BKfKSS/zDEtWiWE6ccOsylRg30h7s8IcYoIxeyMMgBWm5iYIrNsH+OPTW3Qy3eV5M1XWO
	 Z11eflAkbaPoF2lMNhE1COWPD1bxWOdWIdAVjBnP5DsgdHciWR0mKCiwZPwDznFGn2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=93lsrmm63T6yW1F7Bkl2AJ9Pt8VrZdWAvqAzG2wDHec=;
	b=bIp30pwCyhrFUcwoHlfOY3riiKTfBElD0Dl8dUX3OQWzUBSrMbhqp2OgTYvZ8Kol8/Fc
	 JqqggKPiHKrmQ5A79KzVVbq3Ehyne5WB0P7ypBvCp7vmHs+CGxcBPyyB0GCrobs/wBd3/
	 1JRrcCxIR+2zucxJN15xBULfe4Db81/UW1ZxNyd9xOHkDCDT9XjVXcjAeQ6K/7BHlhXhk
	 3U5TxeAdlb1LeNDutrYefiRpgUMjThLWHmXLkOV3qpy+vJSZAOypet0EzWtnDLcjbTXkv
	 nF+hq1CVkFDq2jYQ5WHuki4uaNkWzSLBBhkqtuBp1HkZdHmYnTiXymAlWGUwKaTOJNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAs+xVTO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C932606A320;
	Thu, 19 Nov 2026 01:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAs+xVTO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C7A1F000C4;
	Thu, 19 Nov 2026 01:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050851;
	bh=93lsrmm63T6yW1F7Bkl2AJ9Pt8VrZdWAvqAzG2wDHec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAs+xVTOMNJllIRZA+n+Kapsv/IiS8FgSX9v6ruEk0an559k6c7GaNkd/IAnvpxMg
	 +2qsAVeci6fD9MOq2q/4ojuQ+9FlpUwll8XENoy4HBfCP5uxo1UpXRK7aAXDU2pTTR
	 +NW8CnCjF3P67GDTH88fixJFUE/BRHy4iYMBI4E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>
Subject: [PATCH 6.1 2856/2857] irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()
Date: Wed, 18 Nov 2026 16:04:50 +0100
Message-ID: <20261118150344.412689136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5623,9 +5623,13 @@ static int __init gic_acpi_parse_madt_it
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


