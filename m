Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C68D41F34F;
	Thu, 16 Jul 2026 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212146; cv=none; b=i76oxrKEOomscO6EVKJsZen2F2AXqGoXe3HggT38bAIln2b2wyrGftAI0aJN8783dgPmYxaQZ0a60gxsNQRDLp8WrrwoBcOBbuCniCTWNEjizAnSQ5iJ1uqQod3/A+OErALBqZ7RJ5z+jg1yjopx/E40Ivp6wqx0utkRijqyRjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212146; c=relaxed/simple;
	bh=dEiVx0rJlWpyS+jKkBVAiTfbJkfrRKIxjJZFWjXVwL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aTDMKRSTOIH9mvemQaplPCSy4UtQuHZnY0ruRzxEt7QJIcb3ZvGRwvOBSO3Pl9z+8qT1Aa5fE0B7mHJ3JMc6JymAGTtFRdGskdBJiCz6BV40PIuCAfe57Op+7NOC+vFilSW9uI6zpP+WmbMbtUM5yhCbzhiQL9a0PcoUGMJs2+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kbo9AL8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kbo9AL8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78181F000E9;
	Thu, 16 Jul 2026 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212144;
	bh=i5zujhmwdQzo2gdXTiIo+7jEJqDzxn8cy71duaKeBHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kbo9AL8bNOK7mlIx4G/4RthnlP4lHwKpxerR7KjvZnr/xPelvrafgg5op/thXEuUm
	 p6FqYJQAldnwlhlyZPVWyuiNLfrfJ/Ur5A3n64gVpQnGHmwYZP8EX12vJYHa3oKoSJ
	 sf+R8JnVi0cpmx1vz/5gAwp+RU7mgLPLjC81AWCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhao Zhang <zzhan461@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 216/349] bpf: Reject fragmented frames in devmap
Date: Thu, 16 Jul 2026 15:32:30 +0200
Message-ID: <20260716133038.197359571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Zhang <zzhan461@ucr.edu>

commit aa496720618f1a6054f1c870bf10b4f6c99bf656 upstream.

Devmap broadcast redirects clone the packet for all but the last
destination.

For native XDP, that clone path copies only the linear xdp_frame data,
while fragmented frames keep skb_shared_info in tailroom outside the
linear area. Cloning such a frame leaves XDP_FLAGS_HAS_FRAGS set but
without valid frag metadata, and the later free path can interpret
uninitialized tail data as skb_shared_info, leading to an out-of-bounds
access during frame return.

Reject fragmented native XDP frames in dev_map_enqueue_clone().

Add the same restriction to the generic XDP clone path in
dev_map_redirect_clone(). Generic XDP represents fragmented packets as
nonlinear skbs, and rejecting them here keeps clone-based broadcast
support aligned between native and generic XDP.

Fixes: e624d4ed4aa8 ("xdp: Extend xdp_redirect_map with broadcast support")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/21c2d153dd25603d359069a02bf06779b51f6423.1780385378.git.zzhan461@ucr.edu
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/devmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -569,6 +569,10 @@ static int dev_map_enqueue_clone(struct
 {
 	struct xdp_frame *nxdpf;
 
+	/* Frags live outside the linear frame and cannot be cloned safely. */
+	if (unlikely(xdp_frame_has_frags(xdpf)))
+		return -EOPNOTSUPP;
+
 	nxdpf = xdpf_clone(xdpf);
 	if (!nxdpf)
 		return -ENOMEM;
@@ -714,6 +718,9 @@ static int dev_map_redirect_clone(struct
 	struct sk_buff *nskb;
 	int err;
 
+	if (unlikely(skb_is_nonlinear(skb)))
+		return -EOPNOTSUPP;
+
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb)
 		return -ENOMEM;


