Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F7F317145;
	Sat, 12 Sep 2026 16:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229847; cv=none; b=iwZEPItWGp44TVFsXRxRQeuB6g77bUSGsJPPgxqVFKOLKwgvDc7UiAwnCaid1mW/uiIM2ZDKaWO/VJK9RMNG+9Js43XzU/BWPHKJ6F2Z4it77eCKwwRY9VjMhvVAOWn1vOaZ4eb6p7lE7dMyom9F/iEfTBctB8ZDGKNqkX2s39g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229847; c=relaxed/simple;
	bh=xptn+z2XwraFOb6+/Hu1Ryn4ynVwt5Y8Yh1uV0JaFsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zfth0WZVWcHG0T6B5kVXPFJpkWRI+nt/UDhKSGlt36uTfMyYovX8DO+K2x0iOVtg9Xcw+rxFFiGdz5e7obybv9n17zOmhm4rHI4eZI2V+EInrIw98Z96Akbm6fx3sFSUC6BV7EmcOU5n4bEdtxJWZoXpOdX/99v+2UZi2tq23P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ce5Pi/5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ce5Pi/5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EBF1F000FF;
	Sat, 12 Sep 2026 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229845;
	bh=BKXdgGHLGWkYaP+foXiBimv+PtvjHLJ73MMoVn0G7BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ce5Pi/5w/tRLUD3jVhXt/v8shFc36yi3ystGn4k4q2/iOnMQYGE94baHyD368OOBF
	 jJuGgIdtyaWOM0vPOaMvMez79aP/9MiKsjffP5uDoFbWOYLnibJgQbMaD8/zhp1wCQ
	 w6i3rE5r+4Vy10IkNn8Hkb5MNeapKhl3hnhqnREw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0673/1191] RDMA/nldev: validate dynamic counter attribute length
Date: Sat, 12 Sep 2026 08:56:41 +0200
Message-ID: <20260912065603.373669320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 7e08ce963125c..353ba8f68dedf 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1970,6 +1970,11 @@ static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
 
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



