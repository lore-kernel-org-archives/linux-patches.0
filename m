Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677D23A2576;
	Sat, 12 Sep 2026 20:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243428; cv=none; b=dQgPZTCWrV0TzJ+jnM1leeG6ZFL7C1kppGrGpOyzmAU//J7Hk0SlAVa580V9sDrJQHg4iYs7Es4ijz03txWn+dxgrqOk8SYEyPo8/wZ/s3vwyeYBtny7m6WPqpqoz2L1tTEQRBTn1mNIqGT06j3Vb3/0JXHcDs7qEhvUqw3cS5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243428; c=relaxed/simple;
	bh=6yLNC49/G5LePEYQsGCvTduM2/ux0J92n713CTkr97o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaoLXbDMqsx2oJc2chiQLUuFRJDRYyRRnZiVx6H0WxZviSulHJYOt3jSADdDLxSgU/0dFkK8EbrsJNEW+iolK3SfJ5UQUB/CwHUh1Sk8jWuDvOee8eGWCf/LR5oxL9+lDjw5FGCUPEY25631GvmPZhjgo6TTUYGqmgSHf8sEUi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiZBlpsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiZBlpsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35421F000FF;
	Sat, 12 Sep 2026 20:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243427;
	bh=0L45eqgvM+S9sR9n/SA7y8u+cv+OFybvUkzZGJCh4nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tiZBlpsRqacNk6UtKvI16VXBfCBbDVly835ydLatWpFhEq29bKhtpYCpavnqHN4j6
	 4iyKY5keWjlrsenMILbqTF+shtaWHhok9adr4rcSaTvDCVHVs7mrPjDLVMEU+hiXcE
	 hvQAJQuJw/d/6mDLIbNxOz96FUlsUCNwp08so5/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 753/798] gtp: add synchronize_net() in gtp_newlink() error path to prevent use-after-free
Date: Sat, 12 Sep 2026 09:06:21 +0200
Message-ID: <20260912065534.327089090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 155ae9b1e4d9a..624220f8ec132 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -695,6 +695,8 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
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



