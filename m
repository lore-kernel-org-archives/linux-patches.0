Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5237A3FF8BA;
	Tue, 25 Aug 2026 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664779; cv=none; b=SKt2Ll5+t49JbQUqSSP02TWTiF/pxy8RKPxNiQovgqWg40G7y9iOpC7VCc50BubUQR/ho4rdtHoBeK7q7oL9eXosRdPY0x9ZeFMxH1aql9dNg8+5XDiMlBjAa/eCWNq88ldICp/ySZMblroNsZ3s4R3aewZK6GED394gm50fXp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664779; c=relaxed/simple;
	bh=Jl4CFFz4OyrtVA9bgkyG9ptFf/yXpL6f5RJWvrNl5Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBX3GUg6ZmNuFHCb/GT4151xJw/PoCBi0RapW56e8mZsR6xBKfmgQh7NhMMq7LJ4X691Xlk44ITyiSQ1z4Jgk5mpg6wip4cwsfR2YTY19bbqParTr7Hd3skv2J5DcEFthH5w4t1K0ET1mwoFPcvMarl6yavNaaiyt59W+tIzXBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPnyauLE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPnyauLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8D51F000E9;
	Tue, 25 Aug 2026 13:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664778;
	bh=NAi4IIgjZwKcRGvUw7R0oImEx3/qmlj3+mFdnoF1qB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPnyauLE1R8Oxwy5147pwWnoBpLtx+5tq1nOYceca+JaygUfPMazQWVnDZe8ogFvk
	 ZTvA0wSV8sxE4rWb3320hzK4UYWNxW59W3bEDjJxj+aNffI3L1F1qiGi7AwdHCSjO8
	 H9T6yhAxlHvOLwSbygJ5DClCQ8VjAQqyl+UpgapE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yong Wang <edragain@163.com>,
	Ren Wei <weir@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 46/82] ipv4: reject undersized MTUs in ip_do_fragment()
Date: Tue, 25 Aug 2026 15:25:33 +0200
Message-ID: <20260825132543.317063185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Wang <edragain@163.com>

commit c0726f0caf8c6b3208552949e17d23634a2f3129 upstream.

ip_do_fragment() subtracts the IPv4 header length from the effective
MTU and passes the resulting payload MTU to ip_frag_next().

If the effective MTU is smaller than hlen + 8, ip_frag_next() rounds
the fragment payload length down to zero. The fragmentation state then
never makes forward progress: state->left, state->ptr and state->offset
stay unchanged while ip_do_fragment() keeps allocating and transmitting
header-only fragments until the softlockup detector fires.

This is reproducible with a route installed using "mtu lock 20", but it
is also reproducible without route MTU lock, for example by forwarding a
packet to a device whose MTU is 20.

Fix it in ip_do_fragment() by rejecting mtu < hlen + 8 with -EMSGSIZE,
matching the existing IPv6 fragmentation check.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Yong Wang <edragain@163.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/8809ef6314b98913681b0b370a05a85c2b6cd579.1786599079.git.edragain@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -790,6 +790,10 @@ int ip_do_fragment(struct net *net, stru
 	 */
 
 	hlen = iph->ihl * 4;
+	if (mtu < hlen + 8) {
+		err = -EMSGSIZE;
+		goto fail;
+	}
 	mtu = mtu - hlen;	/* Size of data space */
 	IPCB(skb)->flags |= IPSKB_FRAG_COMPLETE;
 	ll_rs = LL_RESERVED_SPACE(rt->dst.dev);


