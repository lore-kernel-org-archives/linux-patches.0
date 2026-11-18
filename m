Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050105;
	b=Sjv17sBCA7aEe+93Rz68ntc4v3GmHTekYa7o3abdCGFi3NPXqIfPIoVUOIvJwp63lol6
	 /wAAOmdggoFPr6eJy6DHpB945Xdn1+pmGivuSCvd8n7eLSkCwnfXApaMBToDP5TTDVnK8
	 BQw02KJANdWF/twkuB9BXIe7vjR64fcHKBRlvhdMdRQK+mDc/KD999WSlyPvAiT4AQLO/
	 7nLy9Hw1UlrPhWn8Itx4j2A0MAak3zdODGdxtJdO8Nhl/gpjf+xoHKaX6y2JNaArpUIrD
	 Js5bELPeQd4UpHMsn4lR8yLeMDU/YH6T9dnYl7OSYQU75FlK9NVIc6kD1eGTWCBYbUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z8NbnvoiemWwqRxnWetM8dWAZH3awiY1WDfzasiYyOI=;
	b=oLBkQolUOtplHQy9qnXb1eE1SXem5IpTKTHSGxMiI7hFIzq74w2jrEMsWLHdQBksuBOJ
	 7+CfaNKYlJUvtOVOchOdn0M+Vhqcoq6hcC6cEnC08iDynt9pKrxNNemWQV3R8gCWLrD53
	 Qh6YZw3KBMQ0yZrKbzYoLWaWzTkEl2EeBs2vfqIptCQLyNK7/1jLZqgfams7e8fz5fFFV
	 sLA2IDtMmCHRN/atVjn+KvPeuPGw0/KUQHrefxHuU6pT7rq7ge2vY5k2oYN5XXOJ04WN4
	 2g0OXOJvVCkZvlQZYvZEQf/fcmDFkQuJHncoTcrN0taIdW1LudmmEKIDZ7wh93TB/Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDgBVOIN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDCA606A33E;
	Thu, 19 Nov 2026 01:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDgBVOIN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09131F000C4;
	Thu, 19 Nov 2026 01:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050105;
	bh=Z8NbnvoiemWwqRxnWetM8dWAZH3awiY1WDfzasiYyOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDgBVOINKcczJwFPUVc2hs6j+943A9Q7spYSY/h9Z268rqzZneXpprLS3fyaRCzGE
	 5Mvhky5HI37O4drCCj0OgJa3IG2HExN07c9luoGyMCLKlB1iUbUnw2NU0wXVoMTed2
	 MGCC0Zuh073dDwCWu4WZD22JFaNtg8llWtErQvRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2590/2857] bpf: Update the SRH state if End.B6 fails late
Date: Wed, 18 Nov 2026 16:00:24 +0100
Message-ID: <20261118150334.785521032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 427e751a231aa781441d51c42e716905ee348099 ]

For SEG6_LOCAL_ACTION_END_B6 and END_B6_ENCAP bpf_lwt_seg6_action() looks
for the SRH again only if bpf_push_seg6_encap() has succeeded. That
function pushes the new header, for which the head of the skb is
reallocated if it has not got the room, and then looks up the route to the
first segment. If there is none, it returns an error, and the pointer to
the SRH in seg6_bpf_srh_states still points into the old head, which has
been freed.

The program goes on behind the error. bpf_lwt_seg6_store_bytes() and
bpf_lwt_seg6_adjust_srh() read the SRH through that pointer.

Look for the SRH whatever bpf_push_seg6_encap() says.

Fixes: 486cdf21583e ("bpf: add End.DT6 action to bpf_lwt_seg6_action helper")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-14-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index a468e8d4773d9..4872f5c27cf5b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6566,8 +6566,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 			return -EBADMSG;
 		err = bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6_INLINE,
 					  param, param_len);
-		if (!err)
-			bpf_update_srh_state(skb);
+		/* The header can be in place although err says otherwise */
+		bpf_update_srh_state(skb);
 
 		return err;
 	case SEG6_LOCAL_ACTION_END_B6_ENCAP:
@@ -6575,8 +6575,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 			return -EBADMSG;
 		err = bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6,
 					  param, param_len);
-		if (!err)
-			bpf_update_srh_state(skb);
+		/* The header can be in place although err says otherwise */
+		bpf_update_srh_state(skb);
 
 		return err;
 	default:
-- 
2.53.0



