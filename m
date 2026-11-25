Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624179;
	b=MgO8g9KFyg7R2AFgKs984DYE9P98YbHTJ0aeXInQujAPfMRKXOfUIngIRvuH41zlwrlx
	 qkKSsIe1hFa4Mpb0onTsYsimO5ayaVhpJ4wtTGC85SO7ISdmJmsscJYQCcNCpTZOLUL1n
	 uJp5sRLLhRo0L3UP8KGRzkh+L/Qqo/d5/Y4JmjX4LzQ9g2PagWsLZVAyWF/lR0o7tEzRZ
	 85IuVn+/5clWPgyx5P15qZeFDC3nvOV0ecmfAXThlxuNHDvh9JW4kfblO82sz+m2mHt4/
	 /HX/UiH+iQdGdPB9NJRPnyl+2XnmSPnk5Gr/CQWW1cmI/fGZRP7x1pmOWPbcfiTsDWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J08mpqEiymjuaCJNMLLAdaSHQ+ETP6LLJN4dVcoFaBA=;
	b=0JeUcj7MlTr74g0ZqiTQ3Phs9ACC7FX7FhmpVdfDh4CMuHBrCt9I+pRSthU4+i6D2szH
	 pRKlRggquNrSL1DTFlKTvOrfOZIThlxq9d8mAcyuw7n04W7yqfaSBZwThyQfg0MCWaC0J
	 fjrXDo5qRCqP1TfS8AIceCUSekizBmTBApE+sKM01Rznx4Fu2XsoVdgM/HPr4I9Fz+m47
	 3/3aALD4wO1//gdPTYEhheHwQcHXEbkCuDaHs8wnuijBL9J5EDtVsEXFeW6wVYW+U+VJb
	 EXlJ4TYCspc3WZ27Glm6O+Q3hHLjVy/jbiit+IX/FTprJXw5eD6e4BayhFkpFWcZjLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bf0cxG6r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D89606A332;
	Wed, 25 Nov 2026 16:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bf0cxG6r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA861F000D2;
	Wed, 25 Nov 2026 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624178;
	bh=J08mpqEiymjuaCJNMLLAdaSHQ+ETP6LLJN4dVcoFaBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bf0cxG6rymoAyJogmL2sP+l9t6YvJQSCPm4cA1Gz7SN8TW961/Np1SYN48zE5QuXs
	 4VsRIenQWiTCudQ/SN+JbXGiCGrv5/Ym5P7aD4oYBKaH3LJviQ+HBruk0+1NmioWHI
	 7ObGDRnAr0j6fStQXXkbg1xac6ATfzVkNo7fZW+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/816] bpf: Require BPF_LWT_REROUTE when an lwt_in prog changes the protocol
Date: Wed, 25 Nov 2026 15:27:37 +0100
Message-ID: <20261125143851.736677197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit d9618a6196953718f7470de5d2e84121bed063f7 ]

When an lwt_in prog returns BPF_OK, bpf_input() calls orig_input(), the
input handler of the route. This handler is for one IP version and needs a
dst of the same family. But BPF_LWT_ENCAP_IP lets the prog push a header of
the other IP version and thus change skb->protocol. Then the handler reads
and changes a header of the other IP version. The push of an SRH also
replaces the dst, because seg6_lookup_nexthop() puts an rt6_info into the
skb. Then ip_forward() uses the rt6_info as a struct rtable.

Drop the skb with -EINVAL when skb->protocol changes, as bpf_xmit() does.
Drop it also when the family of the dst changes, because skb->protocol does
not always show this change. Today no such skb leaves as the prog made it.
A prog works as before if it returns BPF_LWT_REROUTE, or if it pushes an
SRH on an IPv6 route.

The commit in the first Fixes tag lets a prog change skb->protocol. The
commit in the second tag adds the check to bpf_xmit() only.

Fixes: 52f278774e79 ("bpf: implement BPF_LWT_ENCAP_IP mode in bpf_lwt_push_encap")
Fixes: 3bd0b15281af ("bpf: add handling of BPF_LWT_REROUTE to lwt_bpf.c")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-24-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 7b669f206abd7..331d4fd271960 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -159,6 +159,16 @@ static int bpf_input(struct sk_buff *skb)
 			bpf_lwt_reset_cb(skb, proto);
 		if (ret == BPF_LWT_REROUTE)
 			return bpf_lwt_input_reroute(skb);
+		/*
+		 * orig_input() is for the old protocol only, see bpf_xmit().
+		 * It also needs a dst of the old family. BPF_LWT_ENCAP_SEG6
+		 * puts an IPv6 dst into the skb.
+		 */
+		if (skb->protocol != proto ||
+		    skb_dst(skb)->ops->family != dst->ops->family) {
+			kfree_skb(skb);
+			return -EINVAL;
+		}
 	}
 
 	if (unlikely(!dst->lwtstate->orig_input)) {
-- 
2.53.0



