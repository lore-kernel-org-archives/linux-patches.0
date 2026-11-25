Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624392;
	b=B6u+kwMUEvj99xTEgLcmvlsQgYbOW1ENNDJo6pcZ7yyAvrwnR0ovpFadg8vziY14QzFe
	 LdiEKtfoXFTh8MjGUEdGxsmtFC+rEpmz063mEe2S2rmYc6IXxShcAiYBZR8aqvnNqIHoH
	 5uHZb43txR6WaD3V7iVn4DtNwKmVgOugIgKmeuHzsMCeiDqKCTl043SGcv09c5AgnGLC3
	 oXiVEY950VBBDkcIq+fIoWdeDM/Iuu2dJVi3RllVO7JhUa0qPEIZAuTeFbzdLj1GhN9w1
	 E7qVrqG54HtfvVrsx3BAbqBfRW9rW3LQzfwc43W39moOy/gQeMxYNVPQukXGZUwlq9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E8h28RBLBV9ybbI/mIWKwykDR32p2XW1xjzR5ZMppcM=;
	b=bqt/yM49TL38B9uIDORN6DB7gx920Smo+fhzPiSvuXAt7VfWNBQlyV1DN+5ajtpxxjKx
	 zC8t7+iMQnaWbQldwiaWA/HexycUXxDPAVlWCQEfHGaG/u81qMvzkzlt1Z9UOmpvfu69x
	 DP58jWtuChaVBbaLG7Tc42BucHnRNNDeE7QAVIRkq8IqRhjMzQtYZtAHu86Rb3ij+j4JS
	 tbwbzZTBWHngcHxSdO6ldj8fyQ1ZrF7w4+eM8HQ3BA9vNl1D9a/14ZX+mq89yNk7LJytG
	 ju6qx5E/LRTokk7W/nL76k+OTRrdI1KMgVTp7I9VHZLeFgk7G8FH/OZpn001WN0Rq5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaEMdIty;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6137606A68E;
	Wed, 25 Nov 2026 16:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaEMdIty
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149BF1F000D0;
	Wed, 25 Nov 2026 16:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624392;
	bh=E8h28RBLBV9ybbI/mIWKwykDR32p2XW1xjzR5ZMppcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaEMdIty2E7guMjU/1CogJ0CsKiovUlhXRruCm2g09/K+oX54iWrjEsuhY+297aSG
	 BnJ7D1peSw6YrePgCF173jQAsvaXIR0ofRVd1qLb/xfm/N9B0lhoXTjFabx0xgRQUk
	 r1HF7Lcnr+4OnuRJ2WyZrLM2JFFBjzzxK4/axmxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/816] vhost-scsi: preserve event ordering
Date: Wed, 25 Nov 2026 15:28:01 +0100
Message-ID: <20261125143852.282592636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit a9a428115b7d8aa45e12e41899f90f60551bfa82 ]

vhost_scsi_send_evt() uses llist_add(), so pending events are LIFO.
vhost_scsi_complete_events() walks the detached list directly.
This can deliver a later hotplug or hotunplug event before an earlier
one.

Reverse the detached list before processing it.
This keeps delivery in enqueue order.

Fixes: a6c9af87363c ("tcm_vhost: Add hotplug/hotunplug support")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260915094244.7900-2-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c7773ff350ed4..5f7480db273a6 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -515,7 +515,7 @@ static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
 	struct llist_node *llnode;
 
 	mutex_lock(&vq->mutex);
-	llnode = llist_del_all(&vs->vs_event_list);
+	llnode = llist_reverse_order(llist_del_all(&vs->vs_event_list));
 	llist_for_each_entry_safe(evt, t, llnode, list) {
 		if (!drop)
 			vhost_scsi_do_evt_work(vs, evt);
-- 
2.53.0



