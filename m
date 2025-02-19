Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C991E04BE;
	Wed, 19 Feb 2025 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954525; cv=none; b=lW3Qfr37vv5v0/Ixxh5ModS5CzbI9FIF8qVJF8FSlSGaH6cCp1nAUV+t6tFPqMkyT0uuDWtvhR/X7+H0RU98NsDSag8HXvdHfY2EBNpSGiFXqFpl8VHLkX7pTKWNCMxs3sPSkOO7D4oCoWxFIzCUEg1H7bx4O2AM9lc4rHcoap8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954525; c=relaxed/simple;
	bh=eFFctijlc8J5k1Wp3vcQqP1Glx7P+4oMk+kN7nochnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzNMvLqWS1l8lB76C4sWHaFqxqy9AJqX1eAFTeAuBqF4X8LLroIeXX8wYObVyKRj3/j3VPJMNK7HINaN6rNiGj+hkpatdQ5Gk+5HpBh/8jMsgHnqJTvOrZfAhj7XuT73jE4F1mjnyiobRTGafig+gqsfTjKkm6QkbUEb7jQydBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bnlsetow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bnlsetow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A16BC4CEE7;
	Wed, 19 Feb 2025 08:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954524;
	bh=eFFctijlc8J5k1Wp3vcQqP1Glx7P+4oMk+kN7nochnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bnlsetow7UsiB96msuKsKjEwm2CnyrEL7u59IY+qDDO646pcHbROhYZI+6SFWBhoQ
	 dG662kkVR40sEuo7oXVMXLusgeVO6Gdn+6kp+tO4/qpXdd28neMx8I+I/1++NWU921
	 RoFg2OGYDclzLt9JLLTkKFMquU2oIHrNL1AoNY74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 229/274] net: make sure we retain NAPI ordering on netdev->napi_list
Date: Wed, 19 Feb 2025 09:28:03 +0100
Message-ID: <20250219082618.540052059@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d6c7b03497eef8b66bf0b5572881359913e39787 ]

Netlink code depends on NAPI instances being sorted by ID on
the netdev list for dump continuation. We need to be able to
find the position on the list where we left off if dump does
not fit in a single skb, and in the meantime NAPI instances
can come and go.

This was trivially true when we were assigning a new ID to every
new NAPI instance. Since we added the NAPI config API, we try
to retain the ID previously used for the same queue, but still
add the new NAPI instance at the start of the list.

This is fine if we reset the entire netdev and all NAPIs get
removed and added back. If driver replaces a NAPI instance
during an operation like DEVMEM queue reset, or recreates
a subset of NAPI instances in other ways we may end up with
broken ordering, and therefore Netlink dumps with either
missing or duplicated entries.

At this stage the problem is theoretical. Only two drivers
support queue API, bnxt and gve. gve recreates NAPIs during
queue reset, but it doesn't support NAPI config.
bnxt supports NAPI config but doesn't recreate instances
during reset.

We need to save the ID in the config as soon as it is assigned
because otherwise the new NAPI will not know what ID it will
get at enable time, at the time it is being added.

Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fbb796375aa0e..09a9adfa7da99 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6735,13 +6735,14 @@ static void napi_restore_config(struct napi_struct *n)
 	n->gro_flush_timeout = n->config->gro_flush_timeout;
 	n->irq_suspend_timeout = n->config->irq_suspend_timeout;
 	/* a NAPI ID might be stored in the config, if so use it. if not, use
-	 * napi_hash_add to generate one for us. It will be saved to the config
-	 * in napi_disable.
+	 * napi_hash_add to generate one for us.
 	 */
-	if (n->config->napi_id)
+	if (n->config->napi_id) {
 		napi_hash_add_with_id(n, n->config->napi_id);
-	else
+	} else {
 		napi_hash_add(n);
+		n->config->napi_id = n->napi_id;
+	}
 }
 
 static void napi_save_config(struct napi_struct *n)
@@ -6749,10 +6750,39 @@ static void napi_save_config(struct napi_struct *n)
 	n->config->defer_hard_irqs = n->defer_hard_irqs;
 	n->config->gro_flush_timeout = n->gro_flush_timeout;
 	n->config->irq_suspend_timeout = n->irq_suspend_timeout;
-	n->config->napi_id = n->napi_id;
 	napi_hash_del(n);
 }
 
+/* Netlink wants the NAPI list to be sorted by ID, if adding a NAPI which will
+ * inherit an existing ID try to insert it at the right position.
+ */
+static void
+netif_napi_dev_list_add(struct net_device *dev, struct napi_struct *napi)
+{
+	unsigned int new_id, pos_id;
+	struct list_head *higher;
+	struct napi_struct *pos;
+
+	new_id = UINT_MAX;
+	if (napi->config && napi->config->napi_id)
+		new_id = napi->config->napi_id;
+
+	higher = &dev->napi_list;
+	list_for_each_entry(pos, &dev->napi_list, dev_list) {
+		if (pos->napi_id >= MIN_NAPI_ID)
+			pos_id = pos->napi_id;
+		else if (pos->config)
+			pos_id = pos->config->napi_id;
+		else
+			pos_id = UINT_MAX;
+
+		if (pos_id <= new_id)
+			break;
+		higher = &pos->dev_list;
+	}
+	list_add_rcu(&napi->dev_list, higher); /* adds after higher */
+}
+
 void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 			   int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -6779,7 +6809,7 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 	napi->list_owner = -1;
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
-	list_add_rcu(&napi->dev_list, &dev->napi_list);
+	netif_napi_dev_list_add(dev, napi);
 
 	/* default settings from sysfs are applied to all NAPIs. any per-NAPI
 	 * configuration will be loaded in napi_enable
-- 
2.39.5



