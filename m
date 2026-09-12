Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D903BE643;
	Sat, 12 Sep 2026 12:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215834; cv=none; b=TfvPvxoNEWl5Q1AMA84unqx5YeP6Pb+qPLWRn53EFTMUds3mgJfWd66q35vhyxsowiGOwHeIn3YugBNBojNYLBNtsEfl33HJuOQqRCQo2Ky3dTusbPl5Y0IJ/nNS+qeWP5neXC79BpJhygvEvNvrdFCc5CaXHw62XZTNsUmStLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215834; c=relaxed/simple;
	bh=+s5bfV7sxBy3deByJj/vReisirENUeFx38P4hFGHmcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCa6InZVtVIsbpNxzl5K78Ath6kSvT7v4aX3pMvg96WvlMDDBNkfbc1YvNKL1GLsN5JUGNWWyInA1o69YAnR1dvzy1DwgCvvp/X7s8aKFOVcSKGUIl9DfZwwBwGKCvXBp9hjtZHQVcOufcXDeh8WoHzCNmuiD9JwbOMnCJ2A9lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAjsW4pv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAjsW4pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4AE1F000FF;
	Sat, 12 Sep 2026 12:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215833;
	bh=oy1RZZdy98FWXzEvw3XmI/EwDx8hYSu01lj3eHBL/VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAjsW4pvbofaTLp2HrunRHC71+HGd+pIL6bvyvDAAnim4tWGSiatVt35EdVIIN/yC
	 bIuX+xoMdc8Wc9ybA38U6M2PDl9Piep52gf103CGgCJIu7R5FFMSQvFnAWUkPHy2ww
	 +EGvam3k0qdXdVCOTQv4xqcUnwASDKIPevDAWH8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0614/1376] RDMA/nldev: validate dynamic counter attribute length
Date: Sat, 12 Sep 2026 08:50:40 +0200
Message-ID: <20260912065621.226499935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fef11a80647c4..aa24cc9f066e9 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2093,6 +2093,11 @@ static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
 
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



