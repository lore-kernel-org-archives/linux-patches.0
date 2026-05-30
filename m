Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEB23191D0;
	Sat, 30 May 2026 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160976; cv=none; b=d60qxA7fWtVKzJgB5Yxa5l+xI2EPBMDJCxbxsXndBtuKLyzPMGw5PTjebM0SBOtVTPKQk5BLjVTRsqwK3oodvfR3DqzRspq/ys/1zStBcKkgGHdBmEuPYnR5Sxweu6TEdVfWuj8XSanSD+/01WEJW2ma6ZF5ad0bsxBqnFkMy+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160976; c=relaxed/simple;
	bh=2QrWKbR3dNZLNGzzsfW3xzYTMDpFzEpxzMad+KAkbbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1i/vlr4CExckWaKYxE5B936onRtPkwaJaU/QmWJ2hNHARhtSb7XXoiArl2C78/VymFJsV8N6cNz4iaqYQCkh4LNV4tCc1ACH+WhFWzaRVFed9Gzol9mo/TWoFsxdlxfJvAFrBIB2DvBPhgTeeLGuWHkRQVifZTlkwlaZQe9I1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YE2hy+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YE2hy+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA981F00893;
	Sat, 30 May 2026 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160975;
	bh=ORmaUHakZjU1rqGYbuyHOvjfIUiTPbAdUpzX/inJ3A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YE2hy+L3URa4JYkf9sEtjf4txnPySd5WHcNvfgVcfYjMUYFaNw0MaIClWF8o4dR2
	 D107hmyKagLYFcAR5lViTDd9v0DPbCd+rhM/6jBB1rjVC0l7GQtoYFz/FIQChuwQDn
	 UhsE9FjRkK7ySzzgogdSHouT3JfBghAoDpY+tyT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 489/969] sctp: fix missing encap_port propagation for GSO fragments
Date: Sat, 30 May 2026 18:00:13 +0200
Message-ID: <20260530160313.814653513@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



