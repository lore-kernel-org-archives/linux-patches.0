Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037074;
	b=P0SAwD5NGGQOwYEwOL6aVl5H2ybMpBB5f2GXDVZp2kPJzKC1KdjsygHe6wkjVzJT+O4d
	 bZUorCqNhEwXvrTyTM7Cwsl3ZWa0DVUx5ftrTlYcu9j3LMcbOKDPkQQuIlj7Y2MrDKOdZ
	 sfVYF0PMjKW+5ytfZPOwIeIOa+vPY/u2eDbtNp7hLBe/y7yJUgAKgEVbuQMxW+/yuMVZd
	 Cr2klDCmkrxDN8KFzMpHfR/Mfu87qdUnJwXqf4YoB93SiXINhPsed16ai/KflkKLve9ON
	 hx2oASedxxAkASDQlpdbLWkyKabJhqksjOT+TuTqHQ7H57Hp0sE/wpI8rVho67WAF4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xGwOBddSdnP97bUtJFYTBARfjJ0/bD191iUIKKVaM6I=;
	b=rPRAzb0v1jpwa2GT2cXceDCqoU0Rw1/X0PSYKFzgw3PG54jjuB8VnVvriHg8RdY9nS3m
	 8RHWKQIcz/G2PPVynhlW+VEJ/RBxNZnv7EsNY1Q5KwzMpMNj4cCXkhJF+udn/eVsilcaV
	 ZAi/VCIYRY8u1+kbDZ+hzrAT2DcssYQYfDph8fELyblSHFr5rzHfS9Wn85sgPNOTRBnpY
	 pndIiMP0dJY2o+JPrJV1XHPHTnQ/5sPN3p4S6508/4OJkaMc9iq1cWBPV3s1D+piOpEdM
	 JRlwD8UGsfnXUR8Vm8hxl9ecLcGXN8FMIQwkSDhaki/Opr1XXBFt+0bRhgQHnuw14tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dlx7za8s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48866606A31C;
	Wed, 18 Nov 2026 21:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dlx7za8s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697901F000C4;
	Wed, 18 Nov 2026 21:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037073;
	bh=xGwOBddSdnP97bUtJFYTBARfjJ0/bD191iUIKKVaM6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dlx7za8smJd62LKu6nZQ5nUSquneTGPabRANhiA7V5jtu2Ur65y50yATqWI6q/oA6
	 +prm3U8+3GtgAakzk2K+ZKaereGHU2blhVBG4Ba0tkDEPY7j6ZyZoVRyj7sibON0O6
	 15ePl3YIhRlke99vnqhq8jIOJRZcF7bpprKOJ3Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1247/3318] bonding: fix out-of-bounds read of arp_ip_target
Date: Wed, 18 Nov 2026 15:31:09 +0100
Message-ID: <20261118150357.601544075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit a81513bf5bdf29cf00c0a11f56be515c1ec260f4 ]

arp_ip_target is a module parameter array with BOND_MAX_ARP_TARGETS
entries. In the loop parsing it in bond_check_params(), arp_ip_count is
the number of accepted targets, while i is the index into
arp_ip_target. Invalid and duplicate entries are skipped without
bumping arp_ip_count, so bounding the loop with arp_ip_count lets i run
past the end of arp_ip_target, e.g. 16 targets with one duplicate:

  BUG: KASAN: global-out-of-bounds in bond_check_params.constprop.0+0x1148/0x1440
  Read of size 8 at addr ffffffff96e9ee00 by task swapper/0/1
  Call Trace:
   <TASK>
   dump_stack_lvl+0x91/0xf0
   print_report+0xd1/0x630
   kasan_report+0xf3/0x130
   __asan_report_load8_noabort+0x14/0x30
   bond_check_params.constprop.0+0x1148/0x1440
   bonding_init+0x13/0xe0
   do_one_initcall+0xe7/0x5b0
   kernel_init_freeable+0xa91/0x1120
   kernel_init+0x24/0x220
   ret_from_fork+0x5b3/0x820
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  The buggy address belongs to the variable:
   arp_ip_target+0x80/0xa0

Bound the loop with i instead. arp_ip_count never exceeds i, so it
stays within BOND_MAX_ARP_TARGETS too.

Fixes: 5a5c5fd48e3b ("bonding: arp_ip_count and arp_targets can be wrong")
Cc: stable@vger.kernel.org
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20261023104528.232427-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e480c692513f0..7acf6afb29b03 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6282,7 +6282,7 @@ static int __init bond_check_params(struct bond_params *params)
 	}
 
 	for (arp_ip_count = 0, i = 0;
-	     (arp_ip_count < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
+	     (i < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
 		__be32 ip;
 
 		/* not a complete check, but good enough to catch mistakes */
-- 
2.53.0



