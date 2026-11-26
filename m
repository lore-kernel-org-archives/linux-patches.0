Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704233;
	b=VdpjRXYU/oytHm050LvzZu9bQLGksZ29A9ugs45l4Sn9QEv+oqmwMxTJ03EzsKV9gBDm
	 439e4PquvzfbsKDsyMJJUa75C55NMxc9a8kimTkbbYoTq46gP0jEbpl6ZH77kbSGbYm+F
	 7fQj9lvcD9N2+vF+L2YYXoAe9SJy20ZYk6QFXl326yB2kqgznGDEAOBrzpWMO/8te2jZz
	 Pm5cdQ2e6+7wyXGhoLs/8RvJQzfKkJo2utQ8SN0Sjt303jrbsveXYsfPq0unuTLWVOyu0
	 8hGEj3Ab2hdvp101COr+nkrB7j/UtZtiN3ZwPtGFI+4FQCBc4ifXZPUQxZUeC8ESUNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2sK2yplJkSu8LRm8NTer97TDwrN314siHaCDLtK/Hm4=;
	b=1oMAhkC8pAkG1e2c2Q0iqrNcDnvjgGg+zy8qje84zbFqzKMnUPZECsrpv9vbUZZbdFVG
	 sat5fnq+KVLa07vCqzllemKRjI8HL2p/GWo7rR2zfqc4LLTBDzMVZfK1MeP/KPXvL8kEl
	 6goReLMHC1JrXifLTChYFiP9qh31iG8+7t8LNo5PgX17agzTjiKd2SWo/f62Kan+KGszQ
	 Ypz0f9t/iEnYcvzuGCtsL+zkZcfZMOli/k3On3I/XELsUzkWYYbgAIztaJ3ebu54UCcFP
	 NntSEZE8fNRmbTs9+lL9a45XPfN37CLOH15vlPqla3EiOX+sWJWjavGddmW/pKjo7dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zA5RpCH4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2CE606A683;
	Thu, 26 Nov 2026 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zA5RpCH4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABAD1F000C6;
	Thu, 26 Nov 2026 14:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704232;
	bh=2sK2yplJkSu8LRm8NTer97TDwrN314siHaCDLtK/Hm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zA5RpCH4nGdXKf3uTbvp+ZKZYRTRXFiQOwPBQL3KuVmLe17AlXZfSEFyufqsh17Wb
	 wa57cFDx5e7Y/RUBdZ1xGtqZ5CDoq7h6JWTKpYpzfmiXRvsftSAX8jagL2tee92HQb
	 +DxuvdyZzna9/S0ZZ/Au6x3pQ3Zq1wC2fqV2YFkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/265] vhost-scsi: preserve event ordering
Date: Thu, 26 Nov 2026 15:36:15 +0100
Message-ID: <20261126143608.241876218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3b15955751fa2..a32520fe5a828 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -532,7 +532,7 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
 	struct llist_node *llnode;
 
 	mutex_lock(&vq->mutex);
-	llnode = llist_del_all(&vs->vs_event_list);
+	llnode = llist_reverse_order(llist_del_all(&vs->vs_event_list));
 	llist_for_each_entry_safe(evt, t, llnode, list) {
 		vhost_scsi_do_evt_work(vs, evt);
 		vhost_scsi_free_evt(vs, evt);
-- 
2.53.0



