Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8453D994;
	Sat, 17 Oct 2026 16:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254949; cv=none; b=Bn3r7cBQT0Yp/gQSWhAtS+0z1UUKmre68h0P/zdUXWc3yUv0nV40Ec4hBlTtE1GnQiHYAI15NNU5QD2mU8qdnvMGRx68zzcaVZn2P2IThr4SsQ+5UZtIgH+Wru+irrfl0a3cMKF1tWrrPz44rjxm/zq5+z9ISQJmSrZY2X4hr/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254949; c=relaxed/simple;
	bh=rDDstsmXyu2bfk6ovj7P3j9TX9jD3yL/Ug3ufQ91mWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzPe1riW2BDlKk7oeURUD0V92So5IueAlQjm9V2bmjGPTKKFSPtAemHkuNI4o9BrRD6udWOAFYvhNBgKhrxny1VCRoxq0KGrtTxiJN+2mNDYxtRFAlmE2LNp1wbhYzdk9l1g1idx1VkNH42lk92Ke5LYhw/HfOPIT2vlba/JGqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCHVJihh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCHVJihh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9051F000C4;
	Sat, 17 Oct 2026 16:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254948;
	bh=IMAGaawnwwbGTTDAtriGVyDuwDrBvOwVr0HXsVtFr3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCHVJihh7rvmhue5nRnX3krHsmgiAN6y5rwDGZJchLvuxEV+sor4r9GbKxYRcF7kg
	 5vivWr7n7KXuOg0ADrYKfaUOTwuHIrvmDqTTULen1i4OZOJ4y3oduliwr9nCIUnIWm
	 6coK2wXT1k79h9r1njJP4DbMkMvl5Q5zW+akXBV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 616/869] bpf, xdp: move offload check into dev_xdp_install()
Date: Sat, 17 Oct 2026 17:57:37 +0200
Message-ID: <20261017160052.826171503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 net/core/dev.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9888affc68df3..8f507292f8ba4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9627,6 +9627,37 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
 		return -EBUSY;
 	}
 
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
-- 
2.53.0



