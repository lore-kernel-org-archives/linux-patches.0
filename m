Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC272F90E0;
	Sat, 30 May 2026 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164741; cv=none; b=IGOV1iy8UrTok5UDMe1Ls+aiBzSwt7598EXC27jmgCq1iRpk+jor/BQKqXS0IvPmW9TrS8wnq51mzI/uLL0yEPcZt51aSOG8H5oeSmmbpU7O4A2Kc6cXF95x4SLeVCT/95JxAOcJBeL1xmLtwN668PLnEJvqb+uxGjooJ+jAEFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164741; c=relaxed/simple;
	bh=bFffE3jR/fhrEAxWvC9W5XpHbJZgJEL4MiTFtaWkHcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJ9VOJ+nOtj/9nPKls6pO/dZRUcQLFhij0DQBzId4cBhe0Jpv4Y7XxzMf9iw6X40d+7lje1xmN49z0B3HV/o+GuXfsHrOVmZ1+6eMweAkJZm10uVffGn03aLCbYFmS3zxivZOsF68qL5uLnEUkkXXY8XjrU6I+wBWPkv6JWq4H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfyoEDXm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfyoEDXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE351F00893;
	Sat, 30 May 2026 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164740;
	bh=tlgHIkv4iKitxeLyLdqfkB0btVvi/GtWZ2ot0DKHG+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfyoEDXmPXG5Bk/T41NMpYY2MHZ4XXb6YTEgmmDnvQLmhcUcxQrWRxbzP99HCIABz
	 +3RlAz3YFW4MvM52681fusjHVwOXTbUEre9c7HYn+pIVQj47JlRrzefhUTWzXqOKbU
	 J76aRxDuxcQhFt7u++DA3heQkAO85mNe3mPh5HJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingqing Yang <qingqing.yang@broadcom.com>,
	Boris Sukholitko <boris.sukholitko@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 645/776] flow_dissector: Do not count vlan tags inside tunnel payload
Date: Sat, 30 May 2026 18:05:59 +0200
Message-ID: <20260530160256.607318041@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Qingqing Yang <qingqing.yang@broadcom.com>

[ Upstream commit 9f87eb4246994e32a4e4ea88476b20ab3b412840 ]

We've met the problem that when there is a vlan tag inside
GRE encapsulation, the match of num_of_vlans fails.
It is caused by the vlan tag inside GRE payload has been
counted into num_of_vlans, which is not expected.

One example packet is like this:
Ethernet II, Src: Broadcom_68:56:07 (00:10:18:68:56:07)
                   Dst: Broadcom_68:56:08 (00:10:18:68:56:08)
802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 100
Internet Protocol Version 4, Src: 192.168.1.4, Dst: 192.168.1.200
Generic Routing Encapsulation (Transparent Ethernet bridging)
Ethernet II, Src: Broadcom_68:58:07 (00:10:18:68:58:07)
                   Dst: Broadcom_68:58:08 (00:10:18:68:58:08)
802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 200
...
It should match the (num_of_vlans 1) rule, but it matches
the (num_of_vlans 2) rule.

The vlan tags inside the GRE or other tunnel encapsulated payload
should not be taken into num_of_vlans.
The fix is to stop counting the vlan number when the encapsulation
bit is set.

Fixes: 34951fcf26c5 ("flow_dissector: Add number of vlan tags dissector")
Signed-off-by: Qingqing Yang <qingqing.yang@broadcom.com>
Reviewed-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
Link: https://lore.kernel.org/r/20220919074808.136640-1-qingqing.yang@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 7ab80767d94c3..db5677fbf81d3 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1180,8 +1180,8 @@ bool __skb_flow_dissect(const struct net *net,
 			nhoff += sizeof(*vlan);
 		}
 
-		if (dissector_uses_key(flow_dissector,
-				       FLOW_DISSECTOR_KEY_NUM_OF_VLANS)) {
+		if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_NUM_OF_VLANS) &&
+		    !(key_control->flags & FLOW_DIS_ENCAPSULATION)) {
 			struct flow_dissector_key_num_of_vlans *key_nvs;
 
 			key_nvs = skb_flow_dissector_target(flow_dissector,
-- 
2.53.0



