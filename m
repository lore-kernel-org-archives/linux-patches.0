Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC2B396D28;
	Mon, 23 Mar 2026 16:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283141; cv=none; b=eV5VWC7dyLu8oQLPRNXfPPW5/zeO1PF8W8UP7ClL3W8M+15W30FhYe0ROb12ayc95LdKMZ0O4dAv9a9nK/ustYuW/t5uedkXbN3kcVL0Wh/pEqEfkdeN6DWZAz7VMEIzp4i8DllWIxFfSavMb9fZc7GLQAhm/Q4VU6iTbpNFRMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283141; c=relaxed/simple;
	bh=bC7Qk0FPGVqkV4VKUuzyxoEEdlEB50+QFkY2xXeTUg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6JUi4uJRcw1OZMSyRBX5z4919V7Mk9RFu2/WrfMNxDzxsuzSvw/xKL6UnZUgh7Hy+4xSIW4xRlL2crtA0GxTSmTieHWyZNr1qtqXmCgnYxpwN6YjV5NhQUH9Lj8UU+A3boVLxz1jn7sNMrFPkl++Epb1D1w45CAaxek611BlBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULucQv08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULucQv08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCBAC4CEF7;
	Mon, 23 Mar 2026 16:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283141;
	bh=bC7Qk0FPGVqkV4VKUuzyxoEEdlEB50+QFkY2xXeTUg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULucQv08lF7OYDGWRc75qugpzZZbpJwP//A9s1bF1PqEbBoiqW1M6FFAYg6W3uuSg
	 SUdVqXYUBw5C64tw/Agb74UtluvZJ5PLA45/GRNeuFgKCdws5BB5tSAi3ukWRZBGLw
	 yy3fr/A3dz+yH9RxA85cua5wvsEYbY2c48BzBjyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Melnychenko <a.melnychenko@vyos.io>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 415/481] netfilter: nft_ct: add seqadj extension for natted connections
Date: Mon, 23 Mar 2026 14:46:37 +0100
Message-ID: <20260323134535.303122802@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3641043ca8cc5..70783671a2b01 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -22,6 +22,7 @@
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -1156,6 +1157,10 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
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



