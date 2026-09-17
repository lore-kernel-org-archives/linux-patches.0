Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9354151812F;
	Thu, 17 Sep 2026 16:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664301; cv=none; b=GQFH4eD8Onc31/tJnOMv/VDt0lI0ujzkKo7HyglJXTbkdIYlqj5aPCZBDFGEVLQ60eT3UrbZKj1Q6Cwkr4dgvG/KedAc2S2SCwFHh1lJR7FG9i/XuI6OJhkiTsbxERvi6i1rbtRggmVn+XWB375na46Sgj7z+J9FwlW25d3iU20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664301; c=relaxed/simple;
	bh=nLjkuDAg1DLh+h4ujrWy0FTbmtHO9Yh2jJVc1/IcwEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVXnPDe0lf2WjVXUNwQtiHoid1LWMuZVlby9OzgBjzghkF1bySZUQiL9aimDMzleZhGCEDtfxEaH54GE7X3bk9X5kUjifwMoO1sjeXW8GIePWnLk3WdEsREPeEGOdCsVQ9ms9mFVjc2H4loFmqYUvPcsMA2ZcqMm225g66iAGe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bI0msaQR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bI0msaQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B991F000FF;
	Thu, 17 Sep 2026 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664300;
	bh=wksyeaW57yOkjqNlnZuBojWBuitD77q+IYx/x5Nc1Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bI0msaQRSIrcwJX8+hJjPisnXNW4oojH9u7TKhHz1Wn9slnjL6B5+szxEKFq1eG4O
	 PysG/adl9f6Dsve9YPcLBHfJUoT9GB4+WOU0nttMxWf+C/KT5weREMFhP8GIMT0LqZ
	 /8VVhKwuv5T23LS99IQ/Velf0rBbCFLX+fKbwaGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0325/1250] net: ibm: emac: fix unchecked platform_get_irq return value
Date: Thu, 17 Sep 2026 16:02:00 +0100
Message-ID: <20260917151600.905676640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 1681cb1bde051c3b9ebbd337c0bfdd3e74167b2f ]

platform_get_irq() returns a negative errno on failure.
Commit a598f66d9169 replaced irq_of_parse_and_map() (which returns 0
on failure) with platform_get_irq() but dropped the error check.
Without it, a negative IRQ number is passed to devm_request_irq(),
which fails with -EINVAL instead of propagating the real error
from platform_get_irq().

Add the missing error check and goto err_gone.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260601040201.103481-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index f48568140480e..074cc6d1050eb 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3044,6 +3044,11 @@ static int emac_probe(struct platform_device *ofdev)
 
 	/* Setup error IRQ handler */
 	dev->emac_irq = platform_get_irq(ofdev, 0);
+	if (dev->emac_irq < 0) {
+		err = dev->emac_irq;
+		goto err_gone;
+	}
+
 	err = devm_request_irq(&ofdev->dev, dev->emac_irq, emac_irq, 0, "EMAC",
 			       dev);
 	if (err) {
-- 
2.53.0



