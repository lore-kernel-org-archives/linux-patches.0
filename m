Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041961;
	b=IrqWJbhw7ai2+4mOamHOf2bVUp1dusdok1UiP1dIO1+8hLkH9yr7/oLWkAuzIuWBT1mZ
	 FQ+kQAdFdcd1aUcqac/rn/RgcvzJsNALHmUMBaEUtE1OrwyH18c8bGNxv8ztP7bSL7hYQ
	 mittNN9hxbyZ5TKWE7ImBK52KXIdLRvOa0zvBNamoErjB5dPCSpbm0vh0EjQe+CTxep5B
	 ISwRTwZwEBohKmQmMbF5WRJ/kiUslgFOcgT0CJUVWlGK6V6fNsWwAqXceulNFV0undGJS
	 7amC+sb3dUOh3PLKxLRjCU170+45IReoAivyRu1BQ/YFOVfoDWrRLrvIxkzrPKLJvpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WysjHEiyrztGpwXBdk5Gxf3y5VygB9YSsrvKngy1iws=;
	b=BHl47wwIXkycJ6iVQ6uRF4i8zvuRU6AkjdTBIHXC4dAaVbVs9MholFVfMhH2/ZvUGxSf
	 znLaFmNc0lj+T4lbajv5prtEOM9oIxnNxs8RUG3G+nPRcrbQuCZCzp11Evvtro/7a5xUP
	 3iMiZrz1HbXwbk1/bsMD2Dg2lkXVAFEuUCKhGlxpcbhxlE2OnBvDhs+nbdpj/g4gaOKmz
	 3iGFwnnajrtQJf2D+f5X/jDhFvwkecy6PG4/+Dy3gMD7vrVFfVe+1Nf33iuuyU2wifcUP
	 kmJOum0IGCy3mK1hWeQVKSobrzBvJ+8N4m6z/ki3Gq7wl3TOozxhpnia6gQXUJdevqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qcv5Qx9J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC6C606A325;
	Wed, 18 Nov 2026 22:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qcv5Qx9J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1C71F000C4;
	Wed, 18 Nov 2026 22:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041960;
	bh=WysjHEiyrztGpwXBdk5Gxf3y5VygB9YSsrvKngy1iws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qcv5Qx9J/1eAGP1+eL6s/6BRobse3kDhg36d8QIcdLeOK+tblSdjyVeLnU7E724Tz
	 8lqMas0PIdnZdRP0XTO3sLN+Qd78MbGvdhVT/+jazwKbwuDAgCobp1P14j0YZhpwjN
	 mSi1tOQe8CEFxrzJe7UklrCRkQK60+sP3ttYSd18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3000/3318] bpf: Update the SRH state if End.B6 fails late
Date: Wed, 18 Nov 2026 16:00:22 +0100
Message-ID: <20261118150450.262917952@linuxfoundation.org>
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
index 0e50d1eb146f9..cf123f6410ac3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6644,8 +6644,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 			return -EBADMSG;
 		err = bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6_INLINE,
 					  param, param_len);
-		if (!err)
-			bpf_update_srh_state(skb);
+		/* The header can be in place although err says otherwise */
+		bpf_update_srh_state(skb);
 
 		return err;
 	case SEG6_LOCAL_ACTION_END_B6_ENCAP:
@@ -6653,8 +6653,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
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



