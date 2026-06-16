Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA72F32C302;
	Tue, 16 Jun 2026 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628360; cv=none; b=Gg+ZVvQ8YyBDa5W6tNqZlIrYwrAAoKbQ2392T7BYx+mc61UV7C/bEQvK65GVJW8He5lA3wpuYL4qzdu2rTUrD4yxTc3tXgwjHaiEt0iRgED6n5L+8DcLQeqfSrv6YEUFw4T+4LWVtAO/CeDkRBradT4+scuZ8f1LGH8wMf5cvc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628360; c=relaxed/simple;
	bh=cKYf2ocrecxspyjH9wMfbVxv0q/YZtxPDzJtC6MA3Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsK/Se9V6z/7xdCmPZpk7mRpGMxqhgSn6epW5jJk7XoTbBX8bRSLFoxpdcDKzcv7Ik82PtOuMgy6g7KlpqsIdSryOGp7g8Gew3SD1bXz+gf346zfsgX08+I78OEchoUxjeYS7nOqeGY+YsiXDvdqH8kV4rbe4Z2gNAgVhBmu1DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qv43xW4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qv43xW4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8041F000E9;
	Tue, 16 Jun 2026 16:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628359;
	bh=UcgdNLlX6u6rJwKIUdTILMxPFBE0+iDk+DcFcFIHSuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qv43xW4KuSdVx0HrY372bQHHZW+8LLODZIbHxfbxlc6WOhQWCLJvpA8QOWKSdIYu/
	 4+btP/Py4u+GtT4I9hjWFJhIJZnnbaVxADR449rq3X6e+QrXGXPox4kUib0wwiaAec
	 Uhsm0zI3jL79swc7dE5ow8aWfwh5OGI5DIDeshYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/452] ipv6: fix possible infinite loop in fib6_select_path()
Date: Tue, 16 Jun 2026 20:24:34 +0530
Message-ID: <20260616145120.404984557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
index 69659f2a6aea96..6d80e17c04c0d8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -484,6 +484,9 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
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



