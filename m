Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3137374A16;
	Wed, 30 Sep 2026 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786976; cv=none; b=qYkVFPO0RGopS6qbGhu0W6hYIaOeh6v9D36cgKT+1QG8Jiby4irRz9iRKpK0EaxCFyIq8bFEFBhJiAjlS0IuN0LsazL6aPwQwN7/jUfMI9Zh6kIOXWeH6KKyv7yRCN+Cz2bJvsSM7KPpeGckwfIhXEMT/yZXIlnPc+LwrpX9ZyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786976; c=relaxed/simple;
	bh=OxQaKm2xFgj2quSswcm07V4IS2zwlwsPUWRAX6vAaBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A64Kf2+Lrhn00n3QiKaIncXJYBQz0tzMLqzuxxk20j3jrttCxBamkHnhaUWA2qyWUt+91bEhRGaJa1YMAvi9GwWkRx/zr3MiaYs5uykIg3QYHrZeyVi+Is2c7KiAD0JikNTHlCc+BDndpf2YM7qByQyskbhyDmh6qMu01is7TQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iUFDrCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iUFDrCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCF41F00893;
	Wed, 30 Sep 2026 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786975;
	bh=mjdy9n4xvYAD7k5BjW6HP2hcBvhAVPd1sJnTZbzuq4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iUFDrCMxY7TnGfHfFdazKUBEXWBDl8LcmFSteq7ljL9s5+AkzRKrXBGtvz8hudGp
	 mxLu7kqxbJFHUMCSUKQhIv1G0eoOx6tPTseltVwag6WDh00GtviZ5lZVWdKOFrhwUb
	 4mKtI9skK/nvLngD7lLpI0fqaBMBj6+OfzX5ldGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini + nipa)" <sashiko-bot@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	hybris <hybris@mojatatu.ai>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 069/457] net/sched: cls_u32: fix manual hash table handle IDR aliasing
Date: Wed, 30 Sep 2026 17:22:54 +0200
Message-ID: <20260930152347.538866579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 0a5f5d9e94dead312d32c366b917c64e552b72f7 ]

A u32 hash table created with an explicit handle ('tc filter add ...
handle 801: u32 divisor N') keys its IDR entry on the raw handle, while
the destroy paths free it under handle2id(handle). The two key domains
disagree for handles in the 0x800..0xFFF htid range:
handle2id() folds them back into the auto-allocated id space (1..0x7FF).

A manual table therefore leaves its raw-keyed IDR entry unreachable on
delete (a permanent leak), and its delete can drop the idr entry of an
unrelated live auto table. A later auto allocation can then hand out a
handle that aliases the live manual table; u32_lookup_ht() first-match
routes lookups and TCA_U32_LINK for that htid to the wrong table.

Key the divisor-path alloc on handle2id(handle) so allocation and
removal share one key domain. A manual handle that maps onto an id
already in use is rejected with -ENOSPC, and auto allocation skips ids
held by live manual tables.

Conditions to recreate:
  ip link add test0 type dummy
  tc qdisc add dev test0 clsact
  tc filter add dev test0 ingress protocol ip pref 1 \
          handle 801: u32 divisor 16
  tc filter add dev test0 ingress protocol ip pref 2 u32 divisor 16
  tc -d filter show dev test0 ingress | grep 'fh 801:'
  # unpatched: two live tables with handle 0x80100000 (the pref 2 root
  # hnode is auto-allocated id 1); patched: the auto hnode takes id 2.

Also tested with a poc with a live u32 table on the block, add/delete a manual
table 'handle 901: u32 divisor 1' twice; unpatched, the re-add fails with
-ENOSPC because the raw key leaked on the first delete.

Fixes: 73af53d82076 ("net: sched: cls_u32: Fix u32's systematic failure to free IDR entries for hnodes.")
Reported-by: Sashiko (gemini + nipa) <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260822222049.114526-1-jhs@mojatatu.com
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Tested-by: hybris <hybris@mojatatu.ai>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-LQFE.v1.20260911041746.1@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index a3e65c8cf29ef..76ce2d124079d 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1003,8 +1003,16 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 				return -ENOMEM;
 			}
 		} else {
-			err = idr_alloc_u32(&tp_c->handle_idr, ht, &handle,
-					    handle, GFP_KERNEL);
+			/* The IDR is keyed on the mapped id, and that is
+			 * what the destroy paths remove. Ask for it here,
+			 * so a manual handle colliding with the
+			 * auto-allocated id space is rejected (-ENOSPC)
+			 * instead of aliasing a future auto id.
+			 */
+			u32 id = handle2id(handle);
+
+			err = idr_alloc_u32(&tp_c->handle_idr, ht, &id, id,
+					    GFP_KERNEL);
 			if (err) {
 				kfree(ht);
 				return err;
-- 
2.53.0



