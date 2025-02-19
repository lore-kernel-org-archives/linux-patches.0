Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B035A1DE2C2;
	Wed, 19 Feb 2025 08:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954533; cv=none; b=f2gs719Vv8tohQ2ePZUG8qjUsNOPGxpoF/pwcpIbKAXoLn5h6lb5bWv5zAp6Uajrjb2jzMEscfKzb/tIf6ZOwzjQ5W5TW2AGb6s5c5sHbmu6usyL53iQMZMFWbC04j8M2Wiv/OSdRChx2nzLBEuzD6nTErIlKNQjqVGCh1mCLYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954533; c=relaxed/simple;
	bh=yZ1WSfuhjVYcwQaanMWfjGsac+83SeZx9L6hTHTJDZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ik9X+VY1DdAFIsiIyzZVUAcV+TRtnt6E7iptQJweL12R6j4yiKZ3MPJ/mBCnuoGsN7L+V/oocF5ZBuCaHVi6ZrVYlKaztSVDsXhQ5brvclQzG2zIXr9CfbnUM8L+3GdveOSdMNBN5PcPgzP0TNVh05UuKXChZLqh2qBVfqP8C4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHZ5mbYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHZ5mbYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A261C4CEE8;
	Wed, 19 Feb 2025 08:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954533;
	bh=yZ1WSfuhjVYcwQaanMWfjGsac+83SeZx9L6hTHTJDZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHZ5mbYeDzu4j0FW2w79K2pF8fAW19RKcYk3NhRfJk3GkW8qCnuEXie76B06lODAG
	 NSE188tv2JcV+nKoK6jUNCfa5ziJw80f8W/RsooExaDiywnaVKkKT/3FxVnk7ZPsxx
	 ndQTrxX2ROyS9yndOau1zsIdHtgKyaIM76QC9D4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 232/274] net: make netdev_lock() protect netdev->reg_state
Date: Wed, 19 Feb 2025 09:28:06 +0100
Message-ID: <20250219082618.659985699@linuxfoundation.org>
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

[ Upstream commit 5fda3f35349b6b7f22f5f5095a3821261d515075 ]

Protect writes to netdev->reg_state with netdev_lock().
>From now on holding netdev_lock() is sufficient to prevent
the net_device from getting unregistered, so code which
wants to hold just a single netdev around no longer needs
to hold rtnl_lock.

We do not protect the NETREG_UNREGISTERED -> NETREG_RELEASED
transition. We'd need to move mutex_destroy(netdev->lock)
to .release, but the real reason is that trying to stop
the unregistration process mid-way would be unsafe / crazy.
Taking references on such devices is not safe, either.
So the intended semantics are to lock REGISTERED devices.

Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250115035319.559603-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 2 +-
 net/core/dev.c            | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 035cc881dd756..47f817bcea503 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2446,7 +2446,7 @@ struct net_device {
 	 * Should always be taken using netdev_lock() / netdev_unlock() helpers.
 	 * Drivers are free to use it for other protection.
 	 *
-	 * Protects: @net_shaper_hierarchy.
+	 * Protects: @reg_state, @net_shaper_hierarchy.
 	 * Ordering: take after rtnl_lock.
 	 */
 	struct mutex		lock;
diff --git a/net/core/dev.c b/net/core/dev.c
index 09a9adfa7da99..75996e1aac46c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10656,7 +10656,9 @@ int register_netdevice(struct net_device *dev)
 
 	ret = netdev_register_kobject(dev);
 
+	netdev_lock(dev);
 	WRITE_ONCE(dev->reg_state, ret ? NETREG_UNREGISTERED : NETREG_REGISTERED);
+	netdev_unlock(dev);
 
 	if (ret)
 		goto err_uninit_notify;
@@ -10954,7 +10956,9 @@ void netdev_run_todo(void)
 			continue;
 		}
 
+		netdev_lock(dev);
 		WRITE_ONCE(dev->reg_state, NETREG_UNREGISTERED);
+		netdev_unlock(dev);
 		linkwatch_sync_dev(dev);
 	}
 
@@ -11560,7 +11564,9 @@ void unregister_netdevice_many_notify(struct list_head *head,
 	list_for_each_entry(dev, head, unreg_list) {
 		/* And unlink it from device chain. */
 		unlist_netdevice(dev);
+		netdev_lock(dev);
 		WRITE_ONCE(dev->reg_state, NETREG_UNREGISTERING);
+		netdev_unlock(dev);
 	}
 	flush_all_backlogs();
 
-- 
2.39.5



