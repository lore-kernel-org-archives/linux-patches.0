Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FC43803CD;
	Tue, 10 Mar 2026 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141915; cv=none; b=Y/ycRt2Ee7w8BDGs4uJ41KcoBB6LbWG6W9jcGB5iQTfyRXL1m2VRMPJql43tyTPKTrh4X6X3Wd3WgV5mLr+G2TVQrWbvJpKcKN68aqLPEHxniHk+LCbVv7h0kaTsBn1KqDKGm7yfbrN9fhzyUrYoppXHqYEySTDvyQtEYejR+tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141915; c=relaxed/simple;
	bh=fzjESTB8EpULEbHybToauaFfmA49OFoUBEvUZ4KvArc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFd8P+pG/HOtL1VD0BN1iJtN0smyEsK9Z8vaJQz2bRr8zF0V4D31LENeEjuBVo4ZKnS+edc3hkt8ykIH7aSxcmPV2RxzhRCJjOLxmTYRRZzkkzq7OFb9dcRgrUrEMEDzQblkiOg7Gen4WEepu03WoKLwvwmUUgqoKubHOapBAds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1nY5TaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1nY5TaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D03C2BC86;
	Tue, 10 Mar 2026 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141915;
	bh=fzjESTB8EpULEbHybToauaFfmA49OFoUBEvUZ4KvArc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1nY5TaRJPLh5IujS+BF4vqaOvCMMq140tw7C/KmGkBQXEvfqw1GoMDW999Vi5/ur
	 4Wh4SoLd9Sq8FZWJpZx1CjMVpzaTJugPJ3g7kdcRGrnTbdS/XgvN5YGzqZwuEF9crI
	 rp1synDZQQueV3hKOJev27e6MASWsBooDSzOD9KJxNyJh7Ll1E9NIdIwj2d+//aSBd
	 bSL2HtxJzenIC44oGP2EfREWqZwDm1IR7s0CSo+ZYUlaFRsjSczOq0LtY9VUTw39xD
	 WuH6mdFiO36y8Xz2vHAS/X/RHjrp2iLmj8s8CFVEQT3glwD9t73w1bjtMdDUrTIeJh
	 x7kN3A6Prgcpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/314] zloop: check for spurious options passed to remove
Date: Tue, 10 Mar 2026 07:14:57 -0400
Message-ID: <205783f2b89fc539924d802cbe8d5bd8b4319f7b.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3c4617117a2b7682cf037be5e5533e379707f050 ]

Zloop uses a command option parser for all control commands,
but most options are only valid for adding a new device.  Check
for incorrectly specified options in the remove handler.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 2419677524453..26364e43aeb34 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1076,7 +1076,12 @@ static int zloop_ctl_remove(struct zloop_options *opts)
 	int ret;
 
 	if (!(opts->mask & ZLOOP_OPT_ID)) {
-		pr_err("No ID specified\n");
+		pr_err("No ID specified for remove\n");
+		return -EINVAL;
+	}
+
+	if (opts->mask & ~ZLOOP_OPT_ID) {
+		pr_err("Invalid option specified for remove\n");
 		return -EINVAL;
 	}
 
-- 
2.51.0

