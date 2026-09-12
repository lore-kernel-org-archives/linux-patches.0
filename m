Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3A229B799;
	Sat, 12 Sep 2026 07:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199288; cv=none; b=HHEASN90PfaepJJcwD2aWl65NZEX1tGJxhkU1C3wjX75sVmAZEWzRHJHwNpLODYp0NUSbLzcATIvYgCtOybwebVgWMQ/OifnEPHlleRnSHr8rhASkTRfb0fv/5pB2d4869UUNyofz3c9BEoIVrcVzlmjD4hu/ezTVBIQYfGTaok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199288; c=relaxed/simple;
	bh=zVZFQq9PPmfzV1i3Hs/hmN8NwCx2x87YZmkOOH2qGuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bi37KhzuvBDizrGwlJNJtalP3jB4lQ94DhS3yepzcULacyCHS69okOPOjnno2rjtKLzSNH8IJo61MTkF7VDlkkIpd1D2hVlEZfwxKywDKRYOwhi/3YuWUzwUKIzZB5sX+TDwrPnos5oy0pQF1PYIzFle4wt8+o7WSxYUiT1Meqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flRYpHZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flRYpHZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8856A1F000FF;
	Sat, 12 Sep 2026 07:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199287;
	bh=0+JPYji+dYEZRVUf/nzjXTT9PsRcJAo68CilFW0rOBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flRYpHZBubtwKGtZXz1esOQfLy0OWIWU4FLC/RHqGaNWlzhuMR7tDob9TLpvvrbB/
	 0J0ioFilumexfOdN6NkH/RUPyx+1EhiKNb98koJvrpLdR3rgtgcSPSF7kiogpP5N7L
	 2YAU2XVo0xjc9NyMjU4/Z2aYvUcarcYfLJSQhdMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0555/1815] RDMA/nldev: validate dynamic counter attribute length
Date: Sat, 12 Sep 2026 08:38:25 +0200
Message-ID: <20260912065701.912749162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 02a0a9c0a4a6a..f0f09670956d6 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2133,6 +2133,11 @@ static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
 
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



