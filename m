Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063685;
	b=g2WTWJocN7xS9UUEUtNIrGiUjByKPYf4ckJyyn7MjO5UmYKM/t9kF8Z3XQ3KKYhfp4tu
	 LltIik6O+tWdTcL8iO7LUD8kPVwx386aVjXWcflv5VW9NFk0ip1iORbK+7dinaAqu518k
	 rPUjCQlKuh6I/USGNoZTrRoepT1qMPuod0yBHsM0IF6ukbNN9W+36noY79z6qxyD9VcyI
	 7PBPD8ScIPunOiKLdCW867e8uRgVCffSbH0qbnXPcA2ohEkf95d9E1WXLmBk7HyLH+wHZ
	 LUmpEsPkr3z3GLO4k1A90L+Y0qWlg7IUl34NoNF9xsUkJaqxE4S+8atDW1XCnz494oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+hcs/3N3Grc3Xtf6cwIfoHhndTMSDVLyD3CQmVSHkAs=;
	b=OG0vRiuoXcMlKZjhyG0G7QIOD1S/zz6npELKqQ2zsB5jNqJeCVYcvyeys8WMWLrJOijk
	 TnnDxrFrwOYt+zIB9BW4rdbGewwd7G+JcsFLLkkqDyBi33Dcj5NB1Rn2unal056UhirML
	 kcDIVyk1IJ4FV8TyhH5giPG/tTzJ5e4YpUg4bjkAsV5svuAFuAJMNuVCdnWfwqjzjDF3Q
	 IbwXagOSPFmOHE+Djt6t9hyRbHtyrPl6LDrM0bTf7PAq3Ky32+tplEocZ2W8OyM0AFgfS
	 NRTEWZCC37CLNE9ru9cKd5PotoxzWzmV28HLFkZTJ6SJ71Ih9yqT/W1xmrryNy0MSyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQNqgGsf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6AC606A33C;
	Sat,  7 Nov 2026 15:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQNqgGsf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D69A1F008A1;
	Sat,  7 Nov 2026 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063685;
	bh=+hcs/3N3Grc3Xtf6cwIfoHhndTMSDVLyD3CQmVSHkAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQNqgGsf5DNiZw+kUvs7xrHe4kLRLljLscKP4rgMZKvsdCbGNT8t2fYb9rgdPMe7W
	 4oQhdegxSkpayaqzkwtUrHZxj8o6o9UaxhvApkggxWK15w5PGZP07Wj03X7eqjNq4d
	 bD7iJPw86LjExbvHwNEbZvatkEe4Exb/mmmnNCYA=
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
Subject: [PATCH 6.18 792/869] bonding: fix out-of-bounds read of arp_ip_target
Date: Sat,  7 Nov 2026 08:57:54 -0500
Message-ID: <20261107134919.603255078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index baafc13603d3d..2e9e1b4d74da9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6270,7 +6270,7 @@ static int __init bond_check_params(struct bond_params *params)
 	}
 
 	for (arp_ip_count = 0, i = 0;
-	     (arp_ip_count < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
+	     (i < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
 		__be32 ip;
 
 		/* not a complete check, but good enough to catch mistakes */
-- 
2.53.0



