Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6DF43B3CA;
	Mon, 17 Aug 2026 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976246; cv=none; b=DrC5w9hWaxD0+Y0pnJl7th5rEIDhfOA+7+13tEeWqYQJAW879o2An0ZROyAQraMBYQscxXvndRwjbR/ad5zTOGq7rcKYnqMfVXpGkMgAYVswnR/3LUYMMbHZelKSbnfQkU9kRy6xdk9bzMaPWU8ae4JQdw4mcmeMmZm9mCxOREc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976246; c=relaxed/simple;
	bh=PCHPXYYUxFh00wmuh0+8o5CF+H8jm9ZSW6GkitzQZzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAT+UxZSzp/Ff/QZGA8ODKDRjMzbUqrbnxkb3xTQb4WXHhYsbwEuJLj/9ZeyBY2pG8BWnIfWWtmFiTCjqAIyGk2OXjGxo/FVt26rk7RRl37ByQa2ADS6iP6hAW1YZYJVjcjtF3/7xAu9CXDUL+IcN+WRc4ChYZKJ14lkWqOVqSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ER2C0odb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ER2C0odb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDDE1F000E9;
	Mon, 17 Aug 2026 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976244;
	bh=pTo8J4qpFHiuq5XekwGXNCU0Qd/XiTpEReDKAfGvb4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ER2C0odbHYBD1/f+NBSR0Y3X2O6kzcXUfxepbGH2P3Ikhjc24ufqS++/RwJJM1Nzc
	 9/gJlIB86DUHxGIhbwh4cpmUvec8n9NnYjVgZrHMg6ndE/X8kvIKTV1na4my8OmMh1
	 X0F1JXkUxGlh42sFxeZxeHPEaa4verjW2Yu8/f5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/389] net: openvswitch: fix skb leak on flow key update failure during recirculation
Date: Mon, 17 Aug 2026 15:32:25 +0200
Message-ID: <20260817132550.965869841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit e1cf066244dad576221b7123a0e5005967f25a20 ]

do_execute_actions() returns right away when execute_recirc() fails on
the last action as it assumes this function always takes ownership of
the skb when 'last' is true.  But when the flow key update fails, the
function doesn't free the skb and it ends up leaked.

This is a very unlikely scenario as it requires the packet to become
unparseable by applying a set of actions on a previously parseable skb,
but should be fixed nevertheless.

Reported by Sashiko.

Fixes: 971427f353f3 ("openvswitch: Add recirc and hash action.")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260727181851.306076-2-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[OVS drop reasons are not available in 5.10, hence plain kfree_skb()]
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index ffd56da14c745..99fff9d6596c8 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1100,6 +1100,10 @@ static int execute_masked_set_action(struct sk_buff *skb,
 	return err;
 }
 
+/* When 'last' is true, recirc() should always consume the 'skb'.
+ * Otherwise, recirc() should keep 'skb' intact regardless what
+ * actions are executed on recirculation.
+ */
 static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 			  struct sw_flow_key *key,
 			  const struct nlattr *a, bool last)
@@ -1110,8 +1114,11 @@ static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 		int err;
 
 		err = ovs_flow_key_update(skb, key);
-		if (err)
+		if (err) {
+			if (last)
+				kfree_skb(skb);
 			return err;
+		}
 	}
 	BUG_ON(!is_flow_key_valid(key));
 
-- 
2.53.0



