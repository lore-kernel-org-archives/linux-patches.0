Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8134F93DC;
	Tue, 13 Oct 2026 11:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892658; cv=none; b=HCNkHF4t9Zz24nT0C3hyf4fgd9Si1uSGgO04wfikJA9DsNyOv1ZlDNiHTve+HTewmf3NPTAhqLz6rNCcQPCd6jEcdl7RBPwoxtSh1NIHT/eQJAyV7H1plJ1+THe9Uyw7dorppu6TYz6nka8v6eaW0ASopvEdMHiTig6Q7Qo6gXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892658; c=relaxed/simple;
	bh=88kwRupNi+dzJyhYlsyni1hSyt7fTfnoo/uD0C5IK9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBuE4Tt4t7bjz0WWyoq4Ji3xV9bmVZcM4Fbb9PikW15cSQviUeTBl21qviovijUiw4HUxBPZo1ff13BKBNFT424z0EvO57SZWg++MXOySGovV/Rt3NGq5092ck60whUVWqqBNHyWdUUcM1kRbV6do9EcBPx7kF/9qMWX3810AFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjqKfFVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjqKfFVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03461F00899;
	Tue, 13 Oct 2026 11:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892657;
	bh=X1i8gAUNjHNGAg0NjEPOqBe4ml7B0fVtH+T2jYeDKQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjqKfFVXJS36uKR1+V1IFOgQ1PKsyuVmJ1yY3IsISeFbADR/WRdxSktvimZwDPSZE
	 8OcW8aBjnR/SuHNDo0Zv20zCRzJlijHOs55xzybT0S+0SIrk9pRT2Ycl2vGmUVlU9V
	 z8RfKE4C+EjR9WWrOWStG3hn1+bJr1I4KU/+AowY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 219/281] net: make dev_xdp_sb_prog_count() see programs attached through a link
Date: Tue, 13 Oct 2026 13:38:55 +0200
Message-ID: <20261013112900.474500728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d333c8bca6dc3c5e978f6698d39dd799f3b0dc8d ]

ethtool refuses to enable tcp-data-split on a device running
a single-buffer XDP program (which can't deal with the payload
landing in a separate buffer). dev_xdp_sb_prog_count() only looks
at xdp_state[].prog though, ignoring bpf_link integration.
Get the prog pointer from dev_xdp_prog(), which will consult both.

bpf_xdp_link_update() needs a bit of a touch-up, too, since
ethtool calls dev_xdp_sb_prog_count() with just the instance
lock (for ops-locked devices) - we now have to make sure the
link updates happen under that lock.

Spotted by AI while reviewing the XDP propagation series,
verified and tested on netdevsim with a C test along these lines:

  link = bpf_program__attach_xdp(prog, ifindex);
  system("ethtool -G eth0 tcp-data-split on")

Fixes: 197258f0ef68 ("net: ethtool: add hds_config member in ethtool_netdev_state")
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20261001012559.297751-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6f75d1d1af32c..1a06976e19563 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10356,13 +10356,15 @@ EXPORT_SYMBOL_GPL(dev_xdp_prog_count);
 
 u8 dev_xdp_sb_prog_count(struct net_device *dev)
 {
+	struct bpf_prog *prog;
 	u8 count = 0;
 	int i;
 
-	for (i = 0; i < __MAX_XDP_MODE; i++)
-		if (dev->xdp_state[i].prog &&
-		    !dev->xdp_state[i].prog->aux->xdp_has_frags)
+	for (i = 0; i < __MAX_XDP_MODE; i++) {
+		prog = dev_xdp_prog(dev, i);
+		if (prog && !prog->aux->xdp_has_frags)
 			count++;
+	}
 	return count;
 }
 
@@ -10742,11 +10744,12 @@ static int bpf_xdp_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
 	bpf_op = dev_xdp_bpf_op(xdp_link->dev, mode);
 	err = dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
 			      xdp_link->flags, new_prog);
+	if (!err)
+		old_prog = xchg(&link->prog, new_prog);
 	netdev_unlock_ops(xdp_link->dev);
 	if (err)
 		goto out_unlock;
 
-	old_prog = xchg(&link->prog, new_prog);
 	bpf_prog_put(old_prog);
 
 out_unlock:
-- 
2.53.0



