Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE724B5CCA;
	Mon, 31 Aug 2026 13:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184376; cv=none; b=SK8G3MRWmlv0RJp+Aa3pqYKglVRa/ZvC8TP4plxrnFuzALi6NIKOHFo42eWEWkWiPCAsP94fImHI9CxtsLSTc1psotR2u4vZ0sZNNwYbK62ui+JJIxlNReZCRWwjwPjGPcNwilfejASdTR+4s/bthp98J2UrzUbqK1YA5mdWpGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184376; c=relaxed/simple;
	bh=iNJ5hPabhKIjpotbbB7DL4Z5B5MdPRhXpa2nu8TFceo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GarEAmeOxS/8Worv3B1CJxYp9K1aroD6QdoQX4hgJBrCePLOgjeY1lMH4WzSHI2zfWeGTjwmwmauxUz89gJzm1f/tqD8Zhy9DZqoMdQusMB2qaNXvErGenuuU5mK7RRCdNgAdKfeSh9PeBXsSOrlFYCQOFPPFoS/q4OigynI6QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boYop5Ar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boYop5Ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918F21F00A3F;
	Mon, 31 Aug 2026 13:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184374;
	bh=KDZ9Kf8ZdHLdKFDnVfCKSFzuxCh6vpCB2tLgc/sFGU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boYop5ArYn3zfmiZvREYM6LQ2i6Dykza/bcDYcEagL1ybTXkZQsZp+EuskYxwovrK
	 aYLrTbRxpnahkp+Cjbqe7JOFmIGfMf/y06gsGETEwu8cscNXSdOKEOGZTxEC5i023L
	 tkC8W+oC0CmQ+a2pspfLulLTEPFlRuZO8J3huxH2yeG8sItozhuH2URumh8YmjjT1Q
	 lBVq1iG3sYtv7BGvaj7QO0hXgPSEOB6C8SW8ejWgeRVGqIApgsfeqE3P4tlxAa9wql
	 rdUy8c2iSZP55CUa8O64Zlc741zVpNHpXTqewHtWQ9m03DZchbA0/PfvKAqghVQaYi
	 6OGkDaDUSIMMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: ibm: emac: mal: fix unchecked platform_get_irq return values
Date: Mon, 31 Aug 2026 09:31:24 -0400
Message-ID: <20260831133314.4125787-656-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 8084fc9292c2b9b148c9d19d50710c488652214c ]

platform_get_irq() returns a negative errno on failure.
Commit c4f5d0454cab5 moved the platform_get_irq() calls and explicitly
removed the error checks that were previously present, claiming
devm_request_irq() can handle it. However, a negative IRQ number
passed to devm_request_irq() fails with -EINVAL instead of
propagating the real error from platform_get_irq().

Restore the missing error checks with proper errno propagation.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260603211734.30750-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Those background lookups are done and match what we already concluded:

- **Git log search:** No commit with subject “fix unchecked
  platform_get_irq return values” in this tree. The only close hit was
  `40af583d16465` (exynos5 `platform_get_irq` handling), which supports
  the same error-propagation pattern but isn’t this fix.
- **b4 dig:** Returned nothing — expected, since the fix isn’t merged
  here so there’s no commit hash to trace.

Verdict unchanged: **YES** for 6.18.44 — the regression from
`c4f5d0454cab5` is present and the patch should be backported.

 drivers/net/ethernet/ibm/emac/mal.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index 35b93e6bcdf9f..74526002d52bd 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -635,6 +635,11 @@ static int mal_probe(struct platform_device *ofdev)
 	mal->txeob_irq = platform_get_irq(ofdev, 0);
 	mal->rxeob_irq = platform_get_irq(ofdev, 1);
 	mal->serr_irq = platform_get_irq(ofdev, 2);
+	if (mal->txeob_irq < 0 || mal->rxeob_irq < 0 || mal->serr_irq < 0) {
+		err = mal->txeob_irq < 0 ? mal->txeob_irq :
+		      mal->rxeob_irq < 0 ? mal->rxeob_irq : mal->serr_irq;
+		goto fail2;
+	}
 
 	if (mal_has_feature(mal, MAL_FTR_COMMON_ERR_INT)) {
 		mal->txde_irq = mal->rxde_irq = mal->serr_irq;
@@ -643,6 +648,10 @@ static int mal_probe(struct platform_device *ofdev)
 	} else {
 		mal->txde_irq = platform_get_irq(ofdev, 3);
 		mal->rxde_irq = platform_get_irq(ofdev, 4);
+		if (mal->txde_irq < 0 || mal->rxde_irq < 0) {
+			err = mal->txde_irq < 0 ? mal->txde_irq : mal->rxde_irq;
+			goto fail2;
+		}
 		irqflags = 0;
 		hdlr_serr = mal_serr;
 		hdlr_txde = mal_txde;
-- 
2.53.0

