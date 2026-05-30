Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D93546F6;
	Sat, 30 May 2026 18:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166212; cv=none; b=FdyoIV18lf9bdFWfyAlQ9858TkToi4ACut5Lblnv8OkmBchIgZ6dj+1K3wRWPXyBdEX9YZ9ish1awHIQyn0myCYpYhwzCQMENbVTAwrbL0Few8UgLujF0tJyB9EeFjVmFOEi7sEiYjdv1kMw4BFJLHMTvhLleCvSQLi+dV9JzHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166212; c=relaxed/simple;
	bh=XEc7kb5xRPZLwDjOl71p0M4F2RwmGVO8RMdgb7bIkwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0IPpTf5b+jktobmg8xnegYF+UMMR3eyjz8lwFlKv9oHv9KR9gkANfv+Omr/Cu3lI3UCgTdcfGZXvS03Pf4vYsklBJXDd0W6UcAssFZaSM+VVIUiUo4YDLgehAobDctaJyP9yjR5yf6jXkUew4P9smupa8NPD7vX10014etjjI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bx1zRzAt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bx1zRzAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EC41F00893;
	Sat, 30 May 2026 18:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166211;
	bh=9N7QarNWBOGFLmY3wzJswskGuyyx3TD5ZMrhMKxLNsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bx1zRzAtuJaoG1KKiz/kxVP+UFbZGDlMR1fs3gp8QYvV97Mip2d06xzS3W1fJwXuS
	 4Lcd3qDeQntKLy0aQ6vSriXpAt6pu2fpy6WBk0sns59esfNjhJQMmItJoKmTemlAB8
	 JJh7WVYD3oQhdQIXFaYZ6n99qhYW6ZK3PFx8X+xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/589] net: bcmgenet: fix off-by-one in bcmgenet_put_txcb
Date: Sat, 30 May 2026 18:03:07 +0200
Message-ID: <20260530160232.995928062@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
index 2fc21aae1004e..8a68384383f7d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1696,15 +1696,15 @@ static struct enet_cb *bcmgenet_put_txcb(struct bcmgenet_priv *priv,
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



