Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C532E06E4;
	Tue, 25 Aug 2026 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665222; cv=none; b=J/1xKkc2HmSRGS5PG/Wwz1twMcWvxYj8PxvUKB6cysx5hMZyMX+F9an3rff1rBb+ddU5OawPj3eU9g59WAAfKanxWFWnMtUMPqdE9FuunmtXc6vQErzmP/GYV8fF4IGH0vZuDUr44nv7+5/1KKKKQTZXWfhaF1KNW+ayKR7tqQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665222; c=relaxed/simple;
	bh=U6l2y6U2lgk+0AcMYj9Jlg8B8e+1g2Jt75UFQKJ1pi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO+PMIioT7z4yp2m8hfa0ServtV/qJXExiu/InqGoV10IGRH9NvIsmnhIs4woUNrqaKqF7FUPp1l2J3cwswuqtaqbhYS/m0Kd3o4SjTLNNJPZC7Sn4D8ULUlisa6SjcHf7KEiXpABRcpg18Bjs11H/hmM5DFCO2ofSsKD2KIFCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+drlF+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+drlF+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52CF1F000E9;
	Tue, 25 Aug 2026 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665221;
	bh=HlsY9b19teMH9d7hlr0nQYJQjzEZbQ7I19Druc3uKoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+drlF+wkBi8QiXIOVmYieQH3/0FJvlHc8RxvIcLLdh7kRstxtW6Ga44V+hKOVWZg
	 ehVChsge+lKFTP3l7l+by4aLgeSiYXDK+BAv/rqSB+6jrW1/H94qKo+ZgPNPUwfmKF
	 1XZ0S4/MZRTyzul27wO122kHAPpbeyoWmVi92Ro4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 48/94] ipv6: fix use-after-free in ip6_finish_output2()
Date: Tue, 25 Aug 2026 15:25:44 +0200
Message-ID: <20260825132543.788200540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

From: Luxiao Xu <rakukuip@gmail.com>

commit d0d48d999b0eee6bb176ef4e39d9be868fa80f7e upstream.

ip6_finish_output2() caches a pointer to the IPv6 destination
address (daddr) before invoking lwtunnel_xmit().  The LWT-BPF
transmit path or other encapsulation operations within
lwtunnel_xmit() can reallocate the skb head, freeing the memory
that daddr points to.  When lwtunnel_xmit() returns
LWTUNNEL_XMIT_CONTINUE, the function continues to use the stale
daddr pointer to compute the nexthop and to look up or create the
neighbour entry.  This results in a use-after-free read, which can
leak sensitive kernel data, pollute the neighbour table with
arbitrary values, misdirect traffic, or crash the system.

Fix this by re-fetching the IPv6 header and the destination
address pointer after lwtunnel_xmit() returns
LWTUNNEL_XMIT_CONTINUE, ensuring that the subsequent nexthop
computation and neighbour lookup operate on valid memory.

Fixes: e415ed3a4b8b ("ipv6: use skb_expand_head in ip6_finish_output2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/4aa3f53bc44e79572c6dd2340ec7b68ef1a3d87d.1786516730.git.rakukuip@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -116,6 +116,8 @@ static int ip6_finish_output2(struct net
 
 		if (res != LWTUNNEL_XMIT_CONTINUE)
 			return res;
+		hdr = ipv6_hdr(skb);
+		daddr = &hdr->daddr;
 	}
 
 	IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);


