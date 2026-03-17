Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A4E26FD9B;
	Tue, 17 Mar 2026 17:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767520; cv=none; b=Rc2mVTxcwc0TwXoGDPhEvgfFYcjB0eHQtD8wsAa+7Q5Y5RGaO+bOOQHeu7UA6A8lrj3B9abE2HPNDayBesIcjTKwOGdl/6dxFKgJhDPXV3Sdn5TYySSRwqEHr4DL1RnTtwBYQ3jBPp320nbYK1MOKMI7EsreMR27/7j8fcJB3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767520; c=relaxed/simple;
	bh=N2tXL+fD/FMqSCwYFTwl/2AZCStaVgT+R63cUvvilCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ua3IVsX00EobNYHz38bk5U4VXNaIwvK/j1CSauzQ4yR00LBHAzeASq1xFcGCo2f6hJU1NWD4QelvE+DGqiXVm28SZCAy7dxZdG8E8tUbG2OZU5fvqx29AAog+rqkkkOOaxHelc4pFIuycIJ5utDAzdIYyBGKkTsWg6IfmsMCXCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXIe+Qph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXIe+Qph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBAFC4CEF7;
	Tue, 17 Mar 2026 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767520;
	bh=N2tXL+fD/FMqSCwYFTwl/2AZCStaVgT+R63cUvvilCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXIe+QphTcmaABNmt3DKMgMDPOdnSA4xftwNx6FInYc0PMpShmaDgHo45Br8vk83+
	 c6GyI5LgeFIUuxqjTde67Q+TFr3LMcWBzS9+hvA/l4B+FLH8aD06zgXlSFAtbKffw5
	 1Tyqr7JnKcj8MxbsdD76a+ZBnmCvIKXE7w6Rso4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/333] netfilter: nfnetlink_cthelper: fix OOB read in nfnl_cthelper_dump_table()
Date: Tue, 17 Mar 2026 17:31:40 +0100
Message-ID: <20260317163002.009654616@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 6dcee8496d53165b2d8a5909b3050b62ae71fe89 ]

nfnl_cthelper_dump_table() has a 'goto restart' that jumps to a label
inside the for loop body.  When the "last" helper saved in cb->args[1]
is deleted between dump rounds, every entry fails the (cur != last)
check, so cb->args[1] is never cleared.  The for loop finishes with
cb->args[0] == nf_ct_helper_hsize, and the 'goto restart' jumps back
into the loop body bypassing the bounds check, causing an 8-byte
out-of-bounds read on nf_ct_helper_hash[nf_ct_helper_hsize].

The 'goto restart' block was meant to re-traverse the current bucket
when "last" is no longer found, but it was placed after the for loop
instead of inside it.  Move the block into the for loop body so that
the restart only occurs while cb->args[0] is still within bounds.

 BUG: KASAN: slab-out-of-bounds in nfnl_cthelper_dump_table+0x9f/0x1b0
 Read of size 8 at addr ffff888104ca3000 by task poc_cthelper/131
 Call Trace:
  nfnl_cthelper_dump_table+0x9f/0x1b0
  netlink_dump+0x333/0x880
  netlink_recvmsg+0x3e2/0x4b0
  sock_recvmsg+0xde/0xf0
  __sys_recvfrom+0x150/0x200
  __x64_sys_recvfrom+0x76/0x90
  do_syscall_64+0xc3/0x6e0

 Allocated by task 1:
  __kvmalloc_node_noprof+0x21b/0x700
  nf_ct_alloc_hashtable+0x65/0xd0
  nf_conntrack_helper_init+0x21/0x60
  nf_conntrack_init_start+0x18d/0x300
  nf_conntrack_standalone_init+0x12/0xc0

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_cthelper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 97248963a7d3b..71a248cca746a 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -603,10 +603,10 @@ nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 				goto out;
 			}
 		}
-	}
-	if (cb->args[1]) {
-		cb->args[1] = 0;
-		goto restart;
+		if (cb->args[1]) {
+			cb->args[1] = 0;
+			goto restart;
+		}
 	}
 out:
 	rcu_read_unlock();
-- 
2.51.0



