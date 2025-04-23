Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0861E281357;
	Wed, 23 Apr 2025 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421579; cv=none; b=BHC5Fd02YacTrLHuNfqb+dkF7oW9QgiBpcZi/Y4/aBjGmw2CqaTt7CDzOeRSHWF2d/0OsvVsCVFCD5wcXrblz8mOhxsm+yFo9MJmvOms8/j0KgC1epwufQKWCeLI4j+PTGeYgJI6mtM2Jg2tT1Rkq9WE5Ztpq23VowVuJOu5j0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421579; c=relaxed/simple;
	bh=nfxRI2bqKIPMREsQPc7k/vwihcvHWE7BkssUeFfLwo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgfusrG/ZkndKyf0KcoDY+1/V1wAuJWN5daGqdY1V189g7vcjEYReJIGPM1G9K/N/Cq03d7LIsxyQA0VC7l+S7THPZd4mE7YbW7z4S7hWJAWg/lSvSU//oUbJQLhJV4YAapJ1289raNY8XYPWOUJ7m4aApMgbxzD/wfQajYLLPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAr4SGhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAr4SGhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE12C4CEE2;
	Wed, 23 Apr 2025 15:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421578;
	bh=nfxRI2bqKIPMREsQPc7k/vwihcvHWE7BkssUeFfLwo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAr4SGhyn8J+Z8K+rItKftP8pUayZb3jb5/EQTAlohQTFsAwZiV/NUy87LaRLQQxQ
	 kArqBdppGtu/zxe5fs9TNe38aHJC+dLYELOq8AtXPQsPCQ0HPjyT5PuBfrJHdsaFDb
	 VxrQn1Owd4P+ppY3k7sxqTv+MTLJ1SfWZ4MnopJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 154/291] of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()
Date: Wed, 23 Apr 2025 16:42:23 +0200
Message-ID: <20250423142630.684887330@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


