Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC15228030E;
	Sat, 12 Sep 2026 10:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207820; cv=none; b=HH84InBMFGs9751KUnSdFWTmIvOLNGQfRxsVixA1mftrG5VTGIYY/eVz9+OtyuKIa8dOitH0MC+2cybNWuoDMPg6f87xag7eNMYMTRd/4G+rFVhacKLd22Kzc4cqAm7EGN6d1VGWA8WQff5XjCQlVlsnykGSEjZOerKN9GxxYyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207820; c=relaxed/simple;
	bh=Ce8e5Kj85j3gBa82zs6bLttDyqju7+hqMojHxZbNBoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ5Mne1mR2KLk+Mbu/+MuVdWmHmhuO+qScBD69+30iUO877V3YhLIXypOkhrR6BAnaQ7P4rhxlR/u7BX+Vjt43bdh3odhBmajby6ZjYczB6cmOMGjv4a4eN33sIihzeTGvS4kASp2AalQeqzqJmWhV/hp4x2UI8481LFXrb5GLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6F/k7aj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6F/k7aj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6FC1F000FF;
	Sat, 12 Sep 2026 10:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207819;
	bh=+AMqP53d8G+Zj1q5/4uulxJTOZqQW/R2PpbR4z5zrMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6F/k7ajfwPEoX7iRTId8VAOhLQP77cFT7A9aPetHpfHVnanoMRfO2uH8Gy2wXkC1
	 A/jcsyVsh5bPz53pHyiwUqe7xxw/mOb3hoXPOMvN8kJ/B1hg+ruXXLRt/Il421dq30
	 wFbYHcOdZy+81+4VvsSWTXeBou05cDYMKXVexrIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0490/1518] RDMA/nldev: validate dynamic counter attribute length
Date: Sat, 12 Sep 2026 08:44:19 +0200
Message-ID: <20260912065634.532596612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 74f49255492a62658f36bf2578d7916f1c6ffad1 ]

RDMA_NLDEV_ATTR_STAT_HWCOUNTERS is a nested attribute whose children are
consumed directly with nla_get_u32(). The top-level policy validates only
the container, so it does not establish the fixed shape of each child.

Require every child payload to be exactly one u32 before reading it.

Fixes: 3c3c1f141639 ("RDMA/nldev: Allow optional-counter status configuration through RDMA netlink")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260720114918.70323-1-pengpeng@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 2220a2dfab240..79fa29883349f 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2100,6 +2100,11 @@ static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
 
 	nla_for_each_nested(entry_attr, tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS],
 			    rem) {
+		if (nla_len(entry_attr) != sizeof(u32)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		index = nla_get_u32(entry_attr);
 		if ((index >= stats->num_counters) ||
 		    !(stats->descs[index].flags & IB_STAT_FLAG_OPTIONAL)) {
-- 
2.53.0



