Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9940135CB60;
	Fri,  7 Aug 2026 15:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117037; cv=none; b=ua1nqfWrHUl5RZMxQrwJPuCTLzEP3y+gWl+E7LaFk22jU4MFbZ1y6KYvYfBdIjpajRcflzfJXzLEg/TtQ48yC3bnBAsNLrKXZ1I6P8MnnlFS7lTV+FYCBLdU2+z8ZEVxF1yOerLlEVnWigSWlFmWEFsaD4dNCWF4nkLPYaF7OYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117037; c=relaxed/simple;
	bh=JnUpXdxfHXN9Rd+/AQJGTIyVlQ2Ul8rVpbbJF8dC+II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqctZjHL9CQBQhVbXQUg8AfSuaNRS2OtgKIQCndzbKdCDqeM+cUpyXk9R72EgrSVi+y5GPqrGl/nyVg70WFG2lFtS0+O+0sdJf0uI9eiqM4o4rZIt3udG38oaXnCprACIBovm4OMQ0aEaPtdUMJxWUUE1fdeviAusCvLkG4poVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/CI3trw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/CI3trw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004951F000E9;
	Fri,  7 Aug 2026 15:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117036;
	bh=PimEJDB0eyH6BkdMzlD+xxl50m0Wc0C08H8JjWlDQ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/CI3trwinKaqCXOLB6NnHQyqEtQi9A2Hc70yYkWbngziGJxPgpRthXPM2lvQ5/m7
	 s3KEu1lw0nmDpOwFcBCV889iSfuAyRKkKgtco533s2og+r6eZGYyzE9AaIMCdAfQH9
	 Ad1HQiJ/TMTHna9wJDYANQR8LJw5TAgoil/EBGsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 179/438] net: mana: Return error code from mana_create_rxq()
Date: Fri,  7 Aug 2026 16:36:15 +0200
Message-ID: <20260807143431.850591352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya@linux.microsoft.com>

[ Upstream commit e67cc80b50f587cd1d8ffc8989dcec3291720bc3 ]

mana_create_rxq() returns a struct mana_rxq pointer and returns NULL on
any failure. The caller, mana_add_rx_queues(), cannot tell what went
wrong and hardcodes the error as -ENOMEM. As a result the actual failure
reported by the lower layers (for example -EPROTO from a failed HW
request) is masked and every RX queue creation failure looks like an
out-of-memory error.

Return an ERR_PTR() encoded error code from mana_create_rxq() on failure
instead of NULL. The caller now propagates the returned error code
directly instead of substituting -ENOMEM.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260727113759.2881500-1-gargaditya@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9d8c91d36b3bc..7e6bc6e5ff232 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2771,7 +2771,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	rxq = kzalloc_flex(*rxq, rx_oobs, apc->rx_queue_size);
 	if (!rxq)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	rxq->ndev = ndev;
 	rxq->num_rx_buf = apc->rx_queue_size;
@@ -2872,7 +2872,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	mana_destroy_rxq(apc, rxq, false);
 
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static void mana_create_rxq_debugfs(struct mana_port_context *apc, int idx)
@@ -2906,8 +2906,8 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 
 	for (i = 0; i < apc->num_queues; i++) {
 		rxq = mana_create_rxq(apc, i, &apc->eqs[i], ndev);
-		if (!rxq) {
-			err = -ENOMEM;
+		if (IS_ERR(rxq)) {
+			err = PTR_ERR(rxq);
 			netdev_err(ndev, "Failed to create rxq %d : %d\n", i, err);
 			goto out;
 		}
-- 
2.53.0



