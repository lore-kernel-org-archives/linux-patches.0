Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7392330DD2F;
	Sat, 12 Sep 2026 14:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223608; cv=none; b=ALVvgiHG8PBcYBt9oBwwH1zE4BgIi+vqlAppmbjpuC0AcpRXYL69l/aUpM4qf9/5bkxc9y4L3e/Fzr7LyddR1XasVO0MwxUbeFqWOlVCHjo1oNKuVRszyUHXs/CmysifjQPLweEtL3YD9cVWItkPLn7dAPk8SwPi9FV5xYztwnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223608; c=relaxed/simple;
	bh=RYDvdYUz2vc4GZKX8bEVDYgfRMg6HCeMahi3jrEWHII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtpI83uvV/3EmWwV0+4Dbf7Fkl+UZfavVhKTgOIDhtCbfhDSTqeW7F+wnctcG76NwVb0QOaDhbOOUL+Hngzb3RtYVRoFTn/a5yszleJs17CG2OjaYNBF2JmXVNfmxuv1sh0qXfHfG4W/04QBpDnnVmEEUsdfgwXyhyi0qPLuLak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMjK0XVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMjK0XVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCBE1F000FF;
	Sat, 12 Sep 2026 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223607;
	bh=urJPR7pUFu4fSirq72aUb8ezKPKNXOSFyGFxjhaySws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMjK0XVKv5V9krdIiyTnpNiqG8drJm/KIF+wbNWFqHGBwSYH3TptUXVD7y6qctyCG
	 7zfIcPEIVSaqgr4jAKCwduzfHOfm9OtRqwnPkorTuQc9GEGeZqM90huXnxTvOdpdmz
	 mKmXx5LuDsIx0dbmnkqd8VOyJGebqYxqudKH8wvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0825/1424] RDMA/nldev: validate dynamic counter attribute length
Date: Sat, 12 Sep 2026 08:54:17 +0200
Message-ID: <20260912065625.780944154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index a94723a12bb48..5aff8e284db2e 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1990,6 +1990,11 @@ static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
 
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



