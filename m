Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B094ABBCD;
	Thu, 17 Sep 2026 17:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666285; cv=none; b=niBLAu2nrY33kIDlj2Uyr3cFTR0Z9HFlfAYvkp99RoxjgjoPNKUy4qPkJPNnwxHV9zvLHbbg2tl8RXQ869b54FIf2KdNlVLgmZXH9PuTUX6xlqw+Xdr7qSH3DYEmXlE1R0XRXv3tb6MVhp0j98hsNtanQDNJmtWhMhvTnIYn5Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666285; c=relaxed/simple;
	bh=kQ1wU0WqY0gS6uGrvPsu812QnqpPqaSCouig4wmDits=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsTfqdxhlVlxvU4BE7QxUNuQdPBKbU/C578ATMaMR42A1JuYvhccG4sliEuePzRdjV2pI86cqoQrs+PF7AYFhU+hB0asNzrzJwkX0Cxd8qMQ6i8nR9hfVUt/kYTMiXU4xotK4pcMZ+HOd87jE09aaF/4qK/DttXjYDkcpzcc1Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2nQXgws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2nQXgws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1771F000FF;
	Thu, 17 Sep 2026 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666284;
	bh=xQ/k2CSBCzDEJJraf1qafPjDF1801V7IHCz13BseTI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2nQXgwsKHrUkd8lpM/XV4N3cQJWm2WBpmG0kRt5pM+fGelX/6KW0sX2AxZNC674t
	 FXDy7RXvn6JmlIedKoTfPhm66HYgC824lf1ttH/iCY+HS2D5vFnL9ZbnCNdhdyS4yd
	 lS+YzrB/3oMSVXX0a2kZGMLAVagEaE2qlm9Me7EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0938/1250] net: mana: restore the XDP program pointer when pre-allocation fails
Date: Thu, 17 Sep 2026 16:12:13 +0100
Message-ID: <20260917151617.441722329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Long Li <longli@microsoft.com>

[ Upstream commit 4c46beb807efcc93f5899ebe1f5958248eb296c6 ]

mana_xdp_set() publishes the new program into apc->bpf_prog before it
allocates anything, because mana_pre_alloc_rxbufs() sizes the buffers
from it via mana_get_rxbuf_cfg(). When that allocation fails the
function returns the error directly, skipping the err_dealloc_rxbuffs
label which is the only place that restores the previous pointer.

The attach is reported as failed, so the BPF core drops the reference it
held for the caller and the program can be freed, while apc->bpf_prog
still points at it. The next consumer of mana_xdp_get() - typically
mana_chn_setxdp() from mana_alloc_queues() on the following ifup, or
after a TX timeout reset - then calls bpf_prog_add() on freed memory.

This is reachable from an ordinary "ip link set dev ethX xdp obj ..."
whenever the per-queue RX buffer pre-allocation cannot be satisfied.

Restore the previous program on that error path.

Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260904202640.3900685-1-longli@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 7697c9b52ed34..7bb8382940b38 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -208,6 +208,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "XDP: Insufficient memory for tx/rx re-config");
+			apc->bpf_prog = old_prog;
 			return err;
 		}
 
-- 
2.53.0



