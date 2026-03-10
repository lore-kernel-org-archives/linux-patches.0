Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD9A2D24B7;
	Tue, 10 Mar 2026 11:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141083; cv=none; b=EXIaaSDY0MqSEkxSfDZljXh2RECVgbSVMMumLdJlHwC7NsLrQVffAKUCm/sbFJ40zW4jRRbIMINPNEo1tRbzwc5+8SCgV6g3r2JwAZOUi5hXXLqz6iSSspICvw3ndrL5oA2q4+AK7lz89ORc6Ag1h0FRCGQy3+1OT2hMS78+q1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141083; c=relaxed/simple;
	bh=LYwXZxwthhtnmo4D/h3CRnInbDzpXy/3shh4Dk+KBL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gh0JvaaHIz9XEmdLUZj75z1GMdRMBab/6YlW7LnAwS5uu8qZ4vL4PW8Q7jc7lYOZmUNNpTAqoKg2K51VuT3EnnD5sIpeA22TQgi730cfk7qOzvXqa6WB1ZPlUKkJCT3I28EGw2cJsmCTwYUdvFu3poHaoOe9iTy34LqBlLKN1Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rX4H0r4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rX4H0r4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AAFC19423;
	Tue, 10 Mar 2026 11:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141083;
	bh=LYwXZxwthhtnmo4D/h3CRnInbDzpXy/3shh4Dk+KBL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rX4H0r4kzER9PG5X8fsLGdFVfDhoqetVueeuVXHSxfBIhj4T3HIciawW5X6a7cYHv
	 pgYs0UBcWNDV7CHXDDzWVW3KFdOJYBFufx1NDXgu+ouL8z+SwpeJTXuPnGxShzfSL7
	 l//1UAujm/H5XyP+7Gp+tZKOnj5zv6i0b4uZjrKAD0k7N8mWI9Jk/6x1X7mNn6+D+w
	 yvwYv8hZB7XY+RkkH3w8qZw3JYTAtVyGf05UTMutCYaLySwch0JzvMOL6icrZRcKtp
	 myPjedZKQQNmY4lWlo7QTTy1pi+a39YQ0xqj7stvsfqnhyDX+8AZDpYXGCG3zpqxnS
	 iopGXitXUcaHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kohei Enju <kohei@enjuk.jp>,
	syzbot+10cc7f13760b31bd2e61@syzkaller.appspotmail.com,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 083/311] bpf: Fix stack-out-of-bounds write in devmap
Date: Tue, 10 Mar 2026 07:02:10 -0400
Message-ID: <ca43d3606a887a650e87fc7affe4acea8bc57450.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 2625601de76e9..2984e938f94dc 100644
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

