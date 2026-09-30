Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947C151DE1D;
	Wed, 30 Sep 2026 18:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793351; cv=none; b=iDVIkwT73WyeQt7EhQxcPGPLtPJyLVw1M0+YocSqgmx11W6SBRTK6l/GhUtMFC59CxG/xT2rt3KRkHoqKuwd/cgp6/R4so3cGSAy9KNKNW3WoJV1PxvyURxf8cxY96HrbwfOmgeKcN2Pn4cb/WD4kzNcqr24krEKuGdTM90yJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793351; c=relaxed/simple;
	bh=g+5gtjMxtnbzgHowCJvBlky23t7SP3Aidl+tcNRfrAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCYgZiCCOB/JEGiP9p6mCWzyqVbsNpUKA19LEfdz1v6dy7NIjM3mHjE08nugs37MplC53aMMsC9EKm42toEBogVeHZnVn6hSMEQHvkNhrMoknDohj0+e5IaU62rWUT3QscYn5yB2I51EacdjClWT4wbsGO4/XOT0pG5/yOmEZgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzsZEML7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzsZEML7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F9A1F000FF;
	Wed, 30 Sep 2026 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793350;
	bh=8A0IJTIWANcr+fT3Mb6pYU8W7KeGvwuQotJEvjmKcnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KzsZEML7LSzS55Edtt2UP1G5Gwy1cMbHkgl3yNgtlJjVPWz+XWYEs8otu9/jRlQ1p
	 LZQZI86iE4O2GW1oPfLNESBRVImJSxru54kOihsphb6iSWJR1IXIgg2nAVw3uVhm/N
	 TpfEzlq5GNWguTQNJdriw0bMxXeiNwGM3UY4dP3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/395] nfp: hold IPsec RX state under the XArray lock
Date: Wed, 30 Sep 2026 17:27:21 +0200
Message-ID: <20260930152344.536054394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 1a983a4e14c635c40354be110cd9a1a5c94e01e6 ]

nfp_net_ipsec_rx() drops the XArray lock before taking a reference to the
xfrm_state it found. The delete path can erase the entry and drop the last
state reference in that interval. RX can then try to increment a zero
refcount after the state has been queued for destruction.

The driver queues firmware invalidation asynchronously; the delete path
does not wait for the command to complete or drain pending RX processing.

The XFRM garbage collector waits for an RCU grace period before freeing
the state. That delays reclamation but does not make acquiring a reference
from zero valid.

Take the xfrm_state reference before releasing the XArray lock so
xa_erase() cannot run between lookup and reference acquisition.

Fixes: 57f273adbcd4 ("nfp: add framework to support ipsec offloading")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Link: https://patch.msgid.link/179001455912.44752.17153022439349797877.idr-bug-92@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 9e7c285eaa6bc..960d7513aa8dd 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -625,11 +625,12 @@ int nfp_net_ipsec_rx(struct nfp_meta_parsed *meta, struct sk_buff *skb)
 
 	xa_lock(&nn->xa_ipsec);
 	x = xa_load(&nn->xa_ipsec, saidx);
+	if (x)
+		xfrm_state_hold(x);
 	xa_unlock(&nn->xa_ipsec);
 	if (!x)
 		return -EINVAL;
 
-	xfrm_state_hold(x);
 	sp->xvec[sp->len++] = x;
 	sp->olen++;
 	xo = xfrm_offload(skb);
-- 
2.53.0



