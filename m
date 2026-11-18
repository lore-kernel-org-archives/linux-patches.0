Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020970;
	b=ajN42IjcztiGaYMifLQ3bYO7IaLiSka3Ljply07qRLBAx2ViTsCQ9zkfKa5jus7gdoij
	 NkKbmyI6fmdEtSz6fAqlZDk3XEH0m+58LuGP/QsAUXw/db8vby3VDJLyRP12Oenj7HXRn
	 tUWS/EjDbIVXKCgfx+9mogB6+xV9qtBUXEODEsLmTztNFTVL12JLN26tO02YlW1yFmBci
	 8k7xmsfrzWhR4B7V4QfEHcBgpb/E1QWUE1v22f5XqnLjouid8tjZGnQ4ltI7icJrP3rhB
	 xegbx4LiOslhLvkcFXYB2wvt32tA9/DxWBduAUIgojjSFDu85PbXNBRY0G/wGh9LrLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bVdXl8LYDL3mTiMNYltm3EcS/PKCY7V3HWEH3GkzC0A=;
	b=BYqePG/VxdvZ+JZGRyPMJ8U/c2kJpf3LIQq6fBNt9g7xVYZlU/YWhiFQHdgYtI+1UNh2
	 U63iKOzOcfGPiP8qiOb/4QP9wuz+aNb07fQpZCfZGgiRWKNRmOAb7fDU78QwXi1p0aX3j
	 TShM/zq6Wv4IrWtLY/9GZoybziYG6C6fPiRz8xDs9ARTdUBeNAWP926mnOXASSeXpYnrH
	 btzrjLmAAPPCQ8+6WCEK6f+Pl554G5lul5bmmVlg6mhYrV2owEQqGR7BYYpftmyERLwN6
	 DVmZbp5655spieC+TVhz4BNp45lT+Hn/qliE0jJnPh+t7wx2IUXS5j+ZT5Fi+FkhMug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o88sz6le;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D28606A31C;
	Wed, 18 Nov 2026 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o88sz6le
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0361F000C4;
	Wed, 18 Nov 2026 16:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020970;
	bh=bVdXl8LYDL3mTiMNYltm3EcS/PKCY7V3HWEH3GkzC0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o88sz6leYbWe2ZN03BifkGK3l7OuZdtyQSirK69DhsCAFwa8NN3pvM97ONt4+fQ6g
	 v9+WxpXi+WkD1Itw2HctUH4DjcbU2EgJ21S0vQI/rPuwECzXkDtRbVXe5/oxR1l7MI
	 3KryClaCoGTGQ2fGsRhsVj879UV0XlKA+yUuOOlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2101/2651] bpf: Update the SRH state if End.B6 fails late
Date: Wed, 18 Nov 2026 15:55:41 +0100
Message-ID: <20261118150401.623711499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 1a01b8e364504..2e6ebfabf6deb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7094,8 +7094,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 			return -EBADMSG;
 		err = bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6_INLINE,
 					  param, param_len);
-		if (!err)
-			bpf_update_srh_state(skb);
+		/* The header can be in place although err says otherwise */
+		bpf_update_srh_state(skb);
 
 		return err;
 	case SEG6_LOCAL_ACTION_END_B6_ENCAP:
@@ -7103,8 +7103,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
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



