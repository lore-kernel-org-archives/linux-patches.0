Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5B04F85D0;
	Tue, 13 Oct 2026 12:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894748; cv=none; b=fWCZKn2TpAQcJ53qnjsqaMTquZ6AoYl79ps8DpOoizdu0eVOz/bnpI7ScV7sVDcjqbjaXKS4ASMmCIuSDhLTaaj+8BViyeofqvP16H1uuleZOm5FaeEyl7K23VLYCnYJVzMb7ddCSCGrsN8OLzQfYkWEu+z+CNWCfWmYeAWDZJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894748; c=relaxed/simple;
	bh=JjN9++SwpdDl5927TJxTXAuKt+z+Ydz0LN/45zwnNrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSFQi1ZfuoUUk93JgZPDy6krTRJQPx4YaEwSUi6bI4lUgWNHMx7rtlcrXeHduIJVtHbd4v1yK8FFLer7Jf2SsJPa8XLaomIAdpC2R6qfqRpoX+Xwtu6hamSeAyLo1YanO2a1xLW934isEc1Coqb+eSoYfvAg2983fK7SWcDhHOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWX0KWv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWX0KWv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5871F000FF;
	Tue, 13 Oct 2026 12:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894747;
	bh=u/Rv23l8GOaC3FYpPljCtfvLwhPZSGtNmqzmysRPteg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWX0KWv6dLgJLKTWO2mAGwigoptk6A9o2jWdThCuA3ME5noN78r+SUAIwwdW9omYW
	 dvpKazLlk+jgpT4JplCXw00Us0M6IDMDkEdVp40x223+NOBmcG6e/4MYhYtAmJS/uK
	 NbzUGKO4/7P0RrG1YfpZmdO5wS2jlHDgtNB95Ma8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/497] bpf, xdp: move offload check into dev_xdp_install()
Date: Tue, 13 Oct 2026 13:32:56 +0200
Message-ID: <20261013112908.100249286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 net/core/dev.c | 59 ++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6c63867ff76d6..97be4f9dfa771 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9539,6 +9539,37 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
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
+		if (!offload && bpf_prog_is_offloaded(prog->aux)) {
+			NL_SET_ERR_MSG(extack, "Using offloaded program without HW_MODE flag is not supported");
+			return -EINVAL;
+		}
+		if (bpf_prog_is_dev_bound(prog->aux) && !bpf_offload_dev_match(prog, dev)) {
+			NL_SET_ERR_MSG(extack, "Program bound to different device");
+			return -EINVAL;
+		}
+		if (bpf_prog_is_dev_bound(prog->aux) && mode == XDP_MODE_SKB) {
+			NL_SET_ERR_MSG(extack, "Can't attach device-bound programs in generic mode");
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
 	if (dev_get_min_mp_channel_count(dev)) {
 		NL_SET_ERR_MSG(extack, "unable to install XDP to device using memory provider");
 		return -EBUSY;
@@ -9672,38 +9703,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
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
-		if (!offload && bpf_prog_is_offloaded(new_prog->aux)) {
-			NL_SET_ERR_MSG(extack, "Using offloaded program without HW_MODE flag is not supported");
-			return -EINVAL;
-		}
-		if (bpf_prog_is_dev_bound(new_prog->aux) && !bpf_offload_dev_match(new_prog, dev)) {
-			NL_SET_ERR_MSG(extack, "Program bound to different device");
-			return -EINVAL;
-		}
-		if (bpf_prog_is_dev_bound(new_prog->aux) && mode == XDP_MODE_SKB) {
-			NL_SET_ERR_MSG(extack, "Can't attach device-bound programs in generic mode");
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



