Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4864B1C5D77;
	Wed,  4 Feb 2026 14:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216426; cv=none; b=eVxb92niJqtYb0JjAlm5z4l13Om9erUaQc0IxyDpM7puLxmN2BWd/7in+s7qbulEflhO7JLMxK33FCgH5TLPBvRc4nm+c8JFeQT3eG7PGz4zF3L2TPMTkSbqCFjHI25YX7kad4qsmzIbuLXDUy4sNGTM5Xws8MFJugFNDr66+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216426; c=relaxed/simple;
	bh=ni/SfLwZzRT3JyxR/PDtokuTYqdHOud8lmpHRkaxf5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIxS1QvBGDs/EsOxZRFTokbeQLxPnhdiljITwFMcV4ptJ5+nQVB2/g2Eshl//JNwUg++9Qd9N5x2CZ9+AFTerAR7cHYCKaktUk+WoB6vVJO18aYTZsLotP7e3cReOeWeajpYAsU2sEKyLurA3QgSSCCiCNp11rBHPbL6i//Pj4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksdzuXKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksdzuXKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F10C4CEF7;
	Wed,  4 Feb 2026 14:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216426;
	bh=ni/SfLwZzRT3JyxR/PDtokuTYqdHOud8lmpHRkaxf5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksdzuXKfb67YQEDgTK0kJrvCSzU15kQ1xfBmqVJPun5drbH7Xlps8fMqmbwJJ2TQc
	 Lj5egOc9MH72ZX+murDaKhp2nhp/EuscYnQYhfrDERBf0iB7WPQiOX81aoBDRVT38j
	 UOWoj2s38J+PldkW8cDP96fFhBPRz+hXvu06rme0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c46409299c70a221415e@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Matteo Croce <mcroce@redhat.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 084/161] bonding: provide a net pointer to __skb_flow_dissect()
Date: Wed,  4 Feb 2026 15:39:07 +0100
Message-ID: <20260204143854.770035249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 5f9b329096596b7e53e07d041d7fca4cbe1be752 upstream.

After 3cbf4ffba5ee ("net: plumb network namespace into __skb_flow_dissect")
we have to provide a net pointer to __skb_flow_dissect(),
either via skb->dev, skb->sk, or a user provided pointer.

In the following case, syzbot was able to cook a bare skb.

WARNING: net/core/flow_dissector.c:1131 at __skb_flow_dissect+0xb57/0x68b0 net/core/flow_dissector.c:1131, CPU#1: syz.2.1418/11053
Call Trace:
 <TASK>
  bond_flow_dissect drivers/net/bonding/bond_main.c:4093 [inline]
  __bond_xmit_hash+0x2d7/0xba0 drivers/net/bonding/bond_main.c:4157
  bond_xmit_hash_xdp drivers/net/bonding/bond_main.c:4208 [inline]
  bond_xdp_xmit_3ad_xor_slave_get drivers/net/bonding/bond_main.c:5139 [inline]
  bond_xdp_get_xmit_slave+0x1fd/0x710 drivers/net/bonding/bond_main.c:5515
  xdp_master_redirect+0x13f/0x2c0 net/core/filter.c:4388
  bpf_prog_run_xdp include/net/xdp.h:700 [inline]
  bpf_test_run+0x6b2/0x7d0 net/bpf/test_run.c:421
  bpf_prog_test_run_xdp+0x795/0x10e0 net/bpf/test_run.c:1390
  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4703
  __sys_bpf+0x562/0x860 kernel/bpf/syscall.c:6182
  __do_sys_bpf kernel/bpf/syscall.c:6274 [inline]
  __se_sys_bpf kernel/bpf/syscall.c:6272 [inline]
  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6272
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94

Fixes: 58deb77cc52d ("bonding: balance ICMP echoes in layer3+4 mode")
Reported-by: syzbot+c46409299c70a221415e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/696faa23.050a0220.4cb9c.001f.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Matteo Croce <mcroce@redhat.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260120161744.1893263-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3642,8 +3642,9 @@ static bool bond_flow_dissect(struct bon
 
 	if (bond->params.xmit_policy > BOND_XMIT_POLICY_LAYER23) {
 		memset(fk, 0, sizeof(*fk));
-		return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
-					  fk, NULL, 0, 0, 0, 0);
+		return __skb_flow_dissect(dev_net(bond->dev), skb,
+					  &flow_keys_bonding, fk, NULL, 0, 0,
+					  0, 0);
 	}
 
 	fk->ports.ports = 0;


