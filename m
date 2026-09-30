Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1218511E66;
	Wed, 30 Sep 2026 15:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783584; cv=none; b=qN3JnspOPW7CQ0ZpJm92W7Lf93g2U9QWttTLxWOc56AfGRWhhu6unq0iPoHdfzxdFF+BbMzwMsQlhGsJeSEw5NFcOQolJV8PKQCZJXFQkeIEdQ0q2X/nFXMdu7y8rF+lImKof/7CR1kWDjPoAm1FSlbRX/jtYw+IuAXh5JzMoek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783584; c=relaxed/simple;
	bh=T2mxn5FdrA9Tl3DHbNUQCwyjQxTe+8wddiuD0HWa7Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSufrNZhlQf+u1Wn0cEbKO4BtPRV67eTnBw/5VB5tKv6/3IoM5DmaUVrAl0vlXtr5HsUQtAOpmEqxIQJKfl+4ejh9QHuIKoFmNYEqeUV6hQWvm+6H98UlMejrM0WFOoKrAIO+ScCdjYw2jRI0Gu/6QLw7EhOvPeqsB3x3L4WUHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgeAp8NH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgeAp8NH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACD01F000FF;
	Wed, 30 Sep 2026 15:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783580;
	bh=2P/58Hh5Ei/7h5QHNwh6Mkql5UEX2ja4MPZlxadaI6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgeAp8NHqau2JyXOU7GUJ38/MTPUc+URvsYpOkF4KyKJYaCTPyrZiTOCG6oIapfHV
	 77kLwBVQycKglkPL5A8PNKJoMkYotFzuVPz42ChZQuND1EEtb+TYEGQrtU7mVfqHJh
	 bsz2lcY/SopuE8OuHsnRZq3juydKnR3fgUeDmnmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baineng Shou <shoubaineng@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 404/595] dmaengine: mmp_pdma: fix wrong sg length in mmp_pdma_prep_slave_sg()
Date: Wed, 30 Sep 2026 17:24:57 +0200
Message-ID: <20260930152356.364815071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Baineng Shou <shoubaineng@gmail.com>

[ Upstream commit 075bc7b1d3dde5ed43fbaabbc1a69f09b7fc3a47 ]

In mmp_pdma_prep_slave_sg(), for_each_sg() iterates the scatterlist
putting each entry into 'sg', but the entry length is read from 'sgl'
(the list head) instead of 'sg' (the current entry):

    for_each_sg(sgl, sg, sg_len, i) {
        addr = sg_dma_address(sg);
        avail = sg_dma_len(sgl);   /* should be 'sg' */

Consequently 'avail' is always the length of the first entry. For
multi-sg lists this causes out-of-bounds reads when a later entry is
shorter than the first, and silent data loss when it is longer.
Single-sg or uniformly-sized lists happen to mask the issue.

Fixes: c8acd6aa6bed3 ("dmaengine: mmp-pdma support")
Signed-off-by: Baineng Shou <shoubaineng@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260910021652.1296640-1-shoubaineng@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mmp_pdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index 4eb63f1ad2247..8f1eebf608b27 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -543,7 +543,7 @@ mmp_pdma_prep_slave_sg(struct dma_chan *dchan, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, sg_len, i) {
 		addr = sg_dma_address(sg);
-		avail = sg_dma_len(sgl);
+		avail = sg_dma_len(sg);
 
 		do {
 			len = min_t(size_t, avail, PDMA_MAX_DESC_BYTES);
-- 
2.53.0



