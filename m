Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CCF79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C76C433D2;
	Thu, 12 Jan 2023 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534202;
	bh=rjPdyl7KFXfPTEGq8LPt5qFP6UjBEH0qII2hKU0+EaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5M9AchKxhAbG3m27bZP1/ZXBnEVGqdWJTpCgVyx+qzNq2FWfKjisT1Z4edpnyZsv
	 HSsfMLeyrogqyFeaW/G2ig57pnNc0vXYe2aZCgUwEN06WPbW/PDw90rQg7bboVHr0z
	 qDXV+CuPRPWZnoAGu4SJcWdvQApnC2ExTumIBCCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@gmail.com>,
	Shawn Bohrer <sbohrer@cloudflare.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 728/783] veth: Fix race with AF_XDP exposing old or uninitialized descriptors
Date: Thu, 12 Jan 2023 14:57:24 +0100
Message-Id: <20230112135558.093500585@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shawn Bohrer <sbohrer@cloudflare.com>

[ Upstream commit fa349e396e4886d742fd6501c599ec627ef1353b ]

When AF_XDP is used on on a veth interface the RX ring is updated in two
steps.  veth_xdp_rcv() removes packet descriptors from the FILL ring
fills them and places them in the RX ring updating the cached_prod
pointer.  Later xdp_do_flush() syncs the RX ring prod pointer with the
cached_prod pointer allowing user-space to see the recently filled in
descriptors.  The rings are intended to be SPSC, however the existing
order in veth_poll allows the xdp_do_flush() to run concurrently with
another CPU creating a race condition that allows user-space to see old
or uninitialized descriptors in the RX ring.  This bug has been observed
in production systems.

To summarize, we are expecting this ordering:

CPU 0 __xsk_rcv_zc()
CPU 0 __xsk_map_flush()
CPU 2 __xsk_rcv_zc()
CPU 2 __xsk_map_flush()

But we are seeing this order:

CPU 0 __xsk_rcv_zc()
CPU 2 __xsk_rcv_zc()
CPU 0 __xsk_map_flush()
CPU 2 __xsk_map_flush()

This occurs because we rely on NAPI to ensure that only one napi_poll
handler is running at a time for the given veth receive queue.
napi_schedule_prep() will prevent multiple instances from getting
scheduled. However calling napi_complete_done() signals that this
napi_poll is complete and allows subsequent calls to
napi_schedule_prep() and __napi_schedule() to succeed in scheduling a
concurrent napi_poll before the xdp_do_flush() has been called.  For the
veth driver a concurrent call to napi_schedule_prep() and
__napi_schedule() can occur on a different CPU because the veth xmit
path can additionally schedule a napi_poll creating the race.

The fix as suggested by Magnus Karlsson, is to simply move the
xdp_do_flush() call before napi_complete_done().  This syncs the
producer ring pointers before another instance of napi_poll can be
scheduled on another CPU.  It will also slightly improve performance by
moving the flush closer to when the descriptors were placed in the
RX ring.

Fixes: d1396004dd86 ("veth: Add XDP TX and REDIRECT")
Suggested-by: Magnus Karlsson <magnus.karlsson@gmail.com>
Signed-off-by: Shawn Bohrer <sbohrer@cloudflare.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 5be8ed910553..5aa23a036ed3 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -849,6 +849,9 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	xdp_set_return_frame_no_direct();
 	done = veth_xdp_rcv(rq, budget, &bq, &stats);
 
+	if (stats.xdp_redirect > 0)
+		xdp_do_flush();
+
 	if (done < budget && napi_complete_done(napi, done)) {
 		/* Write rx_notify_masked before reading ptr_ring */
 		smp_store_mb(rq->rx_notify_masked, false);
@@ -862,8 +865,6 @@ static int veth_poll(struct napi_struct *napi, int budget)
 
 	if (stats.xdp_tx > 0)
 		veth_xdp_flush(rq, &bq);
-	if (stats.xdp_redirect > 0)
-		xdp_do_flush();
 	xdp_clear_return_frame_no_direct();
 
 	return done;
-- 
2.35.1



