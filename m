Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55D537DAC2;
	Thu, 20 Aug 2026 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238306; cv=none; b=jIAZCFYpoQBJMVniveSCUzff1K+Mi/bbgs1XR5m08lXMpAaKngC+XiiAalaBtr8LJoT/qHTEIRh7ExWQPj07q3kucPzWT18kHBjGBTgcz2ig5xtdA3UQGDDP2tJ+AYv4dGxgr7KWxLKZzEYJ/U+mim5ODuR1mBTKg4xDoTMSD7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238306; c=relaxed/simple;
	bh=7Pgtv/xbfO6X7ril2oVde07VfF/lu7k/dIcRZ2GncWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYDbwTIZSVX3/65/p3VNSp/hyoUR1wY0cjpHM8FeIVsxmg1mkBdfCJ4Qc9+QlxEuymnuQv5JSft927m0+63xsIv/N7WoMTY9PYUQ7mDaqpeigpyQu+oJFs1RWpQTNeDYfPpUin/tuHXCvO9IAH82tWILBwJk0pumYqkUEMf5PNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nd7/O4yK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nd7/O4yK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495E51F000E9;
	Thu, 20 Aug 2026 15:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238304;
	bh=xs0bXB50oqGXsLokiVbv6Q3cIqqK60XsMDI/oHWOztg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nd7/O4yKqUdRKG5xFtbgY+qcoeQUBnUaamqTb7Jvh7vBJx1l+rB+1ZCRpmbWUpbav
	 +ZvVFDJ/o0nGGTfxQHp6ZXoCiQ2qEj9JiH9UMdWpExlJUhBHJJLOw207OvVd6PvPMh
	 tMJqYZOXHIS94/D1YCRSpK8ADgtMzXioVOiWG5xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 062/228] gve: fix zero-length skb frag with header-split
Date: Thu, 20 Aug 2026 16:53:24 +0200
Message-ID: <20260820145246.353741026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -886,6 +886,11 @@ static int gve_rx_dqo(struct napi_struct
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


