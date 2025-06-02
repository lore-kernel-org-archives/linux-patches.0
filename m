Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C55D22A4E8;
	Mon,  2 Jun 2025 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876406; cv=none; b=ruDs8IwiCDBes15zxpHrGutSHZ9D1qxeFUpJOERMPoWqCwB+GFGJ+r3eFYG19RyB0MZUqJxyu5x5F6T0ss+XsgKDnJASX7bEVLuckV6OMHqS6YJaBy25xdPc5pNFFvUlwpMhxcprpExG5BQykZUddU+fPpC09mIF8KeLirqWnZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876406; c=relaxed/simple;
	bh=T1zJ+nBIVmfDof2kFrvUvt+tMacjY5bOm36AuYnNJNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxHDoDEbc49Q4mR62AwHnZP6HiabgItFUmBZxs8XOscZCwroeh0ifFEmZZjaBsMWVMvAnIOqihXbxTDmZwMWYW4NfeEDhSuRklM7E1Ah5FJoxKp2haCcNgosXVdzr2c+lIyoma1FY7+NO1Jy08Eh/NqQDsJv/p1Hjcg4ga0jiWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3S49DHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3S49DHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7DBC4CEF0;
	Mon,  2 Jun 2025 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876405;
	bh=T1zJ+nBIVmfDof2kFrvUvt+tMacjY5bOm36AuYnNJNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3S49DHKvFP9umFIYCJbYeDHTFigpYbJCIBoju3Eq+pFSLkPZRJ1QYyjfKiFOb+dI
	 i1j6SmEiNNVjI3f6FZlmOm5DEHzBPLe6nbc+LlWdYIrj8yJQPHMSZaSTdWMhB9JGi1
	 fEQi+49D3hHE9vqbmwTjyXLeOehgQNUqwOrVC0lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+55c12726619ff85ce1f6@syzkaller.appspotmail.com,
	Wang Liang <wangliang74@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/207] net/tipc: fix slab-use-after-free Read in tipc_aead_encrypt_done
Date: Mon,  2 Jun 2025 15:49:00 +0200
Message-ID: <20250602134305.317887898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit e279024617134c94fd3e37470156534d5f2b3472 ]

Syzbot reported a slab-use-after-free with the following call trace:

  ==================================================================
  BUG: KASAN: slab-use-after-free in tipc_aead_encrypt_done+0x4bd/0x510 net/tipc/crypto.c:840
  Read of size 8 at addr ffff88807a733000 by task kworker/1:0/25

  Call Trace:
   kasan_report+0xd9/0x110 mm/kasan/report.c:601
   tipc_aead_encrypt_done+0x4bd/0x510 net/tipc/crypto.c:840
   crypto_request_complete include/crypto/algapi.h:266
   aead_request_complete include/crypto/internal/aead.h:85
   cryptd_aead_crypt+0x3b8/0x750 crypto/cryptd.c:772
   crypto_request_complete include/crypto/algapi.h:266
   cryptd_queue_worker+0x131/0x200 crypto/cryptd.c:181
   process_one_work+0x9fb/0x1b60 kernel/workqueue.c:3231

  Allocated by task 8355:
   kzalloc_noprof include/linux/slab.h:778
   tipc_crypto_start+0xcc/0x9e0 net/tipc/crypto.c:1466
   tipc_init_net+0x2dd/0x430 net/tipc/core.c:72
   ops_init+0xb9/0x650 net/core/net_namespace.c:139
   setup_net+0x435/0xb40 net/core/net_namespace.c:343
   copy_net_ns+0x2f0/0x670 net/core/net_namespace.c:508
   create_new_namespaces+0x3ea/0xb10 kernel/nsproxy.c:110
   unshare_nsproxy_namespaces+0xc0/0x1f0 kernel/nsproxy.c:228
   ksys_unshare+0x419/0x970 kernel/fork.c:3323
   __do_sys_unshare kernel/fork.c:3394

  Freed by task 63:
   kfree+0x12a/0x3b0 mm/slub.c:4557
   tipc_crypto_stop+0x23c/0x500 net/tipc/crypto.c:1539
   tipc_exit_net+0x8c/0x110 net/tipc/core.c:119
   ops_exit_list+0xb0/0x180 net/core/net_namespace.c:173
   cleanup_net+0x5b7/0xbf0 net/core/net_namespace.c:640
   process_one_work+0x9fb/0x1b60 kernel/workqueue.c:3231

After freed the tipc_crypto tx by delete namespace, tipc_aead_encrypt_done
may still visit it in cryptd_queue_worker workqueue.

I reproduce this issue by:
  ip netns add ns1
  ip link add veth1 type veth peer name veth2
  ip link set veth1 netns ns1
  ip netns exec ns1 tipc bearer enable media eth dev veth1
  ip netns exec ns1 tipc node set key this_is_a_master_key master
  ip netns exec ns1 tipc bearer disable media eth dev veth1
  ip netns del ns1

The key of reproduction is that, simd_aead_encrypt is interrupted, leading
to crypto_simd_usable() return false. Thus, the cryptd_queue_worker is
triggered, and the tipc_crypto tx will be visited.

  tipc_disc_timeout
    tipc_bearer_xmit_skb
      tipc_crypto_xmit
        tipc_aead_encrypt
          crypto_aead_encrypt
            // encrypt()
            simd_aead_encrypt
              // crypto_simd_usable() is false
              child = &ctx->cryptd_tfm->base;

  simd_aead_encrypt
    crypto_aead_encrypt
      // encrypt()
      cryptd_aead_encrypt_enqueue
        cryptd_aead_enqueue
          cryptd_enqueue_request
            // trigger cryptd_queue_worker
            queue_work_on(smp_processor_id(), cryptd_wq, &cpu_queue->work)

Fix this by holding net reference count before encrypt.

Reported-by: syzbot+55c12726619ff85ce1f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=55c12726619ff85ce1f6
Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Link: https://patch.msgid.link/20250520101404.1341730-1-wangliang74@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index b09c4a17b283e..35e0ffa1bd84b 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -828,12 +828,16 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 		goto exit;
 	}
 
+	/* Get net to avoid freed tipc_crypto when delete namespace */
+	get_net(aead->crypto->net);
+
 	/* Now, do encrypt */
 	rc = crypto_aead_encrypt(req);
 	if (rc == -EINPROGRESS || rc == -EBUSY)
 		return rc;
 
 	tipc_bearer_put(b);
+	put_net(aead->crypto->net);
 
 exit:
 	kfree(ctx);
@@ -871,6 +875,7 @@ static void tipc_aead_encrypt_done(struct crypto_async_request *base, int err)
 	kfree(tx_ctx);
 	tipc_bearer_put(b);
 	tipc_aead_put(aead);
+	put_net(net);
 }
 
 /**
-- 
2.39.5



