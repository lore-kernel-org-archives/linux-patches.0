Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D471F396B75;
	Thu, 15 Jan 2026 16:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496287; cv=none; b=rEhoZtPpwcgz2t6Oo/FxuBKFz3cojF3kEcVj1CmXkfrXL3/v4FAFBjBqswo9L1ZOamkFAvyCpYHja1whOyeR1JFp5YA1CxKvb+t0moIY/61mR59c1Khb7xavpl8euHYb2MxmTLKuEXa390LpvElILyCkLnJtAt52G82nSCNleMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496287; c=relaxed/simple;
	bh=W+RgqqdLMz2YRDHkv1rX8gQV/hGRIUrW/68PnYJdm60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUWo0bAWIAVEeG09vkpDOe50q1bCXWDCIE9qvoF2upOsNTTNizU+vNv963QCZceAlD5buP5Au1jm84/c8aDwaMvxLoBS3GBA5Msv28zI6pGIMX/hapEvr4ZTlOvsETrT6FBTxT1Dnn/ZvJFetVsUpKaQ+JD7qHSRLLhoW7l+y1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljd2dW61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljd2dW61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8B4C116D0;
	Thu, 15 Jan 2026 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496287;
	bh=W+RgqqdLMz2YRDHkv1rX8gQV/hGRIUrW/68PnYJdm60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljd2dW61JPOcP77RNU3LafkBHjoLEqwVv3ytROB3Hik30gMR9+huRos4HZvWISKrl
	 fDSdKzAYSziW5x6lfs7uIOgelVrxQIjQJ9JyEz4fzX4SISGu+tmhzsgYrKVRFbkcVa
	 VIGTWnuHdl52zYne64J3wQu25mlAyPzzkLjCXAGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4393c47753b7808dac7d@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/181] inet: frags: drop fraglist conntrack references
Date: Thu, 15 Jan 2026 17:47:27 +0100
Message-ID: <20260115164206.288529175@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2ef02ac38d3c17f34a00c4b267d961a8d4b45d1a ]

Jakub added a warning in nf_conntrack_cleanup_net_list() to make debugging
leaked skbs/conntrack references more obvious.

syzbot reports this as triggering, and I can also reproduce this via
ip_defrag.sh selftest:

 conntrack cleanup blocked for 60s
 WARNING: net/netfilter/nf_conntrack_core.c:2512
 [..]

conntrack clenups gets stuck because there are skbs with still hold nf_conn
references via their frag_list.

   net.core.skb_defer_max=0 makes the hang disappear.

Eric Dumazet points out that skb_release_head_state() doesn't follow the
fraglist.

ip_defrag.sh can only reproduce this problem since
commit 6471658dc66c ("udp: use skb_attempt_defer_free()"), but AFAICS this
problem could happen with TCP as well if pmtu discovery is off.

The relevant problem path for udp is:
1. netns emits fragmented packets
2. nf_defrag_v6_hook reassembles them (in output hook)
3. reassembled skb is tracked (skb owns nf_conn reference)
4. ip6_output refragments
5. refragmented packets also own nf_conn reference (ip6_fragment
   calls ip6_copy_metadata())
6. on input path, nf_defrag_v6_hook skips defragmentation: the
   fragments already have skb->nf_conn attached
7. skbs are reassembled via ipv6_frag_rcv()
8. skb_consume_udp -> skb_attempt_defer_free() -> skb ends up
   in pcpu freelist, but still has nf_conn reference.

Possible solutions:
 1 let defrag engine drop nf_conn entry, OR
 2 export kick_defer_list_purge() and call it from the conntrack
   netns exit callback, OR
 3 add skb_has_frag_list() check to skb_attempt_defer_free()

2 & 3 also solve ip_defrag.sh hang but share same drawback:

Such reassembled skbs, queued to socket, can prevent conntrack module
removal until userspace has consumed the packet. While both tcp and udp
stack do call nf_reset_ct() before placing skb on socket queue, that
function doesn't iterate frag_list skbs.

Therefore drop nf_conn entries when they are placed in defrag queue.
Keep the nf_conn entry of the first (offset 0) skb so that reassembled
skb retains nf_conn entry for sake of TX path.

Note that fixes tag is incorrect; it points to the commit introducing the
'ip_defrag.sh reproducible problem': no need to backport this patch to
every stable kernel.

Reported-by: syzbot+4393c47753b7808dac7d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/693b0fa7.050a0220.4004e.040d.GAE@google.com/
Fixes: 6471658dc66c ("udp: use skb_attempt_defer_free()")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260102140030.32367-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_fragment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 001ee5c4d962e..4e6d7467ed444 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -488,6 +488,8 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 	}
 
 	FRAG_CB(skb)->ip_defrag_offset = offset;
+	if (offset)
+		nf_reset_ct(skb);
 
 	return IPFRAG_OK;
 }
-- 
2.51.0



