Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838414FD7BD;
	Wed, 30 Sep 2026 17:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790262; cv=none; b=nCYqUkjMLlanhLIn6FqHP5wcJfK0ZlT/2ICbM/4O/wrlwcnyragA2RU0UfnS1zGGrTRHlGKd9WyznVyQ9ZZN4fcrIVD3f6Q159myf2CdtmoePNtDQfCeEFZEt9mHODSgd2FJNKyMOqSsNxsAL1Ucle8nJTWBN/XCCSXSLRV9QeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790262; c=relaxed/simple;
	bh=0Wi8uR3RIzGuVxWdpMF+w+6+BU4ttWhYqWG2D5Abero=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fs9sBExrya1H5v9cpSsbRNuGgrhX9B+1xpE9y3WXjUQVrn/R6HneZDPxX1ZfGz/npRsUwTBwcaJpLOVuvDFC+yTNtha3L56WGsaxfr4lN0Bi+jhiQCjqYPKglNrnYSk7FV9xEFFyfhC23lpGXFyrzyo1AZojwWK9XFHI9cQmubU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLINSFhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLINSFhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF70C1F00898;
	Wed, 30 Sep 2026 17:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790261;
	bh=nfNcvOVEI1ctrOEjZBthb2pMPX8hPnyjhzzDWvRlbQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLINSFhe7rjjRE46h0jYwyZuYyY7Lo5HDee9AQ5OKnbeSzjmkUwPt2RYgMJhMsV9s
	 wotiof6jVUUfi3EfxR7adTZ9HxW6clppe2JR5odmZrohZ384nHi3UJ4txREsi5saaV
	 /ziHf6x2TRvcuCZ9Vxi3+VjMrnYmsE4ea5jaiV7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 766/877] bnxt_en: Dont free the live rings TPA state on queue restart failure
Date: Wed, 30 Sep 2026 17:27:57 +0200
Message-ID: <20260930152431.235833402@linuxfoundation.org>
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

From: Joe Damato <joe@dama.to>

[ Upstream commit 5ce7f36c334d723954855ac769ede2fe0e8f89c8 ]

bnxt_queue_mem_alloc() shallow copies the live RX ring into the clone:

  memcpy(clone, rxr, sizeof(*rxr));

the code currently clears pointers that the clone owns (such as
rx_agg_bmap), but rx_tpa and rx_tpa_idx_map are left pointing at memory
of the live ring that was cloned.

If an allocation failure happens later and the err_free_tpa_info label
is taken, the live ring's memory can be freed while still in use.

Fix this by initializing the clone's pointers to NULL to prevent live
ring state from being freed inadvertently.

Fixes: bd649c5cc958 ("bnxt_en: handle tpa_info in queue API implementation")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-3-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15402,6 +15402,8 @@ static int bnxt_queue_mem_alloc(struct n
 	clone->rx_sw_agg_prod = 0;
 	clone->rx_next_cons = 0;
 	clone->rx_agg_bmap = NULL;
+	clone->rx_tpa = NULL;
+	clone->rx_tpa_idx_map = NULL;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
 	if (rc)


