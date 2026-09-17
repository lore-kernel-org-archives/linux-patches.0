Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4801A4EF153;
	Thu, 17 Sep 2026 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666649; cv=none; b=sRWq5+w6o6S5+AYxL+kJelyblwQ+eAW1Tuvx5mlkeQgLynlARWFnYGGFVIkoDL9Cn2Vjcl22r0tz2fl4OrH6cEWxU7sszHRN8Mp2A3qwvAGBJoel0brETN0qPdswiiIsxHSAdgqFfdhgOl2W2OXMBO1FDS0ksYtfvZbT3rWnzLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666649; c=relaxed/simple;
	bh=pCAqGFCSQdtX+brE35AhYQRJbd86VKGlnD+OnZjUHHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4Zx2x9a3RNSCeyyL0MpDY209mdSuuxIW7FS6NxxIYBxU9Vco4q+SWf2ig1z7tttAjtndqSfrZikRDscx6LAFj1rlVdC46QHDLsjJWMRDA9Ehu0tNvCQnCoT5SNsnu3K/TFJ7QheX4spqhrNR1dkTf+UvwNY39MRB+sOWdZrslA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JjvJ89S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JjvJ89S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3ED1F00893;
	Thu, 17 Sep 2026 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666648;
	bh=XpLTHpH0+DfpojWBtx5wCdGMo0VbJU5Sz5haiqGLqCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JjvJ89SS+XIW9oVfv23xH+7GoEC1GnTOcsRNJ9LgqW2SyszIPUgaq/7aeLjwXH4X
	 juyNrzCpO8zOU8YmVkTquykq5nuFzGpP//+fufya1hNUfvZBBJyaZ+bEUCLN+plTve
	 kiX+qMgDYO0IzCm8zZohPWdvQUq01f/Npep4n3Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1069/1250] bnxt_en: Dont free the live rings TPA state on queue restart failure
Date: Thu, 17 Sep 2026 16:14:24 +0100
Message-ID: <20260917151621.106556284@linuxfoundation.org>
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

From: Joe Damato <joe@dama.to>

commit 5ce7f36c334d723954855ac769ede2fe0e8f89c8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16054,6 +16054,8 @@ static int bnxt_queue_mem_alloc(struct n
 	clone->need_head_pool = false;
 	clone->rx_page_size = qcfg->rx_page_size;
 	clone->rx_agg_bmap = NULL;
+	clone->rx_tpa = NULL;
+	clone->rx_tpa_idx_map = NULL;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
 	if (rc)


