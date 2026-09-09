Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252914C6803;
	Wed,  9 Sep 2026 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962094; cv=none; b=hqcJXyFQDl63N1Ht8j+s1i67EXMN2lUhNTA0pLDOqM8rWt+vxIEbqlYnZzwDTWZiCuhLiVGx/n4IL6er1ifM8AQjUieW6pK4/oH2ldk126/W6KYS+wACCzorNlkpTl6yuRQxogogRD5IEJ6cwbDCRBL2rhKnwKs6+GNWp9fHZR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962094; c=relaxed/simple;
	bh=Zz2CvZK/3Zj83j5vYqhpQiTyz2Fv43hSDLavK4f5jM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCnQJX2xA6CRvlu8Z16Gua3+3w0dC7BLWsBLR94yjghnkMxj8jJ5UlkJywF+pBBShN+pC78OXCV5SFXg4mVW0NkDWHjr8eQMQ/bhCh6vo/aYi7s6LbDMyoTkyHcfGK9+KxbKdPOqjnuPkJs0chBtdrW1Xh9U5Wio0dp2pZRhhqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXxVt5ib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXxVt5ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761BE1F00A3A;
	Wed,  9 Sep 2026 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962093;
	bh=haJRHPZBmS+1sa9z0GopBRXkNDIMktkB/Mz9/h0T408=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXxVt5ibT3xgeN9nuM4Ib50vGpsUc0zhlLPXYxIVdhUD0Dxjd1LF6Kj9p/rYMmJJa
	 5OP8gcSJOlh6Fj/dxG2UncqbD5jFA+EDFFr8ijqEsmIdMqsTw1KKP5nLNgZQIswCIE
	 2OGBZkKEMIlIY15gyHFBnlg+rUy5igrzcXB9eNcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 130/556] rtc: rzn1: Handle EPROBE_DEFER for optional pps interrupt
Date: Wed,  9 Sep 2026 15:36:50 +0200
Message-ID: <20260909134235.029722364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -464,6 +464,10 @@ static int rzn1_rtc_probe(struct platfor
 	}
 
 	irq = platform_get_irq_byname_optional(pdev, "pps");
+	if (irq == -EPROBE_DEFER) {
+		ret = irq;
+		goto dis_runtime_pm;
+	}
 	if (irq >= 0)
 		ret = devm_request_irq(&pdev->dev, irq, rzn1_rtc_1s_irq, 0, "RZN1 RTC 1s", rtc);
 


