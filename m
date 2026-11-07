Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065443;
	b=vBCITtPA6aVqjwbEK3DQFeWFZOxy4F3bBfsJqlr2PKc8qLpu17HkNoe5uxF52rnVEFse
	 xNz1HCzNhAAwkZFAvc7B048o3KdfELr2/+8lJBwjHMRirwVbv1KfLpZeS0scC472r0RPv
	 YmCxHZB31Gavg44APPigYchCbyBjYSg5eDe98zV/g0bNgecnwAkziL8TlGR3qjktWe8Ws
	 4m6UfiSsVuwv+KrGPPRYScnOB4JRBI3EyoL80AXlnUl5TXwWqBxJGYzrlhexRa85zPdkW
	 hhlpoFrGzqg6lJceMPvwhmVeW5U1SVmwPCpEj1ULFsDtWBc+TICvPe2vMdda4/alQvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PZ28nY5PHIBdiCluuHAs88gxWrLL+DV9Evw3N/pdHNE=;
	b=pXQhK+4EAvt4gbJ/Js4+Hkax+p6iSxjsWQLDDtqUDt15dSs9x8TjBJOaDBy4CIa33iSq
	 f7bgUI7yH3c6d/FNpm5t63OcR9b5DYlJSLDPwZoI/ACZPc/TPnS1vkVxYrwarHFRtL4fe
	 SHf2rEBFfTj4GpeqAMjsNUiuxspxwEmRPQmcIVm/E/wEUSCiuq0Gp7OY0ix+EjwEIxF4i
	 DAwzlhYptDJ+0Ys25Xp64xHYRibpACYaWiCWqNqQrd+gH74pv2RbMPEbsBUCBavM8n0HA
	 pvF2nO4GP8bvUwDI2Y3DDugCG6SIR8TWRXw5OOPDtC9YlZAG9NhHIuXRGYBNDJDSU4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZz5wgxx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033AC606A32C;
	Sat,  7 Nov 2026 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZz5wgxx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F911F0089F;
	Sat,  7 Nov 2026 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065442;
	bh=PZ28nY5PHIBdiCluuHAs88gxWrLL+DV9Evw3N/pdHNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZz5wgxxd68mpqwTc94MevLEdSjDLXATpvqPeadcSzu3VHgePKTKrVAF/iJRMkogS
	 4x6zS7KSzD1z2uzzRiFBVFTl8qOTEe4sfpW2Wl68p5v5IjTdDcjowoVeyM1vX9lhjV
	 LAnDFdtfpPZM0tIYA/iYZnK2TKrl50s1+m/1AYcw=
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
Subject: [PATCH 7.3 1148/1257] bonding: fix out-of-bounds read of arp_ip_target
Date: Sat,  7 Nov 2026 08:57:24 -0500
Message-ID: <20261107135010.920752006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 09aa45d71fabb..7019e5d8fdc8e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6273,7 +6273,7 @@ static int __init bond_check_params(struct bond_params *params)
 	}
 
 	for (arp_ip_count = 0, i = 0;
-	     (arp_ip_count < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
+	     (i < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
 		__be32 ip;
 
 		/* not a complete check, but good enough to catch mistakes */
-- 
2.53.0



