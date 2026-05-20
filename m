Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C489D3F44D9;
	Wed, 20 May 2026 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297824; cv=none; b=ojB3cE20e/OMXFsaTS7yBAPTyaRHNI+eiaGeV2mf2Yi9lTYIh+R/fFNDS5dUnoVOb9PCStLbFh4xH86VdBLmU+6H6tDcKajw0kNPBGhmxa9Aux+WyPPl/tcHDY+OkkcbbjaT7IwwUVms9kdbGdNUD6MsvtgjUv22zYQRBHaP1+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297824; c=relaxed/simple;
	bh=28T6z7FYpkZGR7PJ5/7SR8RZYZmLUCrp9nnt0uap5pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2CMkfrdzK4nrkEdSYkqavdyGFWIAdPIJEdQXbOttMSjL7V2Cj6Ew/jaCIygKgqLU5CT8KQyv6x7uSGnbBhp68dA/Rt7H9kCGUWJOqmxLCOj8oF4e3ft5c+z2tDZ+5SKN+8VjTV2RVgy/EY2bi8FVVbGzVVxrFjZ96Dr0EnxZWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zekEoFx3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zekEoFx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3386D1F000E9;
	Wed, 20 May 2026 17:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297822;
	bh=D/9vCC/7LF/pqdUSYvrFgbT8PoOPyNw+IBaqjgyVT1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zekEoFx3yCVJNZjJWKw38ZUX3pGqwHWxtrtblxJREFHim/IGMe/3bqwbA2EUqGNjK
	 A4FwWxAU3V6SwoaeSv+whOAKaOU0j5jLlQedkZijThDyR+/UiPv20VhBghU3UADbk5
	 6FyoKsGXdovYgbM2yn7Ga4zv76Temp96vdBoBTUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/957] net: bcmgenet: fix off-by-one in bcmgenet_put_txcb
Date: Wed, 20 May 2026 18:10:19 +0200
Message-ID: <20260520162137.504464934@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index e142939d87cbe..1791523b83383 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1815,15 +1815,15 @@ static struct enet_cb *bcmgenet_put_txcb(struct bcmgenet_priv *priv,
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



