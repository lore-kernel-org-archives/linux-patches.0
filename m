Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B52387368;
	Tue, 10 Mar 2026 11:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141963; cv=none; b=LTfFB5Fm4V2jXog1aYcTvA/KPkubhAjoPaA8h2QEnSZ2L7raIPVxvFKtbetBIJLUZFu3fQf9uxik7q6Qd6y9k8yGYIgPtQLA6f0XodByTwptd825d4XzqKPDC2Ao6IQ66fes3liPWfAW04vic2/kWaw07d36SM36XkP1YChXrmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141963; c=relaxed/simple;
	bh=fQca0xB1uESPYq0X1asaQ/hsUhw/9uOf7yUREpM9Ex0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJtr+tcsYBuqxKIicvuM51ZJT4nLiE0qAxKeWk6ezlfCcEUk3mKeXTrEFDasTyvMpWDwuM+qR7SLQymoeK26Ae7G6wSNVyyxd3Ic7FcdH+7avd4lYAleiunUpYSTUgcPYDVAgSuu7fsP/AMqApfBma9uLxwVeXR+G7izjBocZpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVCDqV5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVCDqV5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0057DC2BCAF;
	Tue, 10 Mar 2026 11:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141963;
	bh=fQca0xB1uESPYq0X1asaQ/hsUhw/9uOf7yUREpM9Ex0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVCDqV5VjktkvHOjMCv4dxKvw8NRqRThIhd88oYvL0gjl2+eUBpFlDuef07EAHiud
	 ww8JPTqSbm/G/8e02m0nR+DWqzcxe3EUKi4U5SDsbXF9iPwi6182QYp2plWn4U61Tc
	 pMzqGXAjdVGZ9R6vV3822S9F3psETDxY3IXAt+s8YxvtSpDXjXdMbpbWq/la3pUsyN
	 GQt9uSAgCET29ZgWemMgD9SHaRL4br18tBvtBmRmdFbC2Hs/IDwHTJR8irfptRp1vs
	 2+0UZBIaHbnlNKmWA+SQtLtwTQ45b0DPgPw2HMHsLFPv9sgxDHual9Xdphqreh8HRT
	 2JQHaqDMu9NMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuen-Han Tsai <khtsai@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/314] usb: gadget: u_ether: Add auto-cleanup helper for freeing net_device
Date: Tue, 10 Mar 2026 07:15:46 -0400
Message-ID: <2ff6a746cab85298df1be175205b6f6126c60edc.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit 0c0981126b99288ed354d3d414c8a5fd42ac9e25 ]

The net_device in the u_ether framework currently requires explicit
calls to unregister and free the device.

Introduce gether_unregister_free_netdev() and the corresponding
auto-cleanup macro. This ensures that if a net_device is registered, it
is properly unregistered and the associated work queue is flushed before
the memory is freed.

This is a preparatory patch to simplify error handling paths in gadget
drivers by removing the need for explicit goto labels for net_device
cleanup.

Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20251230-ncm-refactor-v1-2-793e347bc7a7@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 56a512a9b410 ("usb: gadget: f_ncm: align net_device lifecycle with bind/unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_ether.c | 15 +++++++++++++++
 drivers/usb/gadget/function/u_ether.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 745ed2c212e3a..6c32665538cc0 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -1125,6 +1125,21 @@ void gether_cleanup(struct eth_dev *dev)
 }
 EXPORT_SYMBOL_GPL(gether_cleanup);
 
+void gether_unregister_free_netdev(struct net_device *net)
+{
+	if (!net)
+		return;
+
+	struct eth_dev *dev = netdev_priv(net);
+
+	if (net->reg_state == NETREG_REGISTERED) {
+		unregister_netdev(net);
+		flush_work(&dev->work);
+	}
+	free_netdev(net);
+}
+EXPORT_SYMBOL_GPL(gether_unregister_free_netdev);
+
 /**
  * gether_connect - notify network layer that USB link is active
  * @link: the USB link, set up with endpoints, descriptors matching
diff --git a/drivers/usb/gadget/function/u_ether.h b/drivers/usb/gadget/function/u_ether.h
index 63a0240df4d74..a212a8ec5eb1b 100644
--- a/drivers/usb/gadget/function/u_ether.h
+++ b/drivers/usb/gadget/function/u_ether.h
@@ -283,6 +283,8 @@ int gether_get_ifname(struct net_device *net, char *name, int len);
 int gether_set_ifname(struct net_device *net, const char *name, int len);
 
 void gether_cleanup(struct eth_dev *dev);
+void gether_unregister_free_netdev(struct net_device *net);
+DEFINE_FREE(free_gether_netdev, struct net_device *, gether_unregister_free_netdev(_T));
 
 void gether_setup_opts_default(struct gether_opts *opts, const char *name);
 void gether_apply_opts(struct net_device *net, struct gether_opts *opts);
-- 
2.51.0

