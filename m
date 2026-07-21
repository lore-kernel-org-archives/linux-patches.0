Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565C344AB8E;
	Tue, 21 Jul 2026 22:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672932; cv=none; b=QFIUcM8Py346SRjkf9OCQqJeBVH5TSZHHL2v6cJCTF8SazkyGHCWoPfwcyvzIcYXHJGd6lYUM7diIiH6QHz/VbBZzGRmyri8WleV6SZtrGe/wH0czG9eSwT6BEQmPAEqbxwRdpB2dQMPT7tzjzXT+XFjN7uneUqJG2i+aM0STEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672932; c=relaxed/simple;
	bh=Un4xTCx5bQWUTfftPMUW+OzcSdV0fKhN9bsZscz14qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5oF+rhcLbP0WzVHGtq9nPpqwXE1AwzKtOxp6oFIpZVLm40TJ5Bw79vawkxzbgjCuLdW/wX3C/GfDJWQjvMuTCC7ait252GspE/iqd9cp3ADGusKzyBTxWpXRlzWAtZlmOMAP+x0ZHJbTImaoMXO8EfVewlA90qe6iCALtESixc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/u4TcOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/u4TcOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFAE1F000E9;
	Tue, 21 Jul 2026 22:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672931;
	bh=nErppAPQIveCsJs66TNinvqmu3dhDuzeAKuZYA/wmh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/u4TcOh3zA5iTTtoNoV7YnXAxxOw7On7ky+e1sYKLfiVNaqmYcyVJUfr7SdFP5Cn
	 6NCTJwkT+z2zuXigxHYz+H+RWQb+97E0zS3/lojsjCRpGBNVTik8cxRL9RKNKZaFJw
	 AbtjkoDfwOO9AHOwK97rIcmrlpC312wHPlpdzRfA=
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
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 809/843] bpf: Reject fragmented frames in devmap
Date: Tue, 21 Jul 2026 17:27:24 +0200
Message-ID: <20260721152424.270940392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Zhang <zzhan461@ucr.edu>

[ Upstream commit aa496720618f1a6054f1c870bf10b4f6c99bf656 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/devmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -551,6 +551,10 @@ static int dev_map_enqueue_clone(struct
 {
 	struct xdp_frame *nxdpf;
 
+	/* Frags live outside the linear frame and cannot be cloned safely. */
+	if (unlikely(xdp_frame_has_frags(xdpf)))
+		return -EOPNOTSUPP;
+
 	nxdpf = xdpf_clone(xdpf);
 	if (!nxdpf)
 		return -ENOMEM;
@@ -708,6 +712,9 @@ static int dev_map_redirect_clone(struct
 	struct sk_buff *nskb;
 	int err;
 
+	if (unlikely(skb_is_nonlinear(skb)))
+		return -EOPNOTSUPP;
+
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb)
 		return -ENOMEM;


