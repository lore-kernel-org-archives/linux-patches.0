Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617911;
	b=4GvYk0jf7299k2VO4CqP/elphMMt5c21e3Font76AOMd+1Jw6rOhWRhoqz8KXTWmJERc
	 EdaGTuGCmC9FgZxm/8JesSM20710fHAlrtPzB4mbFd8vaqrA+z4m2ZAnDRqvKcgS2WM2g
	 i0DQ20jIk2fzM2nt0OriC3l3/0qCjY0281waYdXETa3iTiAPwDnqWX/SQeRiv1kpGgNEc
	 2RxNtIRHqSZS1MbnqhiSymIUIHCaUY9NXdgFAa61dJduN0VCLspThk3TYUXR6jzLPByKM
	 rfNTs7aExRuums/8JK9lsPaD5LKOYEd0M5iEiBi+59Huce4dCUeIad8iuMoj+tMjA7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K3CvrJKy8KLvjPDkyBiKbbD6+VJFT/q6zGAc7kUgFGM=;
	b=qrY2/8/t4xPaIIE8LGIh1t4r5tl7AyF6G0Ouaqb+OF6w9M7Jtwdpia1LMEVbctb2LNBR
	 dTomyxzuKNsjHQsgybWkCcjai9NttZovpOCFbDXP5Vebf4Aoq1aR/Ih/emy2ACwf2UNbl
	 S5p/THwVkMdeS0AibJdaWLZRnfI91theDIOELuKSk73sOIgzrn2+Eoh14+8cOfqmg0OMm
	 7zVIohR8qtZ1Iwk5PG3KgxW++BzLiuuZQW7Djd16f56cyosbXbPwYR5mftvCrr7KoubY8
	 4kxWnC27Y9YwMEyKuzjRiJ7AQCMNDl9I6KY5lbkpHVCiVfbIF11Df8TDH3Q2+HQZ+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flSmJU2P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0952606A327;
	Wed, 25 Nov 2026 14:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flSmJU2P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031FC1F000C6;
	Wed, 25 Nov 2026 14:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617911;
	bh=K3CvrJKy8KLvjPDkyBiKbbD6+VJFT/q6zGAc7kUgFGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flSmJU2PsmpGcd6TE9P0/Z+eCnvLdmBiXAx0jx4Nw+iICdzaGewOiVYaNiXIomVEM
	 ZCVNw4CoiFdKEGak4MxOpwx1gRBl0DUbyLF1LOditVckQEzmAKlSw0tMsbjb8Lvwct
	 A/a7k1kGQ8SSMilRvDkar9CjhwLaVHZlDeZme6qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0112/1005] bpf: Dont leave a stale MAC header in bpf_lwt_push_ip_encap()
Date: Wed, 25 Nov 2026 15:24:10 +0100
Message-ID: <20261125143824.367940370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 701ffd202b9e32942c8cfc065c9fe76ceaccc302 ]

With BPF_LWT_ENCAP_IP, bpf_lwt_push_encap() pushes a new IP header. The new
header overwrites the MAC header of a received skb. But skb->mac_header
continues to point to the same bytes. Code that reads the MAC header after
the push, for example netfilter, gets bytes of the new header.

  before the push                        | MAC header  | old IP | payload
                                         ^ mac_header  ^ network_header
  today                            | new header        | old IP | payload
                    network_header ^     ^ mac_header
  this patch, lwt_in | MAC header  | new header        | old IP | payload
                     ^ mac_header  ^ network_header
  this patch, lwt_xmit             | new header        | old IP | payload
                    network_header ^     mac_header is not set

For lwt_in, move the MAC header in front of the new header before the
memcpy(), as __seg6_do_srh_encap() does. skb_cow_head() already reserves
len + skb->mac_len bytes.

For lwt_xmit, the output path makes a new MAC header. Thus mark
skb->mac_header as not set. This is the state of a locally generated skb.

Fixes: 52f278774e79 ("bpf: implement BPF_LWT_ENCAP_IP mode in bpf_lwt_push_encap")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-22-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index da49364ec63de..b9270a08cc6d1 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -649,6 +649,14 @@ int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
 	if (ingress)
 		skb_postpush_rcsum(skb, iph, len);
 	skb_reset_network_header(skb);
+	/*
+	 * The new header goes over the MAC header. On ingress move it first.
+	 * On egress the packet gets a new one, so forget the old one.
+	 */
+	if (ingress)
+		skb_mac_header_rebuild(skb);
+	else
+		skb_unset_mac_header(skb);
 	if (is_udp_tunnel) {
 		size_t iph_sz = ipv4 ? iph->ihl * 4 : sizeof(struct ipv6hdr);
 
-- 
2.53.0



