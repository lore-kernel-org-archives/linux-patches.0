Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F944F392A;
	Thu, 17 Sep 2026 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660479; cv=none; b=ig0+SK4WVP88ya431FL8N4ceutglyASXW69Khv9fwsklkoRjDEYni/9kgvMa3Q3BaWPSALrCHZ/XBArmdqFb5DmGiwubcd8CF7IY7pl2o5YlC4Hs6WSef73G7YRgmvvKQ4bAwSZHGVu2FNrh6jqAJc9yWuVlJkh2Dg93V8+byh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660479; c=relaxed/simple;
	bh=RkO4k4nlVgpMi3hRDodlKsOH71DCxSjP/cbgqC+ypNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAAoExRM6Z+np5BMbF7ULGWEZE1JYn/NCojA3IgR3W0AqKz4SSLEUPwfi7M7HgQwaOYAuSrf45tiSVcHV7dDmhOOuPOhfaKM7ZpmXoemV/rh434aWim31KS/f6jaYqqs/MtYhBhZbZtRNmlbq9eaOP7SGPpCT6kMerZgVhTmwh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoCYBXPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoCYBXPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBFE1F000FF;
	Thu, 17 Sep 2026 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660478;
	bh=iUBcD9MX/JiE+ZSOnnyXjEyF75jr9pN14zxjzu86hr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DoCYBXPPh/GGaggoqq0sQfimCXiCoJupchzy+Kz6X94jHr6uJectEhBy9GMaNILdB
	 lST6dkgGDZfR3+6/nh8TWJKeK3eutY2rewc4gBjdyGpMwDxt8ZHPBaBrZlpj086BPR
	 KEjn/DIEBMr8kBaPuPVrlBmfNyyxSEgVQrukfy9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 605/733] bnxt_en: Only restore LRO if the device supports TPA
Date: Thu, 17 Sep 2026 16:15:13 +0100
Message-ID: <20260917151407.556053287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Joe Damato <joe@dama.to>

commit 4e17b5007b6664559cdad2b2fe270526cf786b5b upstream.

With a P5+ device with firmware that reports max_aggs_supported == 0, it is
possible to make LRO settable by attaching and detaching an XDP program
even though the device does not support TPA.

Fix this by testing BNXT_SUPPORTS_TPA before restoring the feature bit.

Fixes: f0aa6a37a3db ("eth: bnxt: always recalculate features after XDP clearing, fix null-deref")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-2-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5006,7 +5006,8 @@ void bnxt_set_rx_skb_mode(struct bnxt *b
 		bnxt_get_max_rings(bp, &rx, &tx, true);
 		if (rx > 1) {
 			bp->flags &= ~BNXT_FLAG_NO_AGG_RINGS;
-			bp->dev->hw_features |= NETIF_F_LRO;
+			if (BNXT_SUPPORTS_TPA(bp))
+				bp->dev->hw_features |= NETIF_F_LRO;
 		}
 	}
 


