Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2290313E00;
	Wed,  3 Dec 2025 15:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776864; cv=none; b=aXQG0efkAHMSbJRVhd+Rkf9tIOIqp5k6u9x/pp+Lbpqv3zBnzoyATJBMN8C++nhCPVYXsAdDnmzX7fUI12D8C/9Fj4kZxmQiq8r9RtQk71o4XY4KsyO7D36UYToT3jc0G5xT60xwJ82VYO9WpH/8cbGQPOdmPQS0W/mBOAe9dg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776864; c=relaxed/simple;
	bh=pzsk2o6X58kH3i+XJYFvbxlW8B2J24UuIVMiu8s+TkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSjnpum19hxy6E9yQepQ0D/I/40zfEZfJLj336dChmXhXvd2nUr2ST0LXPFaD0Irve0TJNl+J/Aij81rKoaKydo9MWuf4kQnWexE3BNsC4wpveEsuCr7eP/xKezxhDa1BgHECPq0sRrAJUFj1kxy74uHS4j0ngwuKw2ZYxmjNeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09MQhFpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09MQhFpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6A1C4CEF5;
	Wed,  3 Dec 2025 15:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776863;
	bh=pzsk2o6X58kH3i+XJYFvbxlW8B2J24UuIVMiu8s+TkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09MQhFpaghzPVBg/DnyoAKq3vTA0Q2AJZAA7S9YLzHzp5LEDzxJmY6pIfHlcm6AqX
	 GkvSU8ufMmHyEwW0So3uwFrVzrrIkfo+PgC4pN3c3iCbuDJQCoSYgg0THtfWUFebCm
	 ur94lwJW95iaQUab1GHFCzG8K4jgVxe/I6w5rb4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 010/146] veth: reduce XDP no_direct return section to fix race
Date: Wed,  3 Dec 2025 16:26:28 +0100
Message-ID: <20251203152346.842079621@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Dangaard Brouer <hawk@kernel.org>

[ Upstream commit a14602fcae17a3f1cb8a8521bedf31728f9e7e39 ]

As explain in commit fa349e396e48 ("veth: Fix race with AF_XDP exposing
old or uninitialized descriptors") for veth there is a chance after
napi_complete_done() that another CPU can manage start another NAPI
instance running veth_pool(). For NAPI this is correctly handled as the
napi_schedule_prep() check will prevent multiple instances from getting
scheduled, but for the remaining code in veth_pool() this can run
concurrent with the newly started NAPI instance.

The problem/race is that xdp_clear_return_frame_no_direct() isn't
designed to be nested.

Prior to commit 401cb7dae813 ("net: Reference bpf_redirect_info via
task_struct on PREEMPT_RT.") the temporary BPF net context
bpf_redirect_info was stored per CPU, where this wasn't an issue. Since
this commit the BPF context is stored in 'current' task_struct. When
running veth in threaded-NAPI mode, then the kthread becomes the storage
area. Now a race exists between two concurrent veth_pool() function calls
one exiting NAPI and one running new NAPI, both using the same BPF net
context.

Race is when another CPU gets within the xdp_set_return_frame_no_direct()
section before exiting veth_pool() calls the clear-function
xdp_clear_return_frame_no_direct().

Fixes: 401cb7dae8130 ("net: Reference bpf_redirect_info via task_struct on PREEMPT_RT.")
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/176356963888.337072.4805242001928705046.stgit@firesoul
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 35dd89aff4a94..cc502bf022d55 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -975,6 +975,9 @@ static int veth_poll(struct napi_struct *napi, int budget)
 
 	if (stats.xdp_redirect > 0)
 		xdp_do_flush();
+	if (stats.xdp_tx > 0)
+		veth_xdp_flush(rq, &bq);
+	xdp_clear_return_frame_no_direct();
 
 	if (done < budget && napi_complete_done(napi, done)) {
 		/* Write rx_notify_masked before reading ptr_ring */
@@ -987,10 +990,6 @@ static int veth_poll(struct napi_struct *napi, int budget)
 		}
 	}
 
-	if (stats.xdp_tx > 0)
-		veth_xdp_flush(rq, &bq);
-	xdp_clear_return_frame_no_direct();
-
 	/* Release backpressure per NAPI poll */
 	smp_rmb(); /* Paired with netif_tx_stop_queue set_bit */
 	if (peer_txq && netif_tx_queue_stopped(peer_txq)) {
-- 
2.51.0



