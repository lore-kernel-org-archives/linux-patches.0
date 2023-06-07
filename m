Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC9C3922B
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C1CC433EF;
	Wed,  7 Jun 2023 20:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171182;
	bh=EbDUCfIcI8ayaWKuqj29n1zWg94CDS9D/gfbhyIkAGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uhr5h6xO/iFRCuU4DAiGtPmj9xMfE2pcViNgMurVGV7BpH3Furd2oTOJ6PATm5pHm
	 qxCjU7fPtvNYVmHabc5Zjbvg9/qbwVrPRvGnNL3OIopsc6//fShnOcZ4HlTx8QQ1+z
	 Y1Kb6ipjUzOSFMXqhcHgHFOAz6oARzmOvsXzc7OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sudarsana Reddy Kalluru <skalluru@marvell.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/99] ocfs2/dlm: move BITS_TO_BYTES() to bitops.h for wider use
Date: Wed,  7 Jun 2023 22:16:13 +0200
Message-ID: <20230607200900.919850912@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
References: <20230607200900.195572674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit dd3e7cba16274831f5a69f071ed3cf13ffb352ea ]

There are users already and will be more of BITS_TO_BYTES() macro.  Move
it to bitops.h for wider use.

In the case of ocfs2 the replacement is identical.

As for bnx2x, there are two places where floor version is used.  In the
first case to calculate the amount of structures that can fit one memory
page.  In this case obviously the ceiling variant is correct and
original code might have a potential bug, if amount of bits % 8 is not
0.  In the second case the macro is used to calculate bytes transmitted
in one microsecond.  This will work for all speeds which is multiply of
1Gbps without any change, for the rest new code will give ceiling value,
for instance 100Mbps will give 13 bytes, while old code gives 12 bytes
and the arithmetically correct one is 12.5 bytes.  Further the value is
used to setup timer threshold which in any case has its own margins due
to certain resolution.  I don't see here an issue with slightly shifting
thresholds for low speed connections, the card is supposed to utilize
highest available rate, which is usually 10Gbps.

Link: http://lkml.kernel.org/r/20200108121316.22411-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: f4e4534850a9 ("net/netlink: fix NETLINK_LIST_MEMBERSHIPS length report")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h | 1 -
 fs/ocfs2/dlm/dlmcommon.h                         | 4 ----
 include/linux/bitops.h                           | 1 +
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
index 066765fbef069..0a59a09ef82f4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
@@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(struct bnx2x *bp, enum cos_mode mode,
  *    possible, the driver should only write the valid vnics into the internal
  *    ram according to the appropriate port mode.
  */
-#define BITS_TO_BYTES(x) ((x)/8)
 
 /* CMNG constants, as derived from system spec calculations */
 
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index aaf24548b02a1..0463dce65bb22 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -688,10 +688,6 @@ struct dlm_begin_reco
 	__be32 pad2;
 };
 
-
-#define BITS_PER_BYTE 8
-#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
-
 struct dlm_query_join_request
 {
 	u8 node_idx;
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 4f0e62cbf2ffe..e9e74af163fab 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -13,6 +13,7 @@
 
 #define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
+#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(char))
 
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
-- 
2.39.2



