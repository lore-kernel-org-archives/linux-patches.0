Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04204E4C30;
	Wed, 30 Sep 2026 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783211; cv=none; b=c9RUGY3B9VzlXW/AREByuUpr7Xl3c5br0Q4/vdVV8pBoyppsGSLnTZx3g6tfyihzW6UaTEB9vCM6o8olNZTpCABiUH0Flb05BILa0QuX3cmgoP7N8vtnRVYjGSmxcP5irUTnuZSqlGPN8Z98QDVwnzey5MXm8PLkcJsukdTZ4hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783211; c=relaxed/simple;
	bh=G1MUKc6UFbA6AN4YgaCWVcKzwIaXqkt9MBiuAaR5ylc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWcHXUJxpESt89VNo1EDxXtadacDpoTubtQXaSqBcoYgOVeWzifEi6/Z+m3pAPf7ReCKymoB08SrhrdSggDcy3Xciclu2Qzk6qxZM9/slTGXbwHWJxfVQo55cn2Q5MxfdsP2Rl7Hup7LTQQorUt9gfssBR2oL3DMZn3P5X/k61k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgf31ieD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgf31ieD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030461F00893;
	Wed, 30 Sep 2026 15:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783205;
	bh=0z3kPS33pg7SQXpnVHIYHTOKxcJ/sdBSy+gkMr5Fs2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgf31ieD1QV7kaeCUBnPAoaquw7aO3B5+g/vFzvx2WJLgLE+9zFSR0B0GUuJEkwGJ
	 2k/m6WRauFxlVrDfkDttOQJTpRakVb/7U+FNh6RKxpsRKHvRPOaIgf4/9dpTO6bfUa
	 YTAvcJ29QbH/laoD5TELamsxXCC8zgy7Dm2iYs04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 318/595] bnxt_en: Propagate RX ring init failures in bnxt_init_nic()
Date: Wed, 30 Sep 2026 17:23:31 +0200
Message-ID: <20260930152354.527708290@linuxfoundation.org>
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
@@ -8448,8 +8448,13 @@ static int bnxt_shutdown_nic(struct bnxt
 
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


