Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CF4276057;
	Tue, 27 May 2025 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365626; cv=none; b=U/RyxEpioH56BQg3DSJPBAvXAjVg82tur7z1oIX/dpwp8dHth9oeeW6x9CqmVdaWlnC0ySkzyzBksWjO17AuByK+mcohikd97hW5tF/wP0N/bapmAecE24yzBzaOKVESnd68SypsdG++ux/v5PVKZV3nj6jQcqthmEVzVxNpPEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365626; c=relaxed/simple;
	bh=WwfkvbwBUmAxpgiaU9Z9McdPkVOENtUBoqWcPxvsfFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtxO4EXKYvFKcaxjIJ85ybkDSGsIJ4e+EKLz8CFxGkB9+xdm5GbwVJCQV2JJyaHvX98DpHZN9m1QTwZicrveRnNTqvTZmqEOOx47gPWaCeDvIg8m4JnK26BQ9a13aYNugT1XUqw10kRLEn5o/ARkmeuYBDEC+peS99z28Vw7XGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/AfTg87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/AfTg87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD21C4CEE9;
	Tue, 27 May 2025 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365626;
	bh=WwfkvbwBUmAxpgiaU9Z9McdPkVOENtUBoqWcPxvsfFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/AfTg87VJgqYb72RDsMO1dQmz+NWSa7mWR+ineHnEn08NgXpQLo8oN4xzkGoqQUo
	 JgJgnomf62oBmA/+M7O8AdV1tI3zveHX7MMbECBtzDsH2X82BumzYFGBSNTSVhjSea
	 vU6fv+icg42FEy/elzoN/mdqgdrDN3U8PTnKnXoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/626] net: page_pool: avoid false positive warning if NAPI was never added
Date: Tue, 27 May 2025 18:25:30 +0200
Message-ID: <20250527162502.761212565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c1e00bc4be06cacee6307cedb9b55bbaddb5044d ]

We expect NAPI to be in disabled state when page pool is torn down.
But it is also legal if the NAPI is completely uninitialized.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250206225638.1387810-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.h       | 12 ++++++++++++
 net/core/page_pool.c |  7 ++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.h b/net/core/dev.h
index 2e3bb7669984a..764e0097ccf22 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -148,6 +148,18 @@ void xdp_do_check_flushed(struct napi_struct *napi);
 static inline void xdp_do_check_flushed(struct napi_struct *napi) { }
 #endif
 
+/* Best effort check that NAPI is not idle (can't be scheduled to run) */
+static inline void napi_assert_will_not_race(const struct napi_struct *napi)
+{
+	/* uninitialized instance, can't race */
+	if (!napi->poll_list.next)
+		return;
+
+	/* SCHED bit is set on disabled instances */
+	WARN_ON(!test_bit(NAPI_STATE_SCHED, &napi->state));
+	WARN_ON(READ_ONCE(napi->list_owner) != -1);
+}
+
 void kick_defer_list_purge(struct softnet_data *sd, unsigned int cpu);
 
 #define XMIT_RECURSION_LIMIT	8
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 7b20f6fcb82c0..c8ce069605c42 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -25,6 +25,7 @@
 
 #include <trace/events/page_pool.h>
 
+#include "dev.h"
 #include "mp_dmabuf_devmem.h"
 #include "netmem_priv.h"
 #include "page_pool_priv.h"
@@ -1108,11 +1109,7 @@ void page_pool_disable_direct_recycling(struct page_pool *pool)
 	if (!pool->p.napi)
 		return;
 
-	/* To avoid races with recycling and additional barriers make sure
-	 * pool and NAPI are unlinked when NAPI is disabled.
-	 */
-	WARN_ON(!test_bit(NAPI_STATE_SCHED, &pool->p.napi->state));
-	WARN_ON(READ_ONCE(pool->p.napi->list_owner) != -1);
+	napi_assert_will_not_race(pool->p.napi);
 
 	WRITE_ONCE(pool->p.napi, NULL);
 }
-- 
2.39.5



