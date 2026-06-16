Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F1243D4E8;
	Tue, 16 Jun 2026 18:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635295; cv=none; b=MmA9bVsHwKuftO3Jo0d2uRW6V8rdbu/xmNXuUAB6H7+2CuRMfRnrIFb1FFGPhkC5n6NSO2OOPgH/bweULspGo00d+ygZ9cNBi27biow2wyCZa5WAIq/1Xlcuhzk3wRRO8uwvRPezQelbYNfluUR0fwKIaPSXOBVJFGHc9Gshnz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635295; c=relaxed/simple;
	bh=mUXFtCsNJPTwbv9jPirN9phJQQ168ffK3TBVLzwSl3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gK8tgyoH6AXAWPCTxMf0tUh75zGEBLK7hLDue8sToeP82CLlam+qNsIgHpS7GCoJbak7ujH7dF8rlhmaqCRcQ60WLK3mkiicnpIlZf/mbf30nZVFKUaRvZXnrm81tYo9OFEluLzWkMUqlLlZnjKlJrzXImuBkYIfOTPWMt3fc6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9Rg8Z54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9Rg8Z54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE271F000E9;
	Tue, 16 Jun 2026 18:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635294;
	bh=t7nc+OFlJMNRYU89ds9JhCtaJba7AUOXYyzDi0Nb5SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9Rg8Z54jjLpIveidjFfmC7mEHCa1N06FD7hDIEmlcXg1nCCL7GEUUrAVy6Te9id+
	 3CmYlXcuStO2M4xICXJF4gmkbwzW65QvArFAaDYC3xuDOpfH1DlpXiDIWpLotvUWcg
	 wFvm6cWSXHwMSqzDDgNTBmwe6zG9Oa8j/AWoGsBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/342] tun: free page on short-frame rejection in tun_xdp_one()
Date: Tue, 16 Jun 2026 20:25:10 +0530
Message-ID: <20260616145048.958691317@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit f4feb1e20058e407cb00f45aff47f5b7e19a6bbf ]

tun_xdp_one() returns -EINVAL on a frame shorter than ETH_HLEN without
freeing the page that vhost_net_build_xdp() allocated for it.
tun_sendmsg() discards that -EINVAL and still returns total_len, so
vhost_tx_batch() takes the success path and never frees the page; each
short frame in a batch leaks one page-frag chunk.

A local process that can open /dev/net/tun and /dev/vhost-net can hit
this path: it attaches a tun/tap device as the vhost-net backend and
feeds TX descriptors whose length minus the virtio-net header is below
ETH_HLEN. Each kick leaks the page-frag chunks for that batch, and a
tight submission loop exhausts host memory and triggers an OOM panic.
Free the page before returning -EINVAL, matching the XDP-program error
path in the same function.

Fixes: 049584807f1d ("tun: add missing verification for short frame")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260520160020.375349-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3a89f9457fa242..930086d79f97c8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2472,8 +2472,10 @@ static int tun_xdp_one(struct tun_struct *tun,
 	bool skb_xdp = false;
 	struct page *page;
 
-	if (unlikely(datasize < ETH_HLEN))
+	if (unlikely(datasize < ETH_HLEN)) {
+		put_page(virt_to_head_page(xdp->data));
 		return -EINVAL;
+	}
 
 	xdp_prog = rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
-- 
2.53.0



