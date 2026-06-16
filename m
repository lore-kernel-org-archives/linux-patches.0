Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62437466B5E;
	Tue, 16 Jun 2026 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630492; cv=none; b=gr2W2ahGIBYUTVIQwY2ozryzhGxWco8HJ3hyel25ZZdAdv27hbQdz26Y0PLAQkmvBkihYkEJOi0tzVv89M3M2oc1e2k9NeNZwoU09CnCoN7hXCKdMogGiSL9eps7MHGW257Q8XWwvZ4KCYQYStsWffy0XFW73Q7tNHOjEKMi8r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630492; c=relaxed/simple;
	bh=CgqnsjmWygsCgyqpMTsLrq8QeJhnLAcVaGpbpxRsIQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vsneq2vbyfGGUATD5OE0z6kizFF3d/bNxdNl5v1ety63kHImJId7uKqnyx8msWPk+h6qaV+xq+Pw0cHEdqgc/Emnf/YRwjKTkQvxA4vouVKruV6/Hfo6F63L/ij2SUD878gzAzOeDWzZkuj/z7y7UrHS7V4b5oDxPo0UcGmRnHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ge8b8+9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ge8b8+9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509DD1F000E9;
	Tue, 16 Jun 2026 17:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630490;
	bh=AcZyZa4aLcsKy/Z4YVvQSTazVH6SXcJ0pHypBRrgEoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ge8b8+9rrxnJ7NFZBUcuCo2/MKrfc5sLcZkEAlYGNy91ZX1aF5++dAQOGMXZOu9eR
	 mcvCkojnO1vKWkqZ9doCbbZ/ZM7ERuq21MduvfkOpMezngCLmDmhYiVkdzz0X2zCu1
	 nUJSmOFpjyhykwJgqCIgfdGtkl/nUNHIYB87LHZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/522] ipv6: fix possible infinite loop in fib6_select_path()
Date: Tue, 16 Jun 2026 20:23:07 +0530
Message-ID: <20260616145127.595014364@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 9c7da87c2dc860bb17ca1ece942495d28b1ce3b9 ]

Found while auditing the same pattern Sashiko reported in
rt6_fill_node() [1]. Apply the same fix as
commit f8d8ce1b515a ("ipv6: fix possible infinite loop in fib6_info_uses_dev()").

Writers holding tb6_lock can list_del_rcu(&first->fib6_siblings)
without waiting for RCU readers; first->fib6_siblings.next then
still points into the old ring and this softirq-side walker never
reaches &first->fib6_siblings as its terminator. fib6_purge_rt()
always WRITE_ONCE()s first->fib6_nsiblings to 0 before
list_del_rcu(), so an inside-loop check is a reliable detach signal.

[1] https://sashiko.dev/#/patchset/20260526020227.4857-1-jiayuan.chen%40linux.dev

Fixes: d9ccb18f83ea ("ipv6: Fix soft lockups in fib6_select_path under high next hop churn")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260527053133.180695-2-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0e96f7cb21a297..2b861eacee30e4 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -486,6 +486,9 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 		const struct fib6_nh *nh = sibling->fib6_nh;
 		int nh_upper_bound;
 
+		if (!READ_ONCE(first->fib6_nsiblings))
+			break;
+
 		nh_upper_bound = atomic_read(&nh->fib_nh_upper_bound);
 		if (hash > nh_upper_bound)
 			continue;
-- 
2.53.0



