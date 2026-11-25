Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621108;
	b=dEmc6wrqeniakTJRj1OTX9OWoJUbGyZnZQeJ/o5IWJ+cBR5pXI0EWJpKwseTpXVzG/aZ
	 EBsI54ESKfrNH7L/AsOu/J2odlaiM59znHnYrALNFsmpStGYTR8fpU/RnCkRcV6D50VV9
	 fNKjHskImKFwS091Dq9w+X4wzLlvNzOk/+npSr1EymNtzBCaqxkiKztBN3x/sHVGdRzvK
	 jx8B7DXjdd5m9QngBBZl/UbWXLPK1sD16vt7Rj6cpvD/Pqc7ZIgOCxoiGMU5QXikpvbZX
	 bn5AWJ2DxcTMm6Zdn09WEJqrcvk1aqPbo0XCZdSobxAtnsZ1ZB29UO5vk00KFDDB7Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3/A5n+MhdYu6P1s77WPghPLZbgA9CU0LtvAgLR9lzOM=;
	b=vz+PCGiDL8HesBgbATzNwa/W2O/70NTngqhnhlGkV3SSegexTOwJIAHGpRU56kUKWcq1
	 FLWHsbouaQPDOFwqtGnMWuV7p2oXY8WB5S4irIMC7rdt61Y+f93BcYt8cR4fkP+NMJsb7
	 c3zHo/beKOKQ43Spl7o7KJsBNiDTQl9OVgaz2vax97EGA2MAkNxN9JxvqQbKGOoMZYy+p
	 i2aEaknzU9Nt8RrR3Bk0jUkmird9T6M0gFnKtG2qG6GJO9Vxp2kHxPT2Sh9MkzUD1iE42
	 BeS+fTBAN8D2/SjJw8+AGot4ufVKVU+nLXwMGk6adg12U6MoENMPudX5dF92f64Y7Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnu8qEMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7914B606A331;
	Wed, 25 Nov 2026 15:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnu8qEMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C865A1F000D3;
	Wed, 25 Nov 2026 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621108;
	bh=3/A5n+MhdYu6P1s77WPghPLZbgA9CU0LtvAgLR9lzOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnu8qEMMrn23che8yAXpXbMYfCCK1coW99zeaguISrP5OEEp3UFA3W60BVoq07uwz
	 D6/QkWpuzmtHXBzdgdMUMgWuGig/lALoNTmtKe50qgbOUhWJoHB2XzFOmDl82kJLiC
	 CyzpQ1XaN+86f6VqFeOLxYYQnCrUnhlCujq+5a7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/990] bpf: Require BPF_LWT_REROUTE when an lwt_in prog changes the protocol
Date: Wed, 25 Nov 2026 15:24:52 +0100
Message-ID: <20261125143825.017492071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index f215978d10a3b..982599bb41c97 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -161,6 +161,16 @@ static int bpf_input(struct sk_buff *skb)
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



