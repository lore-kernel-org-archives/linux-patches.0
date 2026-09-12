Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57B447D475;
	Sat, 12 Sep 2026 13:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219118; cv=none; b=fKxmfsaaqjXCOCS3AORQvCm1XSG03U0QwqCZhayceK7w1pOa4zdmKlzhuJdFX6mgqjdN7JgpaXsUSM0Mj8SDZ0KSNoeA1JkR3FQu4YPzi7fzt3n79eWAIA/7Twn8Gl6mF58B3+6x2HmA1nqqmf2YpgYFCvV4Y6vUO/FJ8MC4tfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219118; c=relaxed/simple;
	bh=UxPU6vCy3TRhwtNrkW78lpcTohLDbRBhY/p5CcYdPRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVAT1HLduU/rsAj/lt3ycw7jGlLiPEKqo/Cu8V+tuA3aqFjl7d/exHLMbK7I8qKVQ25gper34NygulXUuABi1Pm1KfF/I7WCPO0VmlsNh6NfGHmLWQ5qlIj3KGyMzU/zxLsfJ/mrzMnnzexP6NZSGKl6qMATKQ2kX4AnyA5Mcj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cg5KA5BV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cg5KA5BV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0B61F000FF;
	Sat, 12 Sep 2026 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219117;
	bh=oA3PrhqvcWlACcysjCt+dRw/b2hXYSGLZNJAwU8pgv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cg5KA5BVdSmZYbAD7722SEB/q4MbFSMdZbrRERsYNN3hlxBFbhpNL/cKBTlGYGGQV
	 bAirPUq3HhQA6n0x0ewNAtbc5TpbbVu26XBENNSXZA9XHMeiYfdKXHGcBXhDD+RA9H
	 YXG6UFgoxrF18Rv2eLccim7oGRiAfsXOhZP/xipE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1284/1376] gtp: add synchronize_net() in gtp_newlink() error path to prevent use-after-free
Date: Sat, 12 Sep 2026 09:01:50 +0200
Message-ID: <20260912065636.155208424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit d989e22ae9802c52c56ad4284d0caf26696cf6ae ]

gtp_newlink()'s error path frees tid_hash and addr_hash without
waiting for an RCU grace period after clearing sk_user_data. A
concurrent gtp_encap_recv() in softirq may still hold the gtp_dev
pointer obtained via rcu_dereference_sk_user_data() and access the
freed memory.

  BUG: KASAN: slab-use-after-free in gtp0_pdp_find+0x1f6/0x200 (gtp.c:152)
  Call Trace:
   <IRQ>
   gtp0_pdp_find+0x1f6/0x200
   gtp_encap_recv+0x527/0x24b0
   udp_queue_rcv_one_skb+0x75f/0xc10

Add synchronize_net() before the kfree calls in out_hashtable, which
covers all error paths from both gtp_encap_enable() and
gtp_create_sockets().

Fixes: 459aa660eb1d8ce6 ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reported-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Link: https://patch.msgid.link/20260820020735.59474-1-blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 023a791f39d92..2437b77e92279 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1544,6 +1544,8 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 out_encap:
 	gtp_encap_disable(gtp);
 out_hashtable:
+	/* Wait for RCU readers that may still reference this gtp_dev. */
+	synchronize_net();
 	kfree(gtp->addr_hash);
 	kfree(gtp->tid_hash);
 	return err;
-- 
2.53.0



