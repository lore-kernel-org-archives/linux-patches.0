Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A92246326;
	Tue, 29 Apr 2025 16:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945332; cv=none; b=nxDJtTYI1jmmfAi85WfRZen3ZfwxhV6vXoe/MFU9PiKoBpAeEiJX60jEoNc29YzxC7i3/PH/L+Y/4L5I4UcR7uwE6e1mxejXdHgyfLY93rqf9KBKQvd4cDpaMhtVlwT85ahvrhWeBcKM1e6RZfCCicPoSEt397VhfrOTh0y0NL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945332; c=relaxed/simple;
	bh=aCbNNRZN4cC9JA8g1h1wShvqWwBCn0/RyhkY7Zdl49c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHgAvqHOHx0a6mKZ+dGM6y8Vb3iaXF2Vzdh4G0PEDEyAn8zMNvfWgMUzB0l49DIG4zMUsTLfD6F3uFmV7Ew9OUE1PL7TKFBCp2slpBm8rYlXCyn+6Ui8ezuqzqPeLYB5aozNz3oD3ahE3Q7mRmpWCUYSAEEggRDArthBfs1V0Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4JB67fS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4JB67fS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9D5C4CEEA;
	Tue, 29 Apr 2025 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945331;
	bh=aCbNNRZN4cC9JA8g1h1wShvqWwBCn0/RyhkY7Zdl49c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4JB67fSqz021nbvGQOGK1+tNI35L0EjX9YIRvC5Mpi5KF0/Nm8eQ0BSpCUqyARGC
	 V/2zYCdX9xaehxyALiVHpSRXGYo6BxgU5MwDUJ5/BDKxqf49KVWn9T6obdcybCIyjk
	 sZlU13L2AGTiRczJkuJpPZ7iHcQEEYKzvu7bwk6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.4 076/179] of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()
Date: Tue, 29 Apr 2025 18:40:17 +0200
Message-ID: <20250429161052.488466337@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -36,11 +36,15 @@
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
 


