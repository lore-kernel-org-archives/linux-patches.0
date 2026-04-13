Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0B330BF68;
	Mon, 13 Apr 2026 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097754; cv=none; b=qR3o7xeH2tE2O/op2axNsMjyq8pPnqFeCzFVVBOPIAU0DWi1sJ5q7qnBo9IG7x5zcaW8NImkN6SsevIF8Cwl4B5eC5/9VzDk937GrdY4OSLYw8oSNSeUftmY7sZ9CmujTEf1k9hmEPBZMOceDy9aIc/FgCs/eVsLoYtiM9Ka0aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097754; c=relaxed/simple;
	bh=EQXlne2zWfR23TQmys2ul2WmzJXWzsz3L2cUHm2r5lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awn/V8W3w9wJnhw8lhWqxeBSro21HkL4tePfM6MFtGGHw8OUl8sLyi+G05/j9Vokfwu13a1saGyOd7SNW2J+veluBUAG0PUfqkxAky++2tRqcGlYElTmzFBfLCofF3tq7QtyF4+R1WiPIyqobTAv71gLh75hAYkteMUE8upaNvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8JR9k3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8JR9k3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ED1C2BCAF;
	Mon, 13 Apr 2026 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097754;
	bh=EQXlne2zWfR23TQmys2ul2WmzJXWzsz3L2cUHm2r5lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8JR9k3Iho7jS0FWyZrixhwvwviuMg26s0kHOBSNlI0berdqB1NpOqkP2iXrrJjba
	 M/k3G79/gma9Hec7YSeiX5ID8Ff8P7xuUNmhxOB2PcKyKct6o0RXtO67K5Z43buh9a
	 pw+lH5crSAb3B2nWuv/kFbwfThCUki7lyX5dDU04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Melnychenko <a.melnychenko@vyos.io>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/570] netfilter: nft_ct: add seqadj extension for natted connections
Date: Mon, 13 Apr 2026 17:56:29 +0200
Message-ID: <20260413155840.138199080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Andrii Melnychenko <a.melnychenko@vyos.io>

[ Upstream commit 90918e3b6404c2a37837b8f11692471b4c512de2 ]

Sequence adjustment may be required for FTP traffic with PASV/EPSV modes.
due to need to re-write packet payload (IP, port) on the ftp control
connection. This can require changes to the TCP length and expected
seq / ack_seq.

The easiest way to reproduce this issue is with PASV mode.
Example ruleset:
table inet ftp_nat {
        ct helper ftp_helper {
                type "ftp" protocol tcp
                l3proto inet
        }

        chain prerouting {
                type filter hook prerouting priority 0; policy accept;
                tcp dport 21 ct state new ct helper set "ftp_helper"
        }
}
table ip nat {
        chain prerouting {
                type nat hook prerouting priority -100; policy accept;
                tcp dport 21 dnat ip prefix to ip daddr map {
			192.168.100.1 : 192.168.13.2/32 }
        }

        chain postrouting {
                type nat hook postrouting priority 100 ; policy accept;
                tcp sport 21 snat ip prefix to ip saddr map {
			192.168.13.2 : 192.168.100.1/32 }
        }
}

Note that the ftp helper gets assigned *after* the dnat setup.

The inverse (nat after helper assign) is handled by an existing
check in nf_nat_setup_info() and will not show the problem.

Topoloy:

 +-------------------+     +----------------------------------+
 | FTP: 192.168.13.2 | <-> | NAT: 192.168.13.3, 192.168.100.1 |
 +-------------------+     +----------------------------------+
                                      |
                         +-----------------------+
                         | Client: 192.168.100.2 |
                         +-----------------------+

ftp nat changes do not work as expected in this case:
Connected to 192.168.100.1.
[..]
ftp> epsv
EPSV/EPRT on IPv4 off.
ftp> ls
227 Entering passive mode (192,168,100,1,209,129).
421 Service not available, remote server has closed connection.

Kernel logs:
Missing nfct_seqadj_ext_add() setup call
WARNING: CPU: 1 PID: 0 at net/netfilter/nf_conntrack_seqadj.c:41
[..]
 __nf_nat_mangle_tcp_packet+0x100/0x160 [nf_nat]
 nf_nat_ftp+0x142/0x280 [nf_nat_ftp]
 help+0x4d1/0x880 [nf_conntrack_ftp]
 nf_confirm+0x122/0x2e0 [nf_conntrack]
 nf_hook_slow+0x3c/0xb0
 ..

Fix this by adding the required extension when a conntrack helper is assigned
to a connection that has a nat binding.

Fixes: 1a64edf54f55 ("netfilter: nft_ct: add helper set support")
Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 36eae0956f65 ("netfilter: nft_ct: drop pending enqueued packets on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 83bb3f110ea84..3edfdf06bea6a 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -22,6 +22,7 @@
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -1109,6 +1110,10 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 	if (help) {
 		rcu_assign_pointer(help->helper, to_assign);
 		set_bit(IPS_HELPER_BIT, &ct->status);
+
+		if ((ct->status & IPS_NAT_MASK) && !nfct_seqadj(ct))
+			if (!nfct_seqadj_ext_add(ct))
+				regs->verdict.code = NF_DROP;
 	}
 }
 
-- 
2.51.0



