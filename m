Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2143C0A12;
	Wed, 20 May 2026 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294909; cv=none; b=cIaIkirOcGNiJWg9jj2j5Tw6zqkaJZn6DgeKagkN0+Jv0UetgKC+2rtHmY7TgFJRHVzeWLs2wcI3aRkABB63bin/DA9+mkpejUfbES39XjIoBph04XmoNjT5MEisYgj9s4T1Fkn6bGbYnMWtjeypTtK6cwTlfwAVE6SpDtdMOfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294909; c=relaxed/simple;
	bh=SAy0dAuHxS7Tel98PdubaZA7donBuEtp8KRilD+Sw18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ16aoxEqj4q3VvttAk+KzmybPH+x0pl23unasfFlR/oGXtL8ajC12wrn0ee8L4iMSa87bGd0hl+JcxYeCRAG/sXI4bjYxeFZ2jV/oYvECpHwhmGTE6dcImGWtotWI5F8T1shlEO+evl19p3Wnj9oCdefNIPveBx+yy5V923pOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lk4uwm3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lk4uwm3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DDE1F000E9;
	Wed, 20 May 2026 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294908;
	bh=h/5xFrFXzCQNRo9k3AqbhwZD5oEyshdhaZOy0MivmbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lk4uwm3AO72kHkXeOiFQixV2CfRSixlZIgqREgUUumoLoLddKLVW5Q0kf/PrqsdJQ
	 GU75Z4a4q5daAudU+GrK4ad17PZlkqkma9DGzCt0eKFMMi3phRN0bagoNyVAugf0xX
	 JWYdZTcFP+CUJHiA6dwf2HMlJ0i2U89lusDDrQrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0219/1146] sctp: fix missing encap_port propagation for GSO fragments
Date: Wed, 20 May 2026 18:07:49 +0200
Message-ID: <20260520162153.214086405@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit bf6f95ae3b8b2638c0e1d6d802d50983ce5d0f45 ]

encap_port in SCTP_INPUT_CB(skb) is used by sctp_vtag_verify() for
SCTP-over-UDP processing. In the GSO case, it is only set on the head
skb, while fragment skbs leave it 0.

This results in fragment skbs seeing encap_port == 0, breaking
SCTP-over-UDP connections.

Fix it by propagating encap_port from the head skb cb when initializing
fragment skbs in sctp_inq_pop().

Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/ea65ed61b3598d8b4940f0170b9aa1762307e6c3.1776017631.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/inqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index f5a7d5a387555..a024c08432471 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -201,6 +201,7 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue)
 
 			cb->chunk = head_cb->chunk;
 			cb->af = head_cb->af;
+			cb->encap_port = head_cb->encap_port;
 		}
 	}
 
-- 
2.53.0



