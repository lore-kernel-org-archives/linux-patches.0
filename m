Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7CC1865EB;
	Mon, 23 Dec 2024 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970559; cv=none; b=j54JgbRWyBGXpFyKTS909jtanv7FrhjXQBHso5GBUO3eF16YKsaTUUMeFzy06KGUb8Tlw6WqLmMkSvE46Fczcfn0mKbQUXTh9awb3abi01qbMBLtKtr5a4+0saPS8UXUjrEHJMr0NZY0YpsiCuvO9fdIf3zU/M+8b5p3wwjhCS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970559; c=relaxed/simple;
	bh=tCs2QTdFlBnGlcjaZ/C4nCfmyMkxl5yDYCYq0hIJZ1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFsbstSB2Zb0kkX1lNzBy6tmH4rkNbTq6jzGDswcpE2GDv6z6a1FXzQALXBS3oVBwR3z4RFqGj+tTeqc1TlFItEqPq/B7Iej6TKKNbVNB69vgw/oSXlyG6xs02lxd08YVpF3WCvKDvKoSxDOLWeNXQuiHn0Q7KXdFU9R/ZDWP3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S43ohEro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S43ohEro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15132C4CED3;
	Mon, 23 Dec 2024 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970559;
	bh=tCs2QTdFlBnGlcjaZ/C4nCfmyMkxl5yDYCYq0hIJZ1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S43ohErojOpAFKFLmmO2SK+9CvHyfBsHrhrUcvU5Kbty6WnUolksIKwuc8gAaRHJi
	 Q8BpblFYRBm6+OezRC5+LhcD6m2JdvLtAQjb+j0s9hVQbOKNaZaGckrUSXpcSp3a16
	 DWOE8xYv+0Blor/MGR7k1K7R3f8dbpXz4YAXiQmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 100/116] of/irq: Fix interrupt-map cell length check in of_irq_parse_imap_parent()
Date: Mon, 23 Dec 2024 16:59:30 +0100
Message-ID: <20241223155403.447783249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit fec3edc47d5cfc2dd296a5141df887bf567944db upstream.

On a malformed interrupt-map property which is shorter than expected by
1 cell, we may read bogus data past the end of the property instead of
returning an error in of_irq_parse_imap_parent().

Decrement the remaining length when skipping over the interrupt parent
phandle cell.

Fixes: 935df1bd40d4 ("of/irq: Factor out parsing of interrupt-map parent phandle+args from of_irq_parse_raw()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241209-of_irq_fix-v1-1-782f1419c8a1@quicinc.com
[rh: reword commit msg]
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -111,6 +111,7 @@ const __be32 *of_irq_parse_imap_parent(c
 	else
 		np = of_find_node_by_phandle(be32_to_cpup(imap));
 	imap++;
+	len--;
 
 	/* Check if not found */
 	if (!np) {


