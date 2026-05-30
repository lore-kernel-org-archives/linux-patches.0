Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA58329C6D;
	Sat, 30 May 2026 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163961; cv=none; b=FroTEveczptYcmgvfq98BsvMGvN4e6hQadFsiSkgb1VLR4lKBjDPLFjYrb4q7efR/dzjOH2b90DAKaXCTlTL8YE22H0OqW8JRIaNumjiXypfWNjkB/YGyqfYaaSA4imumCqMOLGvVY7mTYhlDDPtpcbSMx470tzM4kR/j6nIRVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163961; c=relaxed/simple;
	bh=gVjsgbIJIowI3ycJrrHhTtSY6OoBtGqCLdTOlnMcCSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiCPqVJXGKIDLQkkChlxnW17rNg3l+ofPT6c0KOjKPWP70wtNN7Ss3xAdWo9YdiPu17QvkGemkhJYEa7VTtxyEAUikUofGWRVIQs64HyV61K/ura/FMerbuuAqaC3kDv1xuJFIIHR78fya3JeM9T+MAWIks4+LES6NtSuYEvWxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sn5s9YDH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sn5s9YDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2581F00893;
	Sat, 30 May 2026 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163960;
	bh=lhqRU8/xxPq5VjBzafMVaRjgJWmab9j87CqOfc1vdC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sn5s9YDHBxU06tCh0QfuaET0r2toluiCQwxBcT+d5Apr5MnYloYPWQIxY1mJip+wU
	 +292dgfoT6YuCGxnxslkMHIdD8h0mrYNbVZGB8cXrPJPStY3rP8w3UHBmGo9qBR46l
	 mBmO2h6lpbGfrOfdt0xt4GtN3+GOszsPQ/b1j/IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 413/776] net: bcmgenet: fix off-by-one in bcmgenet_put_txcb
Date: Sat, 30 May 2026 18:02:07 +0200
Message-ID: <20260530160251.157391179@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4b8bb99b58eb2..8a7077e6903b2 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1700,15 +1700,15 @@ static struct enet_cb *bcmgenet_put_txcb(struct bcmgenet_priv *priv,
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



