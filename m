Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA5F358D27;
	Thu, 17 Sep 2026 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660490; cv=none; b=X0LzwzoOFGe1+IwHKaEAz2fBGroTfvJwZQqNoZf/r06NZTQXPbwaAiLwXtNvhTeA1kwQD0UPFjnwAPQ2SlNiZW1rCuC3LrD8HTZH8vOYJcht8Od8JGVYZZBIToxusE9D/XVGuEzTAwnm0koYYEHFYhqgvXQvWD9os+VEVkp6xno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660490; c=relaxed/simple;
	bh=uxffugRgt3xCBlVBygMi3ENZfBw8tPgKhXGo6oDmz5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOoJwirWUk0w/ddRNbu3OkLnexwGL3ZQeFIwBhYlMCb5jbk9rSvKDtgOFotQq0TPkEoYiXnKalSQcmMbP2fi+fcUhCrVqUYJVcb4PkiLmwdrgDJt01faHJx3UsP+WGSxp0yrM8C/+3w2EAFoQ0+uKem+D7OeBxw5F5qCwaffbyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEPzWIIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEPzWIIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB14B1F000FF;
	Thu, 17 Sep 2026 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660489;
	bh=HAgQ+d716F01w25w/yEokKnBupbWeytlfd+JQfSn6Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEPzWIIrBL3VsqYeMJNVkJfRjkeiYMyq+zCDf47bC8XRKTzGTNuSyowyMaQqrqRpx
	 r4IfKlsvaI93JvI5huYZuHs0ObfHcNjqSA2sgNaco6D+GtYkIdiGXRDTcJihx6XAd/
	 KeYdfrgtZwuwdQmRwQZbTaRauM+7iCWPo2LrxJik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 608/733] bnxt_en: Propagate RX ring init failures in bnxt_init_nic()
Date: Thu, 17 Sep 2026 16:15:16 +0100
Message-ID: <20260917151407.639467179@linuxfoundation.org>
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

commit 8e6a850c0746bb4be167aedf1ee57469fcda09a9 upstream.

bnxt_init_rx_rings() returns an error when bnxt_alloc_one_rx_ring()
fails, but bnxt_init_nic() discards that return value and calls
bnxt_init_chip(), which enables TPA.

If an allocation fails, this could leave rxr->rx_tpa[] partially zeroed
and TPA would be enabled over an array with zeroed entries. This would
lead to a zeroed DMA address being handed out if the agg_idx is
translated to a SW index at a zeroed entry.

Fix this by propagating the error out of bnxt_init_nic(). Both callers
already check its return value and unwind with bnxt_free_skbs() and
bnxt_free_mem(), which tolerate a partially initialized RX ring.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-6-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11341,8 +11341,13 @@ static int bnxt_shutdown_nic(struct bnxt
 
 static int bnxt_init_nic(struct bnxt *bp, bool irq_re_init)
 {
+	int rc;
+
 	bnxt_init_cp_rings(bp);
-	bnxt_init_rx_rings(bp);
+	rc = bnxt_init_rx_rings(bp);
+	if (rc)
+		return rc;
+
 	bnxt_init_tx_rings(bp);
 	bnxt_init_ring_grps(bp, irq_re_init);
 	bnxt_init_vnics(bp);


