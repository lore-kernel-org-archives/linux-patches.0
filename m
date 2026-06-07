Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7081E98E3;
	Sun,  7 Jun 2026 10:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826953; cv=none; b=sFID5XAjoXpenEoYRK6Wxy4AmwKPSosQP5WjKRCIuF+KmOAyWVyvAn1EyMfL0TAbkcTzUQC7Aw8hxDsuWcHUgEeyCSpQBanNexOVDwddPZPc3qRL+WFm/wmp0hJClJesJbRaSPo0eomvQ3EXO3ZXuIWYekLHP3522q0HMQ1G6P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826953; c=relaxed/simple;
	bh=yyCOTOjEQEmcKrtRBs5LOetrG43RhGwkAnu/vUNtlZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnGEOpP1Srj+Oo67SlBTsWra+k8bBqeqjZSGNuJLKiTXUHpH7ZwwEmQ74QIoCND4QxM2SKg8sZ5sqD4C24gIqMD0/1e9Yz0Px56gZYL4s2nRpATkQ7HfeuArrxZ0vVxquBfs/AuKn6DDiWwHggFrVijNPPZxQjilLYnSh2z6P4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYqoH2Rz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYqoH2Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFA31F00893;
	Sun,  7 Jun 2026 10:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826952;
	bh=r0RbwX4QP9QQkMfIlkaF3B19w7PUJkndIAzOWpwIhb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYqoH2Rzw7tHvfko2ZE3wOdDMkjlHwxYhlvN7SEOYFPa5EvVFxZaPVKfo9hx7lGz9
	 7C5aSxIm2pLqXlhvoZoWbcMLanmRbSno9XgaVeI9Y72MuFIsKDQQmZEL7C7lXYXrLL
	 XMDMpzdFsdzh1xXGO5uiguEyUI0vxWi1psyf/YDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 046/332] ethtool: rss: avoid device context leak on reply-build failure
Date: Sun,  7 Jun 2026 11:56:55 +0200
Message-ID: <20260607095729.809666421@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

[ Upstream commit 32a9ecde62731c9f7412507709192c84dafc38d1 ]

We wait with filling the reply for new RSS context creation
until after the driver ->create_rxfh_context call. The driver
needs to fill some of the defaults in the context. The failure
of rss_fill_reply() is somewhat theoretical, but doesn't take
much effort to handle it properly. Call ->remove_rxfh_context().

If the driver's remove callback fails (some implementations like sfc
can return real command errors from firmware RPCs) - skip the xa_erase
and kfree, leaving the context in the xarray. This matches how
ethnl_rss_delete_doit() behaves.

Fixes: a166ab7816c5 ("ethtool: rss: support creating contexts via Netlink")
Link: https://patch.msgid.link/20260522230647.1705600-7-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index f745ddec6fbab8..b122f67dbde1d6 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -1096,7 +1096,7 @@ int ethnl_rss_create_doit(struct sk_buff *skb, struct genl_info *info)
 	ntf_fail |= rss_fill_reply(rsp, &req.base, &data.base);
 	if (WARN_ON(!hdr || ntf_fail)) {
 		ret = -EMSGSIZE;
-		goto exit_unlock;
+		goto err_remove_ctx;
 	}
 
 	genlmsg_end(rsp, hdr);
@@ -1124,6 +1124,10 @@ int ethnl_rss_create_doit(struct sk_buff *skb, struct genl_info *info)
 	nlmsg_free(rsp);
 	return ret;
 
+err_remove_ctx:
+	if (ops->remove_rxfh_context(dev, ctx, req.rss_context, NULL))
+		/* leave the context on failure, like ethnl_rss_delete_doit() */
+		goto exit_unlock;
 err_ctx_id_free:
 	xa_erase(&dev->ethtool->rss_ctx, req.rss_context);
 err_unlock_free_ctx:
-- 
2.53.0



