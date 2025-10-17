Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073973370EE;
	Fri, 17 Oct 2025 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713026; cv=none; b=SKs6A0aP8GFu9GxwNHYBzfQ4LUG56n0E1PftayV3lQM/0gWH9XrFLiLkUM1k8xCdUqaByA+rPaLmc3/tht5jzgGzuPFQQxdxv9HLptwdz4dKiXD+QGqEVkeePUzDkJi3PzmiwR0F6GOixOaQWbYYtcRdVAaS8M2C5aw5tQRMWws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713026; c=relaxed/simple;
	bh=9t8jVKjinDkgEZAhV0vGCN89K5WsQ8KugCBcx4GAfWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oR0KuNMbrLoecs3YhRMbTt+JHWu8SO1JULcMlMn3VT1VqAna9jRacpVgUqtWFKXQVu2oICLSGb28aW3wsefc2r7xP/hKUDWtZ1x5+6L93hVrHZtphh3mK0ynK91rhkcNjygp5JzqCeIJ+rZg9y9UB0VZZx5w3bS4wkAoVDpyb9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzeZxbGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzeZxbGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3381DC4CEE7;
	Fri, 17 Oct 2025 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713025;
	bh=9t8jVKjinDkgEZAhV0vGCN89K5WsQ8KugCBcx4GAfWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzeZxbGHRFbvxLV93Q1OWRvU4mQsUMtDHSLEscK8/76/1Hfkw5pyh2dn6dJbB8Nao
	 bp1NWdtA35/1KcJ+ROIxGXsg3XWPzqtmY5JtjA5rkLdlUf7cxNGo20u2nK5eJgEUQe
	 jKaAOyouFNugC4OOurkfWYrxLQ1c3B4c4liAg3eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/168] clk: at91: peripheral: fix return value
Date: Fri, 17 Oct 2025 16:51:27 +0200
Message-ID: <20251017145129.320196758@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 47b13635dabc14f1c2fdcaa5468b47ddadbdd1b5 ]

determine_rate() is expected to return an error code, or 0 on success.
clk_sam9x5_peripheral_determine_rate() has a branch that returns the
parent rate on a certain case. This is the behavior of round_rate(),
so let's go ahead and fix this by setting req->rate.

Fixes: b4c115c76184f ("clk: at91: clk-peripheral: add support for changeable parent rate")
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-peripheral.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
index 5104d4025484c..a5e8f5949d770 100644
--- a/drivers/clk/at91/clk-peripheral.c
+++ b/drivers/clk/at91/clk-peripheral.c
@@ -275,8 +275,11 @@ static int clk_sam9x5_peripheral_determine_rate(struct clk_hw *hw,
 	long best_diff = LONG_MIN;
 	u32 shift;
 
-	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max)
-		return parent_rate;
+	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max) {
+		req->rate = parent_rate;
+
+		return 0;
+	}
 
 	/* Fist step: check the available dividers. */
 	for (shift = 0; shift <= PERIPHERAL_MAX_SHIFT; shift++) {
-- 
2.51.0



