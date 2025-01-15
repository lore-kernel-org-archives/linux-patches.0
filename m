Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1F61E7C15;
	Wed, 15 Jan 2025 10:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937570; cv=none; b=I9L1V/lNiSfoWn21vPUZfNS+wJuYnieOk9+iYnqA97vg5FbysrlV/VS4JFiQlKQCHHvMuFTbNjiHP4VKIt99ngO8cKo12/4YMhu5yH2C+iivVQbJn9XTwmNCK9hwctpRB1DemCnKq4KOPq53kjzA5go41cjD4NtqBDS7/nSUNS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937570; c=relaxed/simple;
	bh=RHWUWRsZstTiLrl/wA0ZRT5euYWwUYBpc+cZoLD21QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7mygm27kFkb/3CCewlmrYml2ofWWSwPtjPHYodLHTMzm4QFjrRUMNBqt43pfGg1rXi+9RyNORJfjE1xWEKmJilWGrK0Uc25fQIinjsX8GN4IVfOtci4duzMdlzX+LrbmvNRkBMvfXnfxLvomAbVtmnF12TWE47HY78bnvu95KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmUrKmR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmUrKmR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9659C4CEDF;
	Wed, 15 Jan 2025 10:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937569;
	bh=RHWUWRsZstTiLrl/wA0ZRT5euYWwUYBpc+cZoLD21QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmUrKmR9oqROeUOWUFfV8jpWCbk8dpMmXeRDFrM6U887HS2NSRQ8Ve4zsoWNCVM7P
	 6lyb5zw7/RmiR/OmPrLk8n00zEnSbg04xEAOoQeM48v9Bz4wJ4Ym8YQA9RmpZ+X7uH
	 +WpmpLQsMieL5/XvdGLbhMR9pE5u2wVuanxOC3p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/92] cxgb4: Avoid removal of uninserted tid
Date: Wed, 15 Jan 2025 11:36:37 +0100
Message-ID: <20250115103548.301521057@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Anumula Murali Mohan Reddy <anumula@chelsio.com>

[ Upstream commit 4c1224501e9d6c5fd12d83752f1c1b444e0e3418 ]

During ARP failure, tid is not inserted but _c4iw_free_ep()
attempts to remove tid which results in error.
This patch fixes the issue by avoiding removal of uninserted tid.

Fixes: 59437d78f088 ("cxgb4/chtls: fix ULD connection failures due to wrong TID base")
Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://patch.msgid.link/20250103092327.1011925-1-anumula@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7ce112b95b62..c09240a5693b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1800,7 +1800,10 @@ void cxgb4_remove_tid(struct tid_info *t, unsigned int chan, unsigned int tid,
 	struct adapter *adap = container_of(t, struct adapter, tids);
 	struct sk_buff *skb;
 
-	WARN_ON(tid_out_of_range(&adap->tids, tid));
+	if (tid_out_of_range(&adap->tids, tid)) {
+		dev_err(adap->pdev_dev, "tid %d out of range\n", tid);
+		return;
+	}
 
 	if (t->tid_tab[tid - adap->tids.tid_base]) {
 		t->tid_tab[tid - adap->tids.tid_base] = NULL;
-- 
2.39.5



