Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056531;
	b=Wz6suBrMsJq2ROqKh8BXkS5IoNpdsTCemnddKMmHvC2i1BaJQoR2pmHKGJQHf2jTBhyu
	 NOgrhJ8U7Z1+YrXxvSH2oCWQxpzbynRPXjyz/ZR3ke/SS8D0lY3UDuPwki7bDhN4PwZ5n
	 WLrHoIa/0eHsGQntdz5+jZ3P9QzJn+x7Juefzcrqm6lDwLLwReSlgbn1um4WNu5eWH/J4
	 KjAHDjwrwfgCV+3fCZaf3aUVAmVUcZhMj6zdbVKLrAjYuCU1oks8/22+k+Q6h94XCVsBZ
	 KJcBoDYZ3p80WJBs3oNTaMW4pW5j8FKikQvrrrJsaXaHmBbcH56NMpFm/xOfXXSmMxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3tCV1iMeePzxQfr+V/9UpOIs8gv89deAtrFIoP2qvOQ=;
	b=fe0+AnnMoUuzTvv+XDAydGyN6VoHPI0pIeiGpMXMz37FP2ffpmnf6KSoIH5evpDCBkRc
	 /oPUo+buIxiH44KK5nszOtnTHK7G7eUq12k83xsjWSr0S7LdcbxONnHjBYhc6q7R20VlE
	 qId1zNw9GYBGFNdXESm9KZbmSvIJaktHRoj5XbqUb7pUvG4hCNu9zzf4fCSEJdI2+40R4
	 WIbNHo8fbe9Jw/RhBvDrmX823ZS36u9xDyO02hM6NTNucboFHTSjZwEr6w/4D9zgxYePe
	 K6EhEHExn0W7YZjC/vyXcxKSPxlepCs9OoYZP0SqIEzuQn3QyLqgIL/bjx5ez6j0yRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmArQ5fT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAE2606A32C;
	Thu, 19 Nov 2026 02:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmArQ5fT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56721F000C4;
	Thu, 19 Nov 2026 02:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056531;
	bh=3tCV1iMeePzxQfr+V/9UpOIs8gv89deAtrFIoP2qvOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmArQ5fTx7HnB3qmIWmzFPaK4Ksv5KkejBLwQbjKvFgDYtmm0zG5MolYtouh/XkBR
	 9ok6ZAlPreP1oxpa+3yyZpME8t/5HLOPl2Fiyr2ZldxHaTKM3gjMJs8jsZ6ZpAad+J
	 Lraeq2hFamBApkVT1h2q+1iCO62oGqu5LpSIHguU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2020/2214] bpf: Validate the SRH which End.DT6 uncovers in End.BPF
Date: Wed, 18 Nov 2026 16:01:36 +0100
Message-ID: <20261118150131.548197908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index af963bbb5885d..cb87f1eb5ab0f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6212,15 +6212,15 @@ static void bpf_update_srh_state(struct sk_buff *skb)
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



