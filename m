Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EB72D5C76;
	Tue, 12 Aug 2025 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021294; cv=none; b=TkBzousokqdngSY2wQkbPm3KyXgQytAcXyEnrAxK+eTRZBNWF4mYgPssKosNZ36O+pRnEmVINRz2EE09eJaLvja9eqn0xgSi8ab4Xf92Rtk89uEENkTaQBnpbmZniIXU+Q2vR/YcU+6IlYljzQFV9qP+2JQREX2/pv2ZcGmXNXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021294; c=relaxed/simple;
	bh=Mk0T2+1NknJOs+m74u6SxXoHjGrBFY+PTOceAVxtgRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AieQ3dLYU1YtUCMPsEATtAzjw2qVwRRwPx2i4Kg8FIpD65UFRi102nzfwIA0hgP6p7AiYB1oKYm3MVElv4XOiVVjGFS9d4wmYlzbj0Zvo2VUX4+tbG3GCmpr3Aa2S9iJQOxNwme5RPq6GOdtniygAY7egHx7INu1UQtRSCcIm2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2exskgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2exskgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3932DC4CEF0;
	Tue, 12 Aug 2025 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021294;
	bh=Mk0T2+1NknJOs+m74u6SxXoHjGrBFY+PTOceAVxtgRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2exskgM89BNv6z7JDUHcB0GfQRVc0O5PlQwtBhoC9Qwdpk670i7i4bjoG6I2P8A7
	 U34M6tsknk88KaVhzLytGxoDQG7Lqs+lMzPjhGB1f2WiNEy9N8YdVu8jErJ/4gxTdB
	 DJUpiWsmMCuUovr5rkrv61K3IZFOlSAuh8BWgd+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/253] netpoll: prevent hanging NAPI when netcons gets enabled
Date: Tue, 12 Aug 2025 19:30:06 +0200
Message-ID: <20250812172958.115384882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2da4def0f487f24bbb0cece3bb2bcdcb918a0b72 ]

Paolo spotted hangs in NIPA running driver tests against virtio.
The tests hang in virtnet_close() -> virtnet_napi_tx_disable().

The problem is only reproducible if running multiple of our tests
in sequence (I used TEST_PROGS="xdp.py ping.py netcons_basic.sh \
netpoll_basic.py stats.py"). Initial suspicion was that this is
a simple case of double-disable of NAPI, but instrumenting the
code reveals:

 Deadlocked on NAPI ffff888007cd82c0 (virtnet_poll_tx):
   state: 0x37, disabled: false, owner: 0, listed: false, weight: 64

The NAPI was not in fact disabled, owner is 0 (rather than -1),
so the NAPI "thinks" it's scheduled for CPU 0 but it's not listed
(!list_empty(&n->poll_list) => false). It seems odd that normal NAPI
processing would wedge itself like this.

Better suspicion is that netpoll gets enabled while NAPI is polling,
and also grabs the NAPI instance. This confuses napi_complete_done():

  [netpoll]                                   [normal NAPI]
                                        napi_poll()
                                          have = netpoll_poll_lock()
                                            rcu_access_pointer(dev->npinfo)
                                              return NULL # no netpoll
                                          __napi_poll()
					    ->poll(->weight)
  poll_napi()
    cmpxchg(->poll_owner, -1, cpu)
      poll_one_napi()
        set_bit(NAPI_STATE_NPSVC, ->state)
                                              napi_complete_done()
                                                if (NAPIF_STATE_NPSVC)
                                                  return false
                                           # exit without clearing SCHED

This feels very unlikely, but perhaps virtio has some interactions
with the hypervisor in the NAPI ->poll that makes the race window
larger?

Best I could to to prove the theory was to add and trigger this
warning in napi_poll (just before netpoll_poll_unlock()):

      WARN_ONCE(!have && rcu_access_pointer(n->dev->npinfo) &&
                napi_is_scheduled(n) && list_empty(&n->poll_list),
                "NAPI race with netpoll %px", n);

If this warning hits the next virtio_close() will hang.

This patch survived 30 test iterations without a hang (without it
the longest clean run was around 10). Credit for triggering this
goes to Breno's recent netconsole tests.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/c5a93ed1-9abe-4880-a3bb-8d1678018b1d@redhat.com
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://patch.msgid.link/20250726010846.1105875-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 657abbb7d0d7..89f5358d7a1b 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -800,6 +800,13 @@ int netpoll_setup(struct netpoll *np)
 		goto put;
 	netdev_tracker_alloc(ndev, &np->dev_tracker, GFP_KERNEL);
 	rtnl_unlock();
+
+	/* Make sure all NAPI polls which started before dev->npinfo
+	 * was visible have exited before we start calling NAPI poll.
+	 * NAPI skips locking if dev->npinfo is NULL.
+	 */
+	synchronize_rcu();
+
 	return 0;
 
 put:
-- 
2.39.5



