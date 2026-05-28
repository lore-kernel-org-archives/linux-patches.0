Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6352F260C;
	Thu, 28 May 2026 20:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998741; cv=none; b=sJp7zorhYNbTepv0w52RFPYBWK6LzISdWQDA+ChOn5q3mYjoHB2kjl2IczJXXQBY4ko1Feov1Q7a94gO14f8MoLVZSpBu4P0FQtDJf6NDyVnCB9PG2Ehh8PNfCN+6tr3j52HsLcOYzv3PiOUJWkA3AmWBqqh/8zzsIF7KXoG1Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998741; c=relaxed/simple;
	bh=zs9JAfI3qSpwzmbxrdiKLm8QNVpFqkR0hJAn6MiZn9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THbSgmcSSFHY3VwRVU5MUvvTs4dqr5dCE13KDWV6FKE2CdPjCX9uMIdNDD1VYi+S7OUEQ3REmoVIsvfyFCzHb9gv1NST54XIVtsThOj8OYezuy8r83CW60pJ8MTiuP7+6kKqU9A3lEam/O0ngBBI/7pqJW1rgnrgO6lsPCfqoms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mI46LbHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mI46LbHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458AC1F000E9;
	Thu, 28 May 2026 20:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998740;
	bh=Ayg04myHthuf//ZwOpahh5jNVXej7Kc2MVr6PYjH1oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mI46LbHTkKH2tlz4ncn8al4GU6f7Gj9nPiTdglBQeq+CbA//tpfXuKRWw+GVA22ZM
	 RVOXVtKBQII6jVfOOVa0E70VHsBctXrY+pVF/2NMPLkaaqB94itsPimGa+IhFRgRCa
	 9d5G+TxpYQQRcYqVzBzAk/CRK17mwLB7JOOTTUKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 282/461] net: shaper: set ret to -ENOMEM when genlmsg_new() fails in group_doit
Date: Thu, 28 May 2026 21:46:51 +0200
Message-ID: <20260528194655.354945303@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8054f85b83f42a37d482fc77ea7c9ff06a9407d9 ]

genlmsg_new() alloc failure path in net_shaper_nl_group_doit() forgets
to set ret before jumping to error handling.

Fixes: 5d5d4700e75d ("net-shapers: implement NL group operation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-6-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index c8960821cf236..12e5e0c18643b 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -1276,8 +1276,10 @@ int net_shaper_nl_group_doit(struct sk_buff *skb, struct genl_info *info)
 	 * rollback on allocation failure.
 	 */
 	msg = genlmsg_new(net_shaper_handle_size(), GFP_KERNEL);
-	if (!msg)
+	if (!msg) {
+		ret = -ENOMEM;
 		goto free_leaves;
+	}
 
 	hierarchy = net_shaper_hierarchy_setup(binding);
 	if (!hierarchy) {
-- 
2.53.0



