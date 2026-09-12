Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE7C38398F;
	Sat, 12 Sep 2026 19:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240510; cv=none; b=cjioi51HmLq2XQ/dYAZwzcXlZ0NaDjfSHmHldJ7iuEZVmdZLxx3aHwZeY6T26zgWxf5zfyP5NtquhbXIurAHeuoimJ3PquhXFkUuwNQeb7zqhZA+mryvj8uDlUCcG/rDLmGRW9eMrVUtylRENZkhTDHl2531WCxzs5SWYWr53K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240510; c=relaxed/simple;
	bh=sW/o05gemMDzfC9MU/m7KvCm/3eOvYyQiF05KjmYIpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFNOFHv/IBQQ0GM/2RgZBlVwqlxyIVYQMc3DYQbXjAUz4ZMXv0aZpSk1Qi+TwN7O64hYqxTI3+iqsMNZhl5M25sPjavqnh/zeIrj2NgmYMDGotiKbNenA23skoyDVy8Xw7wtY8TaIYF8qyBi0EL1QoHXFpCLXFNHhxqcZDm72FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKiuQ74K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKiuQ74K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1851F000FF;
	Sat, 12 Sep 2026 19:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240508;
	bh=gfHykh+ZcbSt1Umtm8rmONbG2rG4KWsqohUifLHECJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKiuQ74KT5k/FjTYUis58ECAw5TNKgz5Rqs30avXR/ReBCYyNGWSdcKweia7yOaYX
	 Dkbf5/AmgxosXmMZWlVC8rbu+xe3HrdHdFlhBK3URi0SMzsMJq98HrL70ejhMB67g/
	 D3mcda+zikuFWLxBj6wKsge72BeibmvtWZitfUcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 883/935] gtp: add synchronize_net() in gtp_newlink() error path to prevent use-after-free
Date: Sat, 12 Sep 2026 09:05:13 +0200
Message-ID: <20260912065547.066563665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8f76fd927ff4a..99927adcb37a8 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -708,6 +708,8 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
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



