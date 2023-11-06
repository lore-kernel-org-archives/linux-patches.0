Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D850241FC
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kr/Xmnm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9442C433C9;
	Mon,  6 Nov 2023 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277621;
	bh=J3ngFomkvBuGJltBkHnUUoF6HOAGqfvn+1+4pxy/Plg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kr/Xmnm6lxGxrsfENdarBcy0nCiMgJzPpS/7tnu9jqLKLh79lgZr+DlO3/j27QAx1
	 C5tfviYPHbb7wrdQQAJpxDzU1k5s+GOxDe6n6TIf4ofh9s7SxfBAwiymhtojm6baVP
	 TUFclvaEzLAF4P6NHCb8PwlbTX4Y4O6aov6t63Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Menschel <menschel.p@posteo.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH 5.10 80/95] can: isotp: Add error message if txqueuelen is too small
Date: Mon,  6 Nov 2023 14:04:48 +0100
Message-ID: <20231106130307.633135023@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Menschel <menschel.p@posteo.de>

commit c69d190f7bb9a03cf5237d45a457993730d01605 upstream

This patch adds an additional error message in case that txqueuelen is
set too small and advices the user to increase txqueuelen.

This is likely to happen even with small transfers if txqueuelen is at
default value 10 frames.

Link: https://lore.kernel.org/r/20210427052150.2308-4-menschel.p@posteo.de
Signed-off-by: Patrick Menschel <menschel.p@posteo.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -813,10 +813,12 @@ isotp_tx_burst:
 		can_skb_set_owner(skb, sk);
 
 		can_send_ret = can_send(skb, 1);
-		if (can_send_ret)
+		if (can_send_ret) {
 			pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 				       __func__, ERR_PTR(can_send_ret));
-
+			if (can_send_ret == -ENOBUFS)
+				pr_notice_once("can-isotp: tx queue is full, increasing txqueuelen may prevent this error\n");
+		}
 		if (so->tx.idx >= so->tx.len) {
 			/* we are done */
 			so->tx.state = ISOTP_IDLE;


