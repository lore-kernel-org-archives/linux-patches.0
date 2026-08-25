Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AE3481233;
	Tue, 25 Aug 2026 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665406; cv=none; b=d10eWTz8Yk4v0bQae70cXMHTmIkYeaVjAejSRmCaED1q9Igizwo8dBqfeXSCgybRbZdlsZb8c52d7NXp6P8yJnslvmi1uJ/rBoozNoTIB/a6G/2/56TRF6Yb70rNaORC7qqi2xl7MB5D5r1BrsUjjhmHQiEzdYKhmgazdtmWXAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665406; c=relaxed/simple;
	bh=fDHwcytRZuqTqyJyjf73BLHsgvYm/Br9Pj1FWAsJRH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAgv7qWPmK5Jht+52M2So4WZuoGU2WKZO6TM+BnzmPwpbH8MGkODBDh98EccdOOY2mNQOY1Ql81T4vEP09IK+ZhfgDb9Yiq/3XNcg3cqpYZLl3QTy+/qaTK8m47jPnEej0K3g/P8Nih2K/Chx917djK3Dm7S0GhqKZx2E0jRQpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9acxmDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9acxmDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BA61F00A3A;
	Tue, 25 Aug 2026 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665405;
	bh=10Cg9QPX8MZDNrh08Lno5HiPlFx4/BjnSPUlQcaOQf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9acxmDBOX5Nrn7RJhcJ1XU2ON1P5w+LFlcF2/Po3IxdqkkzCgBOofDlxfFnDLuZW
	 MaR+VdZJp/9Kxc5ZFK2iFtbdB8O2vouBCPMVB1BVI5tdvoK8MHkkbehfZmuo6z2nI4
	 LDUMNfVebIiYSjrPReUEtF9G5bJrNvc+/PIKH2b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 06/77] gve: fix zero-length skb frag with header-split
Date: Tue, 25 Aug 2026 15:25:28 +0200
Message-ID: <20260825132541.807608092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -850,6 +850,12 @@ static int gve_rx_dqo(struct napi_struct
 		rx->rx_hsplit_unsplit_pkt += unsplit;
 		rx->rx_hsplit_bytes += hdr_len;
 		u64_stats_update_end(&rx->statss);
+
+		if (!buf_len) {
+			gve_enqueue_buf_state(rx, &rx->dqo.recycled_buf_states,
+					      buf_state);
+			return 0;
+		}
 	}
 
 	/* Sync the portion of dma buffer for CPU to read. */


