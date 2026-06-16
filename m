Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4592C46AEE1;
	Tue, 16 Jun 2026 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635930; cv=none; b=sQHF1Gu61zc6rpHS4oLFziWZCx15m0i9Y8+FxuG86VT35SzL9MrRthOQtItN6/yQZIgq1hGDbKlwSjGz/M+dVxBkWdVPMYxidY61OjQZVp/NO6gFfSGMok3+Fc21r6dn0Fw8CTWtf0guGlsA/V5AsEJBO0Bxo58WOCBmhFkbcrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635930; c=relaxed/simple;
	bh=XU0pJOWYSAh+VCFmV6hSwp2aZM0uNrZ9riyJbygAVPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REJA3pgsFepfltmr6gwmyJcO50/COPRp4UWQt/1jo0k6XUuLjRyVw+S1MS0wpCmNi3YellPAXctJuhAflVAfWDmnu5bn0LX4vfZ7LE3aNm19rA0hmItySWLttIRzanEVYwC3vzwIu9v+JtCdnpqeByBDKI5aC95YbZwrLh7IODM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5Cr4nCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5Cr4nCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E041F000E9;
	Tue, 16 Jun 2026 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635928;
	bh=1pDFQa4Fi8BXL1IFXUTIOWbfeF3ORRNOV/2RVN/zIf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5Cr4nCqK4epLX3OM01Pz1R7Lzrgfrgd9oqVt/qiUv7beyJBh3PnYw9HB1R3RAvzu
	 cvbLdvlhkvmbrnsTZj4AzG4jOVcjqfTesQKv9GGTD7hEXresLHgdKaxE1GWJUOOSZy
	 83W+95uNcTpl1qm9vYENMdcc21qJLuPLSPeiXp7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/342] net: garp: fix unsigned integer underflow in garp_pdu_parse_attr
Date: Tue, 16 Jun 2026 20:27:18 +0530
Message-ID: <20260616145054.798107219@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 16e408e607a94b646fb14a2a98422c6877ae4b3c ]

The receive-side GARP attribute parser computes dlen with reversed
operands:

        dlen = sizeof(*ga) - ga->len;

ga->len is the on-wire attribute length and includes the GARP attribute
header. For normal attributes with data, ga->len is larger than
sizeof(*ga), so the subtraction underflows in unsigned arithmetic.

The resulting value is later passed to garp_attr_lookup(), whose length
argument is u8. After truncation, the parsed data length usually no
longer matches the length stored for locally registered attributes, so
received Join/Leave events are ignored. This breaks the GARP receive path
for common attributes, such as GVRP VLAN registration attributes.

Compute the data length as the attribute length minus the header length.

Fixes: eca9ebac651f ("net: Add GARP applicant-only participant")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260527083200.42861-1-zhaoyz24@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/802/garp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/802/garp.c b/net/802/garp.c
index f6012f8e59f005..2c456b362621e6 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -452,7 +452,7 @@ static int garp_pdu_parse_attr(struct garp_applicant *app, struct sk_buff *skb,
 	if (!pskb_may_pull(skb, ga->len))
 		return -1;
 	skb_pull(skb, ga->len);
-	dlen = sizeof(*ga) - ga->len;
+	dlen = ga->len - sizeof(*ga);
 
 	if (attrtype > app->app->maxattr)
 		return 0;
-- 
2.53.0



