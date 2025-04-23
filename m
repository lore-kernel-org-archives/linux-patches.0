Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6327929AAF0;
	Wed, 23 Apr 2025 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421789; cv=none; b=T6UlJoGsQzbTLCR+2vGngMH7eDlk/xPiMfdejWfN4VXpLMHy7zjJrVUsmWxej6gsrOQurXMW4Qp5kBYhW7hzrsi0tTULPsvhaTPDI6nuD8Jub+ePviDtyW6kECxQxV98bFNejB/uCmhMGv9Gef7hw+KRPKnN34FeywPPVspK1Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421789; c=relaxed/simple;
	bh=CnSJjSQYh6lN2yi/Y/JyrTSlEv2xWqJNrhLY07P8C/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPvE/qI4rqx35YSaxwMQdc6tt3VMN1yjiyfn1rF0bJIGb6gHgQb2JfB+gk9VhpxE8eFWmJmva5cH90X9NFcL9F3SkJdjrivPmz3HghMohTclxCfHixe4WkuBgVuWK8SD35CCp3hCWIEff+IfAlIxQqUBKDzrC/q9eVsQ99kGAJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1W8Q+5kS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1W8Q+5kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2DDC4CEE2;
	Wed, 23 Apr 2025 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421789;
	bh=CnSJjSQYh6lN2yi/Y/JyrTSlEv2xWqJNrhLY07P8C/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1W8Q+5kSpnWyK9pSwKqVGkzwv6PE0WzJPvtQiVc+JymOAtLrhy3mefyk2rBREue6Z
	 iwaC61C7U3PCLWwAObLGQ6f6N6+8HxDSl7Yclys2OssxaqhXaK0wWFmTq04uzvDCGl
	 zFgVuFfG7RaxQw/7jQaFhMPiP2rg+ZuEAQ9jDPUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 224/393] of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()
Date: Wed, 23 Apr 2025 16:42:00 +0200
Message-ID: <20250423142652.639725557@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 962a2805e47b933876ba0e4c488d9e89ced2dd29 upstream.

In irq_of_parse_and_map(), refcount of device node @oirq.np was got
by successful of_irq_parse_one() invocation, but it does not put the
refcount before return, so causes @oirq.np refcount leakage.

Fix by putting @oirq.np refcount before return.

Fixes: e3873444990d ("of/irq: Move irq_of_parse_and_map() to common code")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-6-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -39,11 +39,15 @@
 unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 {
 	struct of_phandle_args oirq;
+	unsigned int ret;
 
 	if (of_irq_parse_one(dev, index, &oirq))
 		return 0;
 
-	return irq_create_of_mapping(&oirq);
+	ret = irq_create_of_mapping(&oirq);
+	of_node_put(oirq.np);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 


