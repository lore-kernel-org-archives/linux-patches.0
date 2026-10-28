Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216361;
	b=Ye39PMsSMkBEZdyvZds2whotnSbAhmkIC+/8tPCZ3lGxPaDC4Nww8eth2N43PlOmBJjA
	 K0dX39taXSADGtLZS/OJ0CSxPBE6vZreoJbJmMyatFNENE61WlZTUFBNjo/XVvMI21qbi
	 QxGHtDqA+QoDuKdBM31jla5s3x0puKRKFOcj+Y/3om1mF+5ldnmlDbl7BH4X6bK6LMuv6
	 TeiYRrc2eoDdP4oLyguQhEqOA3UwMMrdd5PyGBeeg782GMQcwrGCVJmDaW/PaekBoGQxb
	 E3yzCXQJVIPLk32oE80+ILBaEqsrKCHM9hFftp2boZYKNpXhJYztVluFk5SWazzy+Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hRm/NNZA0s3haJPKJc6U3ZQH7BeydrrRFajwxWfDmxA=;
	b=OXNbLF7O7pRAFTbfOpTZMUch4bYtjtSaPtMeoB1YCxftx2zWx4H7aRA+aPG/yoT3snKj
	 SfNLsFvAV3zIZxkHCQJtvmLQ3WnMGDR+h7+l6L/1UnS7v6ufgC/H4GBWQQGHehGC8+/A9
	 9yd1sVzAjDbbd0EZNWX3Tx/sqnJkpTVLICDbaCfx12ki/l3xHC/ZvSg+N6NKI3U2dJf7B
	 9eEyNqZII3afZLr/3SiP9fYnqM5s7HHF42nV0RNKwiilltoMt7BVN/qsk3ZcEiRKUlMeu
	 IC+LQeitkzZgNDsiFybQgCGHUrIVvns8t9e76u9FULZpU1BpZ8xjB7re/ZwshOzymcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6BFEym3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993E2606A31D;
	Wed, 28 Oct 2026 19:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6BFEym3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A091F01825;
	Wed, 28 Oct 2026 19:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216361;
	bh=hRm/NNZA0s3haJPKJc6U3ZQH7BeydrrRFajwxWfDmxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6BFEym3lA3gn4iLGqADJ6TXj5iVXqb+fToo++6d1gEIKrBgIONgPO8Et1ETC8BL9
	 XOh1laGVaa3QIpEQld74TaFUuEk+0z1EsMoZHq89fAIkayfgfOUZ2pNMVjtoSZjLgn
	 yKqxb2Mvaf3ZtcPVKVWMwE02fKfEZdG20FGSlsOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1531/1887] bpf, xdp: move offload check into dev_xdp_install()
Date: Wed, 28 Oct 2026 18:00:27 +0100
Message-ID: <20261028170534.303563406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit ad27ed7d2309419a129078d781504f486b1b469a ]

bpf_xdp_link_update() calls dev_xdp_install() directly and skips
dev_xdp_attach(), so the checks in dev_xdp_attach() do not run. A user can
make an XDP link with a normal program and then swap in an offloaded or
device-bound program with BPF_LINK_UPDATE, which puts it on the software
path.

dev_xdp_install() is the one place all three paths go through:
"ip link set xdp" and BPF_LINK_CREATE reach it via dev_xdp_attach(), and
BPF_LINK_UPDATE calls it directly. So move the program checks (offloaded,
bound to another device, device-bound in generic mode, native vs generic,
DEVMAP and CPUMAP) there, and keep only the netlink-flag check
(XDP_FLAGS_UPDATE_IF_NOEXIST) in dev_xdp_attach().

Fixes: 026a4c28e1db3 ("bpf, xdp: Implement LINK_UPDATE for BPF XDP link")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 804752cc864f4..7c0d0905dd31b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9249,6 +9249,29 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
 	struct netdev_bpf xdp;
 	int err;
 
+	if (prog) {
+		enum bpf_xdp_mode other_mode = mode == XDP_MODE_SKB
+					       ? XDP_MODE_DRV : XDP_MODE_SKB;
+		bool offload = mode == XDP_MODE_HW;
+
+		if (!offload && dev_xdp_prog(dev, other_mode)) {
+			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the same time");
+			return -EEXIST;
+		}
+		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
+			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
+			return -EINVAL;
+		}
+		if (prog->expected_attach_type == BPF_XDP_DEVMAP) {
+			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
+			return -EINVAL;
+		}
+		if (prog->expected_attach_type == BPF_XDP_CPUMAP) {
+			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached to a device");
+			return -EINVAL;
+		}
+	}
+
 	memset(&xdp, 0, sizeof(xdp));
 	xdp.command = mode == XDP_MODE_HW ? XDP_SETUP_PROG_HW : XDP_SETUP_PROG;
 	xdp.extack = extack;
@@ -9377,30 +9400,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 		new_prog = link->link.prog;
 
 	if (new_prog) {
-		bool offload = mode == XDP_MODE_HW;
-		enum bpf_xdp_mode other_mode = mode == XDP_MODE_SKB
-					       ? XDP_MODE_DRV : XDP_MODE_SKB;
-
 		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && cur_prog) {
 			NL_SET_ERR_MSG(extack, "XDP program already attached");
 			return -EBUSY;
 		}
-		if (!offload && dev_xdp_prog(dev, other_mode)) {
-			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the same time");
-			return -EEXIST;
-		}
-		if (!offload && bpf_prog_is_dev_bound(new_prog->aux)) {
-			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
-			return -EINVAL;
-		}
-		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
-			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
-			return -EINVAL;
-		}
-		if (new_prog->expected_attach_type == BPF_XDP_CPUMAP) {
-			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached to a device");
-			return -EINVAL;
-		}
 	}
 
 	/* don't call drivers if the effective program didn't change */
-- 
2.53.0



