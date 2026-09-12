Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F735E549;
	Sat, 12 Sep 2026 11:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211552; cv=none; b=DubLO+q3LTCU822f9lhh7a4c5VjIc2WC61JaSfbt6r2P38HmWyazkXU+Wr6R8LXFQ4Wb4xK/ddHdv/nAnbQFWJKN5oTytWYUeEYgwIjOLOn9yraYiCvtx0gvLZwigsujcZz0PaUsjWRI0H4bxiZ4rdaT44yKdUqYL9eOn6+BUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211552; c=relaxed/simple;
	bh=zyQrx6sRq8BFyhjdIu++TB8Fadw0sTx5TptvG1iX7q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imNgFGVbh0uh8Nhu/9kkSkc+2tm+CpS+NFHFLUvvd3lB9xS3RyQ5QfIL7+520q1EQQO1QzQ+lxTJOCGd9a5WTyYeAA5SzlUgNlYSYzXXZIDS0wkCCxGkuxymV/SBMCEYtfhyUvKaiHNR101p24YctgaJTe8S4hiwTzNnF9Lz9T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avvYgYbH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avvYgYbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FAD1F000FF;
	Sat, 12 Sep 2026 11:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211550;
	bh=L0JKE77iZw9DI0JVRdpXDMEFdvB/t1IvkdZF/1b05sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avvYgYbHCtNiwIC6G+FOgZ3jDdxtec55mI28Djq//rT7jsUPzEc5jlE86OxXSuzR/
	 Rizje5osXRbBK3s6YgT6ugf46Csc7vNGyoYmd+9YEddJc9BK0dWf4mBtzt2wODm/UF
	 JLIcYjNdANl9TtyP4LKEAi7UZlqj16oTzEoLzQdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1255/1518] bpf, xdp: move offload check into dev_xdp_install()
Date: Sat, 12 Sep 2026 08:57:04 +0200
Message-ID: <20260912065651.901488115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e37c532c92aaa..966617838f403 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10241,6 +10241,37 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
 
 	netdev_ops_assert_locked(dev);
 
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
 	if (dev->cfg->hds_config == ETHTOOL_TCP_DATA_SPLIT_ENABLED &&
 	    prog && !prog->aux->xdp_has_frags) {
 		NL_SET_ERR_MSG(extack, "unable to install XDP to device using tcp-data-split");
@@ -10380,38 +10411,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
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



