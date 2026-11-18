Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027803;
	b=HAOPIG9TJvqN0SQh90iDK8ZtFH1F4j24ObfGX3qgosYOo10UufyFwrnsT4J8L+jlTfsZ
	 7uvOAQdSjZeuzKHAZEBM1rPHhsO8vv5RijwNI6wIJpi8sYqbsKDxDWQfceG81tgnma+eh
	 dH0Oalthay8A/TkqI3oYbCX0GkbSahfD2oEOMMn1r1wDLyXivVVIyyIQC7ewY9vf0HyU6
	 hCVBeighthseKVUekRweawRQhVCtqPpEaSyPGxZnP5+jScA8ymFK6r8oHd+nZCXx2faK9
	 Bt+bKW6geKDZZn0KbQ52RSMIHGHeHs7DsNYOTJeIIDZIVZWFO8QQyOFgGb0/xWCQcOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CqYQyMGoDhdwRa1SV3beKVIP0ABWS/xm3SBuLqlmMFU=;
	b=4MhlaEaHeHLdCDzDFVq0Og4TuxukRvqDTLV+QrWsNir517MUZ4HIWwrfCY5LsPw1AkvW
	 TLpr0uNP9lPqvyzK/opoFxIfVPfaAusUgD0Ncmf6b348Ucj+pA/75z7KMgr2ISxWwSKWu
	 eH5syMI/9wKtz6Qh/EWJqs84Ior/AiPBDMOzKAW/aRQPDcEFAZL0Ok9ZgYID8+Wedh/3W
	 XNzJLmXptdbwFwsro9iau/UDpa11YvSj2GvOEbRcnao0cdp9n83QEJvnoQOXdiITMZ6bz
	 znrIvqmB3hDdPgQHgedF+ZpNIDbASYM5t1AQ/6SfxrcuL90fH5/Hj/gg94lkLWGBtJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oj436G3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDE7606A330;
	Wed, 18 Nov 2026 18:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oj436G3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0D21F000C4;
	Wed, 18 Nov 2026 18:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027803;
	bh=CqYQyMGoDhdwRa1SV3beKVIP0ABWS/xm3SBuLqlmMFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oj436G3IQsdFOEqKtGb8UX+xqZkZGC/NEThTgPfQQ3gTUDecwuEE3qetLfBoxKu1y
	 XFIsz/wyDS0cOD0ckRMU+XJqG+inYamArqjJQw2h7s0MYymhUJyjCJiR/prl6Hr6ZJ
	 yVAE3prOy7l0RPpZWiTPDv5Uh7gXFn0UPV8IzEi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Daskalakis <daskald@meta.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1920/2151] eth: fbnic: Correct packet header prefetch
Date: Wed, 18 Nov 2026 16:00:55 +0100
Message-ID: <20261118150231.722565312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Daskalakis <daskald@meta.com>

[ Upstream commit 286154ae6998a32cca698abd713e1d4728e81924 ]

The existing call to net_prefetch() fetched a stale address. The data
pointer is not initialized until after the call to xdp_prepare_buff().
Thus, making the prefetch ineffective.

Open code the address calcuation to give the prefetch as much time
as possible.

This was found by manual code inspection. No issues have been observed
from this.

Fixes: 9064ab485f04 ("eth: fbnic: Prefetch packet headers on Rx")
Signed-off-by: Dimitri Daskalakis <daskald@meta.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261020172706.1090951-1-dimitri.daskalakis1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 946c2997d2122..d7ca0216155bf 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -1008,7 +1008,7 @@ static void fbnic_pkt_prepare(struct fbnic_napi_vector *nv, u64 rcd,
 
 	/* Build frame around buffer */
 	hdr_start = page_address(page) + hdr_pg_start;
-	net_prefetch(pkt->buff.data);
+	net_prefetch(hdr_start + headroom);
 	xdp_prepare_buff(&pkt->buff, hdr_start, headroom,
 			 len - FBNIC_RX_PAD, true);
 
-- 
2.53.0



