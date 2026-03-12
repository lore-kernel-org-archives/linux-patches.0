Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4BB401A06;
	Thu, 12 Mar 2026 20:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346425; cv=none; b=oUyhC+Thvx4WwnWPIhfP9t99u0te7sqRWkuY25T2vmFTaXWSeOEY3YG0vzi3KNzYNoNBWdzQxr56cWUxRBs2zZHQhkIxPP2whfbksRX6XCwMoBA6kBRMVtUvnOZpBCFt7aNVpaJIcvZ60tuu6Tme2xGRjdLwvqvmBL/p+5jOjrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346425; c=relaxed/simple;
	bh=kYoE86GebXyq2yuqeErxq1D9Kho0SZ//blMwdtR2TZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWD+D5ilYY2cbGf3UkKYclg+3h6cMVs8WCixptFjk0kdsRV/u/76eHoRfUHqQNSL957CgxpHEtFMeuEjEqhkZM+pth7XBbIU/4teD2hEBgY6lPLU2itkEyzBVwkw3CSj4FTceRBwz+/OqRb5hYdu4JkJEE0DG/eYgx2aqVuHkSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHLmnRGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHLmnRGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232B7C4CEF7;
	Thu, 12 Mar 2026 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346424;
	bh=kYoE86GebXyq2yuqeErxq1D9Kho0SZ//blMwdtR2TZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHLmnRGZFj3WJQlYQNU3j+N4Jux5lpFLXObdyRZg42jkIbbETjslr5zCfHCmW5t6l
	 2beWQoHkCaZaBgltl2Kzrd+HcdxyjaCcIxJLhJyi/5BSi7xDJnropIsLvrFae0It/R
	 naXuSWuU0fCIASVsZKW9bLMk6Li4ZR/uY9xXg2YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10cc7f13760b31bd2e61@syzkaller.appspotmail.com,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Kohei Enju <kohei@enjuk.jp>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/265] bpf: Fix stack-out-of-bounds write in devmap
Date: Thu, 12 Mar 2026 21:07:06 +0100
Message-ID: <20260312201019.607626656@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit b7bf516c3ecd9a2aae2dc2635178ab87b734fef1 ]

get_upper_ifindexes() iterates over all upper devices and writes their
indices into an array without checking bounds.

Also the callers assume that the max number of upper devices is
MAX_NEST_DEV and allocate excluded_devices[1+MAX_NEST_DEV] on the stack,
but that assumption is not correct and the number of upper devices could
be larger than MAX_NEST_DEV (e.g., many macvlans), causing a
stack-out-of-bounds write.

Add a max parameter to get_upper_ifindexes() to avoid the issue.
When there are too many upper devices, return -EOVERFLOW and abort the
redirect.

To reproduce, create more than MAX_NEST_DEV(8) macvlans on a device with
an XDP program attached using BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS.
Then send a packet to the device to trigger the XDP redirect path.

Reported-by: syzbot+10cc7f13760b31bd2e61@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/698c4ce3.050a0220.340abe.000b.GAE@google.com/T/
Fixes: aeea1b86f936 ("bpf, devmap: Exclude XDP broadcast to master device")
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Link: https://lore.kernel.org/r/20260225053506.4738-1-kohei@enjuk.jp
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3aa002a47a966..39b7efa396b8e 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -588,18 +588,22 @@ static inline bool is_ifindex_excluded(int *excluded, int num_excluded, int ifin
 }
 
 /* Get ifindex of each upper device. 'indexes' must be able to hold at
- * least MAX_NEST_DEV elements.
- * Returns the number of ifindexes added.
+ * least 'max' elements.
+ * Returns the number of ifindexes added, or -EOVERFLOW if there are too
+ * many upper devices.
  */
-static int get_upper_ifindexes(struct net_device *dev, int *indexes)
+static int get_upper_ifindexes(struct net_device *dev, int *indexes, int max)
 {
 	struct net_device *upper;
 	struct list_head *iter;
 	int n = 0;
 
 	netdev_for_each_upper_dev_rcu(dev, upper, iter) {
+		if (n >= max)
+			return -EOVERFLOW;
 		indexes[n++] = upper->ifindex;
 	}
+
 	return n;
 }
 
@@ -615,7 +619,11 @@ int dev_map_enqueue_multi(struct xdp_frame *xdpf, struct net_device *dev_rx,
 	int err;
 
 	if (exclude_ingress) {
-		num_excluded = get_upper_ifindexes(dev_rx, excluded_devices);
+		num_excluded = get_upper_ifindexes(dev_rx, excluded_devices,
+						   ARRAY_SIZE(excluded_devices) - 1);
+		if (num_excluded < 0)
+			return num_excluded;
+
 		excluded_devices[num_excluded++] = dev_rx->ifindex;
 	}
 
@@ -733,7 +741,11 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 	int err;
 
 	if (exclude_ingress) {
-		num_excluded = get_upper_ifindexes(dev, excluded_devices);
+		num_excluded = get_upper_ifindexes(dev, excluded_devices,
+						   ARRAY_SIZE(excluded_devices) - 1);
+		if (num_excluded < 0)
+			return num_excluded;
+
 		excluded_devices[num_excluded++] = dev->ifindex;
 	}
 
-- 
2.51.0



