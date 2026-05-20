Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FE6233933;
	Wed, 20 May 2026 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294899; cv=none; b=c9bNdyy6baFXr8DpQuRgPRzguNRwXdccfmKawtN+C8x5o/0/1CrSyN0vSZAEpNw/Xw9rehssyKFLwtTzEMJbJJYnpX9H2TIn4HbBcYSp7urdymxo3jqHQNLgwKmhgpYI+lTbzsDPwBCueYe7Py1m89pGDXChrsAXoN3wc2hO3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294899; c=relaxed/simple;
	bh=QitxyfiUiKuyUZvh92Kv/u2axb83XUJK//BgsLIW9A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbyi9T9AS/TXnn+TBTAojZRjjalXA8ruAld8VkVyuuNPbpjZtUw7IdUXqgTobfEKvfmmHRhmdJPc5N4istW+EzP1QUbaz8WLejvUF1cZs+Zl9LdHefiL/P5clM3K/yCa6J1mIWZPpTDESJ/0wV/7YrgBHtQk/DMmzzlwGwb040w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1q+w2tu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1q+w2tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CE31F000E9;
	Wed, 20 May 2026 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294897;
	bh=A+6sD6keqWscORHu1UE3KpFurbqsdOCCDnXG0IylpVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1q+w2tuwaAt/IYZkbHciSqOE0ckTliMpaNjkygOHMdD6AxuNnqWf7uKU4/D8fH5L
	 zizG3U1mmpsXCQyvqM32qP0TWVaXogWdGgLzzv7viiJYHHq8+b/5u8NWVuH+9XgP/U
	 Q4OCZaicgWusGm3nBd0IZz+InuCaeCLlZNYuvLcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0173/1146] net: bcmgenet: fix off-by-one in bcmgenet_put_txcb
Date: Wed, 20 May 2026 18:07:03 +0200
Message-ID: <20260520162152.200844178@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 57f3f53d2c9c5a9e133596e2f7bc1c50688a6d38 ]

The write_ptr points to the next open tx_cb. We want to return the
tx_cb that gets rewinded, so we must rewind the pointer first then
return the tx_cb that it points to. That way the txcb can be correctly
cleaned up.

Fixes: 876dbadd53a7 ("net: bcmgenet: Fix unmapping of fragments in bcmgenet_xmit()")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260406175756.134567-2-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 482a31e7b72bc..0f6e4baba25b9 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1819,15 +1819,15 @@ static struct enet_cb *bcmgenet_put_txcb(struct bcmgenet_priv *priv,
 {
 	struct enet_cb *tx_cb_ptr;
 
-	tx_cb_ptr = ring->cbs;
-	tx_cb_ptr += ring->write_ptr - ring->cb_ptr;
-
 	/* Rewinding local write pointer */
 	if (ring->write_ptr == ring->cb_ptr)
 		ring->write_ptr = ring->end_ptr;
 	else
 		ring->write_ptr--;
 
+	tx_cb_ptr = ring->cbs;
+	tx_cb_ptr += ring->write_ptr - ring->cb_ptr;
+
 	return tx_cb_ptr;
 }
 
-- 
2.53.0



