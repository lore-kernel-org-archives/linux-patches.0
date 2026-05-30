Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03888348C5E;
	Sat, 30 May 2026 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164036; cv=none; b=r8m5oPCKeI3yTfI3f958u1zOgvUUz3NXECCY3bjy5FSQtZl2Vs98MOzWtoRXCQSm3nEfvReRrihLTX+i+URHcpvD1OwkdDO23nOUEuiqyq1KMQCB4QLPXArdLRAWPF4IzPLioQ81pAl2GxGW4lc+j9k2gFztrA/unGaneB8nXXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164036; c=relaxed/simple;
	bh=L/2Hq873Qp9O+oUYcbpLr4KQZifM5INr84tuM+7Fd1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQIjsgJfe8Vm2iZ5kyjiOA1rcLrUU3HB2aXNFBcszkZXESwtGVIjFmGm+JnRkMPDi72TXhI0iPBF00Wf6QacPFZVt9XmBdMW4G/K4ZOMMIr/3XmBKYhy0/t0DLpIdVba9Fw1sE6PFNbAbJ/WUXhIHB+KfFWS0MvrwYVOnHsQCLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niG8oOZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niG8oOZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466F81F00893;
	Sat, 30 May 2026 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164035;
	bh=YTz/5Qrrt/WZWPOwp9kvRpWHP7Q9KGTLy5m/JCy/efQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niG8oOZAzZEs+kCfxYrV8cFitsxSHfE4ua4I3zEApYP5oNQAXzvGrucykrt708nUk
	 sMsS2IVgIJ89lj/Jeoy/kE6AJ4NaaHcaZMeldMyEIE3s31F1aI2zTYqU9OOtJyJ5xk
	 5WfWSInnxzRT7fVOZhwimGQ/vtEehCZiSv/Ni1+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 428/776] sctp: fix missing encap_port propagation for GSO fragments
Date: Sat, 30 May 2026 18:02:22 +0200
Message-ID: <20260530160251.508754167@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6a434d441dc70..6dfbd35d916d4 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -195,6 +195,7 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue)
 
 			cb->chunk = head_cb->chunk;
 			cb->af = head_cb->af;
+			cb->encap_port = head_cb->encap_port;
 		}
 	}
 
-- 
2.53.0



