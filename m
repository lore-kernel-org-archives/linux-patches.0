Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041952;
	b=gtSVimCIuJtvFkqC9AHfvUccBaP7fruz+M35CdKafGpwrLApZupqUpyow4uMUcQtA2aH
	 k56UoWhUIgLHMamYjl7Iagvgsmi4a3KvpnYXXyJkh1O+66VEyehU2v48yDixuDLbbROTX
	 dr2BxdlmdaxkiWxnLoZoBTPT7kk3i5Gsv4B8s9AjPEW3BIEaDbVEBxQ7xkkAExCmrdndP
	 4lrcyNm3jMyTE33JNguDgobeDgiEgtGexpnmPXmOrijwxSPxHgM4b/e3Fnk9JQ5Pt5Pmu
	 ukQM8PeES5iLBAXzTxWIzYaWihR/vBUlsPZCnHjpGcMLq1F2aiMct4FB8JoY+9YPJ0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cnbaijyr55isr4uLzTx9ceq+t/P+rf9Vo+YYni0Xa5I=;
	b=lLD/h8NzXTuHpSqHQNSeT79lfoQhrD8DXel9snS0bGIh3Whl2MpY7lBk0KL38SPda70k
	 62Sh/kGtSO5RgmlZplpgKAl0Bs0HNbk0HX218pkiARSvJaelfn4oSsApdTi0z06EtNHVl
	 Sz/q/9mG+vnTxlj2kLJxI9UhwVwlrJfWa4xR52/6aPNhuBF8UVIV1JRUkiOvTPJEFcS1S
	 z5Y/Qmx5nv5XzkcOFb5B5Lqb4bdHVSrs0guZRpm6PI9SZBs9QHT8QVOrMNW/Fw+X9YFBe
	 mGkC6qKCJe4pe7GFYPxdjLBUppqRJK6OwJRUjWwzkMiLwLqyM3nAHp9J4Nm5g4nyjVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CaC4vl8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94953606A320;
	Wed, 18 Nov 2026 22:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CaC4vl8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96211F000C5;
	Wed, 18 Nov 2026 22:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041952;
	bh=cnbaijyr55isr4uLzTx9ceq+t/P+rf9Vo+YYni0Xa5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CaC4vl8FizRae9CyGQe2vfeifiyxt+3xYRYznWVMsTsgkJzi2FBUjebrILMqffjDs
	 VsWPahwWajbZWMLnMuy6n/LB4xnQ0XKkRDrqzhGX+WZFElspc4HA2+ukio3xC1dXv+
	 mNFbzXL+9Rk202S/8v64R2pG2f3+FKwwADyEldGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2998/3318] bpf: Validate the SRH which End.DT6 uncovers in End.BPF
Date: Wed, 18 Nov 2026 16:00:20 +0100
Message-ID: <20261118150450.202082725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e8b084646b946cc6f7976365588035947a296184 ]

input_action_end_bpf() validates the SRH of a packet and pulls it into the
head before the program runs. If the program decapsulates the packet with
bpf_lwt_seg6_action(SEG6_LOCAL_ACTION_END_DT6), bpf_update_srh_state()
looks for a routing header in the inner packet and takes it for the new
SRH as it is.

Nobody has looked at that header, and whoever has sent the packet has
written it. ipv6_find_hdr() finds it in a fragment of the skb as well, but
hdrlen is then read at that offset from skb->data, past the end of the
head. The header need not be an SRH, and its hdrlen need not fit into the
packet, but it is marked as valid, and bpf_lwt_seg6_adjust_srh() and
bpf_lwt_seg6_store_bytes() check their offsets against it.

A program which then adds a TLV at the end of the SRH, where hdrlen has it,
makes bpf_lwt_seg6_adjust_srh() move and write memory behind the head of
the skb, as far as the sender likes within the 2 KB that hdrlen can say:

  BUG: KASAN: slab-out-of-bounds in bpf_skb_net_hdr_push+0x185/0x240
  Read of size 2088 at addr ffff888107d6f09e by task srh/102
  BUG: KASAN: slab-out-of-bounds in bpf_skb_net_hdr_push+0x1b5/0x240
  Write of size 8 at addr ffff888107d6f8be by task srh/102

Use seg6_get_srh(), which pulls and validates the header. Without a valid
SRH the state says that there is none, and the packet goes its way as
before. The pull can move the head, so compute the data pointers behind
it.

Fixes: 486cdf21583e ("bpf: add End.DT6 action to bpf_lwt_seg6_action helper")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-12-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ac1d7a8a29760..432856e47f61c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6583,15 +6583,15 @@ static void bpf_update_srh_state(struct sk_buff *skb)
 {
 	struct seg6_bpf_srh_state *srh_state =
 		this_cpu_ptr(&seg6_bpf_srh_states);
-	int srhoff = 0;
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0) {
-		srh_state->srh = NULL;
-	} else {
-		srh_state->srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
+	/* Behind a decapsulation this is a header that nobody has looked at */
+	srh_state->srh = seg6_get_srh(skb, 0);
+	if (srh_state->srh) {
 		srh_state->hdrlen = srh_state->srh->hdrlen << 3;
 		srh_state->valid = true;
 	}
+	/* it may have been pulled into the head */
+	bpf_compute_data_pointers(skb);
 }
 
 BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
-- 
2.53.0



