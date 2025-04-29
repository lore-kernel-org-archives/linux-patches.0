Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B363127453;
	Tue, 29 Apr 2025 17:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946866; cv=none; b=qlevXTmKcBN02rfajFAeVtQxi5WvXWuSK0nzcub15yJWHTu7W2iQnFJAnetlAsLaVqj1wIKN+ldTvkVfHEvu1su+7OEfa134ga1QIv2mtk8rMex8HsCLHEjxJQH/8WCRq/meT+DQnfgYSq41oVH2Cb9Sk+rfRB1trbWPGobVtlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946866; c=relaxed/simple;
	bh=ttGup0R1wAu+9pFI/tJKEj1hLbXWmcF35AJ10nG9NG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2dL4AbvkgBkfi5YZztS1zSElwFjlL+hKgcCGyyKyC4zj51fgs0jBmFDVgNF45A/cxnkIPUy6jeokJvYCPsUzQosmQxqE67atzZa9ke4kHjCxvD+l8Wr76dCWBU3h2lbmofvZCSxIn8wDrtsuZtNy4cB0VpfsG2WqmOsFJcoFwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqXKvtOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqXKvtOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC365C4CEE3;
	Tue, 29 Apr 2025 17:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946866;
	bh=ttGup0R1wAu+9pFI/tJKEj1hLbXWmcF35AJ10nG9NG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqXKvtOu/aua1E21dnJGMBDDOpTJstKht08pay+4V2wCf1aCuN5h+mwHte5jOQWVV
	 p+DMJiJOiSc9yskwfG6IXflGGeL9Mp7rthnH87RIO4j5ZgZ9uZGUIWK4Yc4tC1fb9F
	 Gq0OxFPjnSf03QLBj3Jcg/g2VDik4Pd3CGYXLsQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 093/286] of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()
Date: Tue, 29 Apr 2025 18:39:57 +0200
Message-ID: <20250429161111.680517296@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


