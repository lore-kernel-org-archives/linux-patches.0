Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C64554B1C6;
	Wed,  9 Sep 2026 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963466; cv=none; b=ksSDnlLwbXk90+AX5kyueGm+OyDXXvavXy8aaCVOf96ZmGDKHNecyejquwN+xiqflhj+tBGrK6dN96xp9bV8c2wlTPlmWooYjPg3Mi5aDLn++zrZyO17hv/dLeyVfTJkCsp+EywHEvLtHBNK6+fKJnJgH3NdxikpMJvJSUx2yf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963466; c=relaxed/simple;
	bh=0d0X0mFH2XRwW5EUCaCwQxdpl783X0NzaRoHGXW2K9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dl81fsohBn0GxxcFTabPMKHh3YnKuWdRunhqUe7JFKU/wXawCho3RwrTldee2VaOnQhwFTKhPFxoN4d0nw3wGj/+BB7uxyOQXoj3rcntdMqBPgU/2T5eym918x0gC6hr6syMseRUKf6/1cUec+Sw2f35K+CpZvZZHlQ2KgTwHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10tPBOxe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10tPBOxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04871F00A3A;
	Wed,  9 Sep 2026 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963465;
	bh=2FC3v4DYeCi7cxZo9lE338DnvyuRVIEAtI3qZeZX6Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10tPBOxe2u2nTk1CjM2/l1jUcfaReyQlstG/vju7aMFvuWE/+PlWCHdADqBwKL2N4
	 rx6RkTAU1HOStDrTnoIYOEb69uaNFt0IYOe3mGHVA7j9kS/1YL1/55XAAAJ2EUPM5b
	 hWy7Vzzy5Esn+Kukho14MlN2gUQumIiWpcGoZbFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 089/583] rtc: rzn1: Handle EPROBE_DEFER for optional pps interrupt
Date: Wed,  9 Sep 2026 15:36:14 +0200
Message-ID: <20260909134241.209622592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit 708546aa39560a11cf44c7ba99492c8395a6c2fb upstream.

Check for -EPROBE_DEFER from platform_get_irq_byname_optional() and handle
the deferred probe request properly.

Although the "pps" interrupt is optional, an error code of -EPROBE_DEFER
indicates that the interrupt subsystem is not yet ready. Intercept this
specific error condition, assign it to the return value, and jump to the
dis_runtime_pm label to avoid ignoring a valid probe deferral.

Fixes: eea7791e00f33 ("rtc: rzn1: implement one-second accuracy for alarms")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20260821211032.13554-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-rzn1.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/rtc/rtc-rzn1.c
+++ b/drivers/rtc/rtc-rzn1.c
@@ -465,6 +465,10 @@ static int rzn1_rtc_probe(struct platfor
 	}
 
 	irq = platform_get_irq_byname_optional(pdev, "pps");
+	if (irq == -EPROBE_DEFER) {
+		ret = irq;
+		goto dis_runtime_pm;
+	}
 	if (irq >= 0)
 		ret = devm_request_irq(&pdev->dev, irq, rzn1_rtc_1s_irq, 0, "RZN1 RTC 1s", rtc);
 


