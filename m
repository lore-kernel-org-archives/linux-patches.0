Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0352251A752;
	Wed, 30 Sep 2026 17:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788449; cv=none; b=b2/ruMS9yMNBZqZ+FR9UIcyKiSxW/fusPRrWChLJmlgP8WqQQ6fN7XS7pEvvHevGiI8a+8jD0rVSwyvfdXrlpUgkiXlUQPPlJsTcUYm1PAEanMju9OqUg5CUem6ulPs/zJZQKOmLTgTWK67s8yS10jh3syNQ4iLFHV1mD39YVDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788449; c=relaxed/simple;
	bh=KkfmCm4wMKbhWBiDK1IZ6OFWlwKLu5xxTqQd1Vq6dc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvRIZbAFhORcT6DD7mmAVepjI/+DUJ6XRsc5/JMTgFzhuG+Tq09nrPTbKUzLjs3fex6KvS04VzVatrI15LJlKqGmIB0/1A5d5/o5LUCaTUuk1+khclWbcTuZgi8qrpBeNZA9LTKdRLxyGryNAuivSoe6S7b1zhc1dY5eZK38QCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pR46iMCd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pR46iMCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230CC1F000FF;
	Wed, 30 Sep 2026 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788447;
	bh=0gdU2stOEQahODt9O5B5J3JL/UTqonwcSPY/VxdYa2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pR46iMCdhFrZVpzeA2XdIs7QPZn04+DWEVUZoEMsuiQL1MFv+DvqNqtY/Qh9rvvl/
	 7hf6YJPxyPTihnAzGHl3NJ7Mqw19e7tJNERKcoHJiYfzECEd3/f1k+fUhDMzGwWV03
	 B0JS/L8KxtVlGDW8Zwgo5xgqvS9iLmy0mdZ3G/Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baineng Shou <shoubaineng@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/877] dmaengine: mmp_pdma: fix wrong sg length in mmp_pdma_prep_slave_sg()
Date: Wed, 30 Sep 2026 17:17:20 +0200
Message-ID: <20260930152417.519879367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 852e6714d9f28..59227fbed9045 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -541,7 +541,7 @@ mmp_pdma_prep_slave_sg(struct dma_chan *dchan, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, sg_len, i) {
 		addr = sg_dma_address(sg);
-		avail = sg_dma_len(sgl);
+		avail = sg_dma_len(sg);
 
 		do {
 			len = min_t(size_t, avail, PDMA_MAX_DESC_BYTES);
-- 
2.53.0



