Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816B0383C84;
	Wed, 30 Sep 2026 19:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796659; cv=none; b=XFQ1xdebaoTIFqbJC6jJwGTQmnQyqdpuRDLGgIRA1SE4eelaIdQYN7eDCIA05cXaGfnish/wIaNv8XFVZ036jMnptjHGmScWHLMOzTZe4MmaaWf79RUwZtlZZRpVDZ9gG5TaXOYLWOUvaChxE1akJMfImnqNhSf+eSyh7r1sQxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796659; c=relaxed/simple;
	bh=k5NUmhnvAKY9UdIxdMQ4CMip6Uzvf0xTFfgF8PMVUKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCqBY2SfA1gyUassaxRntSnuVeAkBD8xvFdritJN+zTD6pOJaOZ7NJ4Vfs1MS8cugbCu5GC2QJhKpfSArhcru0FT4QnLFufu/+snIlG5cuCHlnkZvkX9v0MTFET/LtqNY7ebkYNOAHIs8eVsZwEsp/tPHFRdp4i39qELCy+AxjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nge9ARvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nge9ARvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03ED1F000FF;
	Wed, 30 Sep 2026 19:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796658;
	bh=N3eN6WIlO0pOam9j6NJhGTC6sJf1IHE3eedGtWCFB9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nge9ARvCvdTOYydgMH02qyGwmFmgCCiLZIESyOEyWS71Smf/vq0/UBweeQWePm+vA
	 /6Oe3/tBFIcfZjImEylyI8PdSuGV2AJvv34yqybJYUZN1g9BQ9cIirmtP3E6OfbEnO
	 nW9+Hl5OSohI54p62LDdm6+SfX/JMU5gt/6ZXD/M=
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
Subject: [PATCH 6.6 0989/1193] net/sched: cls_u32: fix manual hash table handle IDR aliasing
Date: Wed, 30 Sep 2026 17:27:53 +0200
Message-ID: <20260930152456.216777853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index d11224873952d..30e703fa22a73 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1000,8 +1000,16 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
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



