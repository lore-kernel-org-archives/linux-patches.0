Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061841;
	b=BGnM85zyihiuF3aKLyFMQhb1AVI5AhOUYuL34ViBgGjlFlJ//RLK3m85c7U5otjN5ZzI
	 diY+papNNqpGrDBFMiqx+fpkM9qslOBkF7tV/vLdEQ5kJNx4CxcPl9CPwDLbUHep2ze/o
	 C6fmZ9U6P5wQvTl6aVX35F02OAEAxp4hluIMAu53zi3KgylH3qs1gctbBlcOHTHKL+S2Y
	 b9nUbKfVwZHGcSCkA9sLJgFgr/x8psE6AVdnC3zBT/0ZBDq2Hwh7nr9tWV910oAPrbK3P
	 cNdbFCWQCk/bIpoqPS15Ep9jKlhUnxLogEn5KmCMJsLyl6WAdR/qslqOUiCLwK8M2WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Rs7L2hFOkLGMdqrZUQfEqvO2i9QbmOnL0UihInsOdM=;
	b=QMWoCLLdZBtAHjoJdIgJ0LxRXDrQz3n5HZXZU/w40b5nx1XX+XKLpAt89UBuTZTxEYiF
	 cbEK2X+u8WoGYWlLe7rl1ax8pkk8ybjbkfqb1PeItHEjUlX7ucz9QsF/6duhDU0boQuXX
	 mgG974w0uN7op+4WEjuFSSIXhIAhjaQgzOvdcJjJRc/pl4eJi7NvME1so7m3BHSaU2Izq
	 rF91l1op/T5Ge4yjCSfPdTVrSe6xYW29dlV5V8CSabpYusVqLyU9z9D2hfN7J/eZyOeZO
	 8EO8TapkNEpWOWFaouJIXapagyXOKIAW3z8BWFwTBZNm0S+Lbfev76obuiTKS9DiU2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViQ6B+mw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5DC606A325;
	Thu, 19 Nov 2026 04:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViQ6B+mw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27D61F000C5;
	Thu, 19 Nov 2026 04:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061841;
	bh=+Rs7L2hFOkLGMdqrZUQfEqvO2i9QbmOnL0UihInsOdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViQ6B+mwrOesOjPIMZ05XhFPkuQGEe8c9EyczbCIFSkuhr8J7ucQIG6ytWoBdDU8j
	 Nm/0zazobDMEt0n1VddV1OnDB/3W5H+1C3kDH+kyY7V4gLPNRKzvPiYiRtzzLpZXPZ
	 DH5BxpfeaI2UetZSOEGfLHtjWNvPmxgFZzg3x+KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1698/1848] bpf: Update the SRH state if End.B6 fails late
Date: Wed, 18 Nov 2026 16:02:16 +0100
Message-ID: <20261118150030.844855595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c1dc4e730d0de..2e9cd1558b2dd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5923,8 +5923,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 			return -EBADMSG;
 		err = bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6_INLINE,
 					  param, param_len);
-		if (!err)
-			bpf_update_srh_state(skb);
+		/* The header can be in place although err says otherwise */
+		bpf_update_srh_state(skb);
 
 		return err;
 	case SEG6_LOCAL_ACTION_END_B6_ENCAP:
@@ -5932,8 +5932,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
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



