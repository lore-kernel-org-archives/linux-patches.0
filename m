Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746D162743;
	Tue, 23 Jan 2024 00:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970184; cv=none; b=KoZlK+3tOVrVJ/P9jDp7qfrFH/rdqtPBPbLUlDJTB23DSz3rT0CKuM/0NC6m1Ebs76NiBA5ImKIHNojSrYGfL3wJsD+5jDyRX8UJ0uP0QP88qFC0jwYt1EfCUkvusxu8LrFrm4WRWgqb95lsANouUF4ORHNIrssGnxr4VG26gOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970184; c=relaxed/simple;
	bh=7DMIWcSy09a0c2BEWOftQmdQVElpUMXTzKtewTGKC6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRpaEFKQyecwaqPb0H0OZOZ/hJilUK75QetynzMAzQr3zlqKM/SEF/aeyEOJisRe1YhR90yflZRnw5vDvmOR6hBJElnv58k+rpmbFENLtw9Y+1WTWNdNmGYPqStv9z3hos3LHqOWo6M3V+zPQzXDOAyATGQmn1Oi/4WP41oN9tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/H9EMEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/H9EMEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4CAC43390;
	Tue, 23 Jan 2024 00:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970184;
	bh=7DMIWcSy09a0c2BEWOftQmdQVElpUMXTzKtewTGKC6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/H9EMEG1t/fxAXYXt+JXrBdznjkyCXb5Xm528lZ1vPG8Vn6Ht6p7r+PH3xm7d2wf
	 TcO6s3jK6GMjV0M9z0t1KvIxnP9duls8PGKP9BuVQwuBNPNUTiVNgPcSjQZy7fwaKK
	 icv9sNzfcCztxif/i7FlPadpyBla6NamsmRUxvOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 586/641] amt: do not use overwrapped cb area
Date: Mon, 22 Jan 2024 15:58:10 -0800
Message-ID: <20240122235836.541094825@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit bec161add35b478a7746bf58bcdea6faa19129ef ]

amt driver uses skb->cb for storing tunnel information.
This job is worked before TC layer and then amt driver load tunnel info
from skb->cb after TC layer.
So, its cb area should not be overwrapped with CB area used by TC.
In order to not use cb area used by TC, it skips the biggest cb
structure used by TC, which was qdisc_skb_cb.
But it's not anymore.
Currently, biggest structure of TC's CB is tc_skb_cb.
So, it should skip size of tc_skb_cb instead of qdisc_skb_cb.

Fixes: ec624fe740b4 ("net/sched: Extend qdisc control block with tc control block")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20240107144241.4169520-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 53415e83821c..68e79b1272f6 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -11,7 +11,7 @@
 #include <linux/net.h>
 #include <linux/igmp.h>
 #include <linux/workqueue.h>
-#include <net/sch_generic.h>
+#include <net/pkt_sched.h>
 #include <net/net_namespace.h>
 #include <net/ip.h>
 #include <net/udp.h>
@@ -80,11 +80,11 @@ static struct mld2_grec mldv2_zero_grec;
 
 static struct amt_skb_cb *amt_skb_cb(struct sk_buff *skb)
 {
-	BUILD_BUG_ON(sizeof(struct amt_skb_cb) + sizeof(struct qdisc_skb_cb) >
+	BUILD_BUG_ON(sizeof(struct amt_skb_cb) + sizeof(struct tc_skb_cb) >
 		     sizeof_field(struct sk_buff, cb));
 
 	return (struct amt_skb_cb *)((void *)skb->cb +
-		sizeof(struct qdisc_skb_cb));
+		sizeof(struct tc_skb_cb));
 }
 
 static void __amt_source_gc_work(void)
-- 
2.43.0



