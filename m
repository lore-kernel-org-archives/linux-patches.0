Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D1A38333A;
	Thu, 17 Sep 2026 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660482; cv=none; b=NtnNM/1dMLz7dI5RVbjxmaTU+4nOZUFHlz2AuE6kqJv1dyLTZs78xPhLaBUy1yrVYwMO2rNjIb0YPjvCXJonAGWtU84NFSSEgHCHULqYu59TBgIXzP4xsjydMMpkP3GNORbJlbvaR8SesUMuiapfmx3a3r7/hvN7vrCRo9aYC7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660482; c=relaxed/simple;
	bh=/BEcZLZgbJzavUr7BtOcPC9h4mEt+YWemlE2C4yYj9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7YPI3f6W10NczpZ3DCPCpN003Z4/N5YwCRcvr2kFYPiOJq2hbLMMX2U89Xwr4AWeW6fDJeB7nNq53nzqzLOpcpXXPV2LS3NuXFuTbT1jt64FUjivmj+mbuyGJdkvHl8NlWl1DvhRdMEbXzL6OCI6FgJfPyCmUn7+OgFNPuNOqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbLs0bKz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbLs0bKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292FC1F00893;
	Thu, 17 Sep 2026 15:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660481;
	bh=rSUwKgNdbjQpcqz6GJytPh267S+A6M0f3etZh9LmFio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbLs0bKzoTacKfbCGxJU+Mu/gvlMq6vAac96A+XWEZW6Apu//ShR9hlc8N5CKqtEU
	 bJ3mjaLZEFAQRnfaWEp0RKO/e49u9FMxmJIARfabrs+11gTjMRxdMF/XkEcUochhxc
	 TGqT5+LrY7CAs34DnDprVhLAh5MgWcDd+TwxWmhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 606/733] bnxt_en: Dont free the live rings TPA state on queue restart failure
Date: Thu, 17 Sep 2026 16:15:14 +0100
Message-ID: <20260917151407.582620353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -16290,6 +16290,8 @@ static int bnxt_queue_mem_alloc(struct n
 	clone->need_head_pool = false;
 	clone->rx_page_size = qcfg->rx_page_size;
 	clone->rx_agg_bmap = NULL;
+	clone->rx_tpa = NULL;
+	clone->rx_tpa_idx_map = NULL;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
 	if (rc)


