Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978AF51A73A;
	Wed, 30 Sep 2026 18:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791543; cv=none; b=spC7eIVQVN1G59SqUB6/QNTjRJOoC4XQDO5DZ9P1HbdOeWd6CzYOmD/7acsUv83xi0a85seRD89FztRq3F/fNiu5OjGPfb1AI9g+/WVcvPEOk9tS8IK829z5hAq4UQcMM5WL/ueZwUO7nAfI4fDCM28T9O09K2nB8/gZr4wiHKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791543; c=relaxed/simple;
	bh=7cEGgVTxEF1Gktgp2bFDBfJJZz3IW+2lgDJjNGdWBHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrthSpfw21iSh2GDw7y8yI9N2utsVCpRmk4IfSFKo6a5THlfetQGCqA6WlumKVLNFK1PeIoFDpCwigrCPW6jwa/2+X4UzG8AG1uf0zEMbEQWFjaC5DEZXnTXDInLEKNV438sWlQOLT2xYWEhC4zs9HFlRdS/ki5NfP9IOlO79sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArGzpPBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArGzpPBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCF91F000FF;
	Wed, 30 Sep 2026 18:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791542;
	bh=wSwSHVXSbv/XPqtjGrfPi/71qVUhdlAnxR+EAEyJN4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArGzpPBypbKHg2ybClOrgpL1IEc8v03NxYnrhKhjR6QtK0y8wVNkxy4OG9He2tX+3
	 w4IW7xMAtTCjjy98Fk/X87x+TCwCCMCs9D4MF1tnzmQWUSHTCt0Z9SQ5H8+qIKvkzw
	 XTKnUcTnOs0FjQUJVNaJVXNg4wnDMUXH2ccymdLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/752] net: ethernet: cortina: No mapping is a dropped rx
Date: Wed, 30 Sep 2026 17:23:29 +0200
Message-ID: <20260930152405.627787388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 2cb156213093a62b80cf40b1ec71738e93491971 ]

Increase stats.rx_dropped++ even if this is the first fragment
(skb == NULL) so we are doing proper accounting.

Fixes: b266bacba796 ("net: ethernet: cortina: Drop half-assembled SKB")
Link: https://sashiko.dev/#/patchset/20260505-gemini-ethernet-fix-v2-1-997c31d06079%40kernel.org
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260509-gemini-ethernet-fixes-v1-1-6c5d20ddc35b@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 6520198c430c ("net: ethernet: cortina: Count RX drops once per frame")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 9b65d554196de..d5bf439777817 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1464,9 +1464,9 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		gpage = gmac_get_queue_page(geth, port, mapping + PAGE_SIZE);
 		if (!gpage) {
 			dev_err(geth->dev, "could not find mapping\n");
+			port->stats.rx_dropped++;
 			if (skb) {
 				napi_free_frags(&port->napi);
-				port->stats.rx_dropped++;
 				skb = NULL;
 				frag_nr = 0;
 			}
-- 
2.53.0



