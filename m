Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8141334B437;
	Sat, 17 Oct 2026 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256190; cv=none; b=SnlCnyHgstuNwFzkBkCrJIFDYPWhB3gQor7Jtg+j6ZSFgiLtESXMFeoWQcgfj5f2OtWqIjpgFCC6qH5hZcIYl4U+Yw1AnWEN2chs4Cedk5g3k3ijPV0CXr6SmTQNXiii88VhBhIIuQB4KMCHR8rGh9FBkiPY5cT7Aua2qEbV5ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256190; c=relaxed/simple;
	bh=C3zFGq/cNYnighre8Qx7hOGqc8lgfZAad4RX5meEjcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhhB/BKYwT+sB6YOZoMQ0D2AbSbV70EKHaeNSqv0wIQIlBVwG9qORMKK7FzXorsJkMXCwKk3I/Okh9TRIDOI7JZF2VdKx8FbAb1cwkYjeRqnOvoMMUWkMywnnykBy0hn0CrtFnXypYdEqw2KB9A52URFWPajScZh0INaQD6j+LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZb/oShM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZb/oShM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BAC1F000C4;
	Sat, 17 Oct 2026 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256189;
	bh=LJoeLQ+Z1E60o3+liJ1+0bfAoillXWrcYwPNLFNOX0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZb/oShMxT0XoK96lOCaxzMD8R3ZV8Pr5cw8EnYCVpsetzsOLql2FUME/NsuQ0qg7
	 71dsQ+qeoHHJDBuvCCXK2u+303kNBtLugvKFexbgBs2GDkeEu5hB1YNOzOOxC+ljwq
	 GTka3UINGqZIiV1zUYctAF3P80LhmR/+YYMyMYTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0153/1674] bpf, xdp: move offload check into dev_xdp_install()
Date: Sat, 17 Oct 2026 17:40:25 +0200
Message-ID: <20261017160435.091474483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/core/dev.c |   59 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9304,6 +9304,37 @@ static int dev_xdp_install(struct net_de
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
 	memset(&xdp, 0, sizeof(xdp));
 	xdp.command = mode == XDP_MODE_HW ? XDP_SETUP_PROG_HW : XDP_SETUP_PROG;
 	xdp.extack = extack;
@@ -9432,38 +9463,10 @@ static int dev_xdp_attach(struct net_dev
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


