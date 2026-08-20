Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D41C380FDB;
	Thu, 20 Aug 2026 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238820; cv=none; b=RGyJ1Ff5muW86Gd547qv7i19vM9Ei6huE1p6yQeGjsy0D0C8tJgyb3N3BeocJDlqDRSC4WmnMApSb038NBh1BGzJVg0qYo1P84VhWDjLghbGHngcfgs8PUZ9BoXxna94i7ywoAn6rBJzd7qTHkS4trujPLIbFifrPVPa9UxzVq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238820; c=relaxed/simple;
	bh=y3f0PemaufXi3nCWjslrLFNMJ0uTYgo1KuA9DNmGqw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz0t+D0hQ9tYv+zZieoSNnY1hg88XhL+nytEUf2FI1QaIO5tS2ZEr7r3zAgZNsxRkj4HfLRGNW0P1H7J4W/8ZZ0P8N5Z02VFYu+E3LKqpMX0Tmd4C6e176aVf1Md6vuj9trj+KCD5uoy0rY9yTEwrB/NLySt2uhzeXiQPXsmTVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kh+8BHup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kh+8BHup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847AC1F00A3E;
	Thu, 20 Aug 2026 15:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238819;
	bh=eVeyVnsTvY79q27D6ujcNFqLcBGTVjSg6hLYFvZTmpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kh+8BHupxtvEp4FqqH2gzSegy7d3AsZYTapBoyoCOOPFHTJ4CzqaMpUz9lwuQta3M
	 GARm73ZGv+NyGG8gnpotPZxsoQx8fpridOF0w0mCDVHXibHKVoA837QRW5o+PI4be3
	 PbEeL5EkMLwDzmwKLZXr6KT1FOiQf7PuyHo5iphQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 053/217] gve: fix zero-length skb frag with header-split
Date: Thu, 20 Aug 2026 16:53:41 +0200
Message-ID: <20260820145239.213877664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Jordan Rhee <jordanrhee@google.com>

commit 6bf14575c65569dcded90ef78afb8a6d57323f04 upstream.

When header split is enabled and a header-only packet is
received such as a pure TCP ACK, GVE will indicate an
RX SKB with a zero-length fragment. If this SKB is then
hairpinned and sent back out, the GVE TX path will emit
a zero-length descriptor. Hardware considers this
an illegal descriptor and stops the queue, causing a
TX timeout and interface reset.

Fix it by not adding the zero-length skb frag.

Cc: stable@vger.kernel.org
Fixes: 5e37d8254e7f ("gve: Add header split data path")
Suggested-by: Praveen Kaligineedi <pkaligineedi@google.com>
Co-developed-by: Ziwei Xiao <ziweixiao@google.com>
Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
Signed-off-by: Jordan Rhee <jordanrhee@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20260807224315.234152-2-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -859,6 +859,11 @@ static int gve_rx_dqo(struct napi_struct
 		rx->rx_hsplit_unsplit_pkt += unsplit;
 		rx->rx_hsplit_bytes += hdr_len;
 		u64_stats_update_end(&rx->statss);
+
+		if (!buf_len) {
+			gve_free_buffer(rx, buf_state);
+			return 0;
+		}
 	} else if (!rx->ctx.skb_head && rx->dqo.page_pool &&
 		   netmem_is_net_iov(buf_state->page_info.netmem)) {
 		/* when header split is disabled, the header went to the packet


