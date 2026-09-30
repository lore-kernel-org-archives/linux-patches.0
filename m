Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9833665192;
	Wed, 30 Sep 2026 18:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791997; cv=none; b=CYBsDYXRYjFg+AAIR9RByLdS8sa/XgedEEGLvPWooOMtLivY4R0HUBg6oHcpO3UIVaui4LZSYlBh3sGcsnirw1BQfNJrDELp9icPoyW9+1eBXqLUzJuQ5gndSwzH+X+XbfzDsPMiDW+Uf6VrLjZwnPJNBnk0zcOaxtpZNJ+hEIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791997; c=relaxed/simple;
	bh=S/vrgfr/ucT6UIRt1Zo9NTjeF+az2LVNiHFLK1jEnPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLP2ZlvIYwbWQ2bxnnwCrS4H/FQ2LvsnHFMmJI526KEtzvXSQs+H4CVmOHdanZbPDXcUZWg4W43MkqAEaNjpxYooowYnIiMCJq+1yC5beSgNN2IbaC2c7Q02Fg9m+Wq2bS9KBYdufd0vrqvbTasEC6idh3ujd40pnyKU3Tb67+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDdL47Z8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDdL47Z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E42A1F000FF;
	Wed, 30 Sep 2026 18:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791996;
	bh=lXcF3yl+wSEP32HqgLwRC9FwdVr6VVZd4YbEoW5hJSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDdL47Z8hRBczsdOmI6uIjbY6hPt8gz5rfikdK7hfkhUeifYcJxut7lsJUEQuAepc
	 9/memgwhN8X0l3CeggJ45nuO+heddgtxlSz9AH76FeI2Gh54UsLrdjjT5/BjcxdO6x
	 +scbM0DINVX6aPidqbXA1HziBp15h8byOQVhJCYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baineng Shou <shoubaineng@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 498/752] dmaengine: mmp_pdma: fix wrong sg length in mmp_pdma_prep_slave_sg()
Date: Wed, 30 Sep 2026 17:26:08 +0200
Message-ID: <20260930152409.037839154@linuxfoundation.org>
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
index a15efd4d0c84d..07324c0028295 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -542,7 +542,7 @@ mmp_pdma_prep_slave_sg(struct dma_chan *dchan, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, sg_len, i) {
 		addr = sg_dma_address(sg);
-		avail = sg_dma_len(sgl);
+		avail = sg_dma_len(sg);
 
 		do {
 			len = min_t(size_t, avail, PDMA_MAX_DESC_BYTES);
-- 
2.53.0



