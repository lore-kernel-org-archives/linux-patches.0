Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA2C8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634A6C433EF;
	Mon, 13 Feb 2023 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300547;
	bh=R0lN8Z5FfDjyLf92iHh7nrJIb/VnR8+FkTh32q0ID8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HS/zdCO6LaZ6lb3BrVgBop1cmhUlO8IgY3HYkmat76L4WjkdPb16Q/SqUoC8jYENo
	 M3yf0NQ4CWQGx361WSM84LLNYwOQ/KYPCH0l7mp+R8/YQnuw8vG0fKs/zaMPK61nug
	 z8JtWj570awlsZo4L9JaIdrWeyYCIEX4SuSCs8ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/139] qede: execute xdp_do_flush() before napi_complete_done()
Date: Mon, 13 Feb 2023 15:49:43 +0100
Message-Id: <20230213144747.673274141@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 2ccce20d51faa0178086163ccb6c84a099a87ab4 ]

Make sure that xdp_do_flush() is always executed before
napi_complete_done(). This is important for two reasons. First, a
redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
napi context X on CPU Y will be followed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found following the first link below.

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in the second link below.

Fixes: d1b25b79e162b ("qede: add .ndo_xdp_xmit() and XDP_REDIRECT support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 5b1885c0a8bd..a632de208a7d 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1456,6 +1456,10 @@ int qede_poll(struct napi_struct *napi, int budget)
 	rx_work_done = (likely(fp->type & QEDE_FASTPATH_RX) &&
 			qede_has_rx_work(fp->rxq)) ?
 			qede_rx_int(fp, budget) : 0;
+
+	if (fp->xdp_xmit & QEDE_XDP_REDIRECT)
+		xdp_do_flush();
+
 	/* Handle case where we are called by netpoll with a budget of 0 */
 	if (rx_work_done < budget || !budget) {
 		if (!qede_poll_is_more_work(fp)) {
@@ -1475,9 +1479,6 @@ int qede_poll(struct napi_struct *napi, int budget)
 		qede_update_tx_producer(fp->xdp_tx);
 	}
 
-	if (fp->xdp_xmit & QEDE_XDP_REDIRECT)
-		xdp_do_flush_map();
-
 	return rx_work_done;
 }
 
-- 
2.39.0



