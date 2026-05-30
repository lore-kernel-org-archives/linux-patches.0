Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83EE340A6F;
	Sat, 30 May 2026 18:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164477; cv=none; b=IEBWQHFl3AZFSCrM0Y5Y1PTUWTFfddETwm3Hjat02VXhLP08U030QFdklS97mpu3NFrgwWZq6d1yr8Ca0Q4j+vOO38LKSaHv834JsVQvJJ6GmI0q3UFZqABNOcMQI8F6AWHpWMvfgYzzq93ITcSjNDBn2pTsXK3O98DdGSymNQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164477; c=relaxed/simple;
	bh=k8Ce2JzHxTQZ/MC4Ob3bXP5OV/61Wn/Vfs9ip3g21fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJcTfQcCN9PB4pyo999Y9sa3Jc4PbEumrFoXdVe+n8NXnb+HJCjqOlNPOHlKQrNoEAD6naOsuwahYas1B68ETDzM1q0218S5GmkKwDoyF1s9X30dHyU+Fkqvdvus0dXDTV53aCQDKhVm+ZZWF61i93fDeouwNdCI+3WB/NrxsWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZN1Mo3Q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZN1Mo3Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FEE1F00893;
	Sat, 30 May 2026 18:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164476;
	bh=zQZzK1p8S81CdEU3kVYKfjZiL+3YmxFCkjolzYpkRmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZN1Mo3Q7ILvT8Q3OFR/iYoe58xPbE5+1B2+ANL6EWPc+ZnXY8zlIq1ITr7KLVw10T
	 ON0H+NwAg8WQ2k2RjJPVkvlIeqR7rnVBWwRJwGjXg5VuNhzl3481QWLLPMj3uGK21I
	 RhGJ1Or3wdAo1GQgfZ4nOLzd091VTHYO9od5p+/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Sukholitko <boris.sukholitko@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 567/776] dissector: do not set invalid PPP protocol
Date: Sat, 30 May 2026 18:04:41 +0200
Message-ID: <20260530160254.771576024@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Sukholitko <boris.sukholitko@broadcom.com>

[ Upstream commit 2e861e5e97175dfa7b7bc055c45acdc06d2301d3 ]

The following flower filter fails to match non-PPP_IP{V6} packets
wrapped in PPP_SES protocol:

tc filter add dev eth0 ingress protocol ppp_ses flower \
        action simple sdata hi64

The reason is that proto local variable is being set even when
FLOW_DISSECT_RET_OUT_BAD status is returned.

The fix is to avoid setting proto variable if the PPP protocol is unknown.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cc1ff87bce1c ("pppoe: drop PFC frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index ba437cfcbe90f..537dbd7fc5438 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1207,9 +1207,8 @@ bool __skb_flow_dissect(const struct net *net,
 			break;
 		}
 
-		proto = hdr->proto;
 		nhoff += PPPOE_SES_HLEN;
-		switch (proto) {
+		switch (hdr->proto) {
 		case htons(PPP_IP):
 			proto = htons(ETH_P_IP);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-- 
2.53.0



