Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB84440A16;
	Wed, 23 Sep 2026 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174608; cv=none; b=cTjnXARt8oKAYfCpD95Xnh9pmnAKKwm90KpNvvuyoNDat1OgHjrf/I3XsLqYcECMehqnI0wZe4BmBs8LBiVYhot0N9qHf1fNdU2wgC/ejP5KKGK7koW1M1UC3jMp3v/yPNmwNEk8Yigo0ncwWcpbR8KN/ODcOyssRsCsWCONbQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174608; c=relaxed/simple;
	bh=21xSky2PZw13mgzSAkLvCvf7hzEVTWhSXwtvqKPPANQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMsi2mjlgSaeD8yfmStEYSzf+8sTaG6dYBmPbpMNnhJJR+2NbcJ2BSzrNyYivVZzh3FfkYGdRmqV2/8rFP/TeR0w6jmPwBXcn/atLdEfdeunCN+2d25C1B9eWWBq+B286dcuJmVfArB8tYMFHSHZgR0Ns93UVDj8UHIv92WvWlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbUMQu+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbUMQu+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054801F000FF;
	Wed, 23 Sep 2026 14:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174607;
	bh=EFEDQltw8hi6tGRxG9hnKNEQiXtxqXxS7N2Wi5cTXWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbUMQu+nr87etwRaWWC9NsLNpNpiU9iSF1M0pQ04zrrISvYrL5E9cc6Ve+8BRoDYZ
	 1oiqVZZmV8ByN9bxOhwckKMltR33rXbEwUUok4MinzS+JKJZz9wLMy25LL/1XQTCfh
	 HItU6B1SA6x5a6hF5DQ/eWZ0LApypokzCdmGKV0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baineng Shou <shoubaineng@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/398] dmaengine: mmp_pdma: fix wrong sg length in mmp_pdma_prep_slave_sg()
Date: Wed, 23 Sep 2026 16:03:34 +0200
Message-ID: <20260923140647.062923952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index d12e729ee12c5..bf77bc7d5e388 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -701,7 +701,7 @@ mmp_pdma_prep_slave_sg(struct dma_chan *dchan, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, sg_len, i) {
 		addr = sg_dma_address(sg);
-		avail = sg_dma_len(sgl);
+		avail = sg_dma_len(sg);
 
 		do {
 			len = min_t(size_t, avail, PDMA_MAX_DESC_BYTES);
-- 
2.53.0



