Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A44F357A4A;
	Tue, 17 Mar 2026 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766245; cv=none; b=WH/EpVzq1nW9NiRZff1vsi5ORMIkD83IGcmp9onsff9OmEYVFoDTEdqJgbG6wkIDc4keyMANFTTEJgqNUvmhxbHAZtwbSuO2sRC2xmjEjPKOJ0DbxBgX75zolb1ytDF1R1Bh9si5JakCPKukxJl613w+zD8h5WpYSEPZvrHch3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766245; c=relaxed/simple;
	bh=8cI9cYvAc8odfd+DjkYyQYm6QZSH543E/9G839ga8rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JU+xBrqcwq/AWRIDO72Liq0MoT4ztzsfSw1KOomygD/ZL7loIusYqSeITxjF9UzIz/Ulm8HkbihWeTrJFogVEpCHWY0zFtiiJFyb3/W2c2gRAGlDr/2Gq6rg1K1sG1NylccIEplfTQG0GOmTGsjHiFLbSQKQ3Hj7dmnfwu5+6Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPGplEBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPGplEBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60894C4CEF7;
	Tue, 17 Mar 2026 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766245;
	bh=8cI9cYvAc8odfd+DjkYyQYm6QZSH543E/9G839ga8rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPGplEBI7hY2MWHg2z8xY5wR8zATpkR1Vs1OYt8KFuSBXOEE9+RAqOFGRts9ZlKwN
	 w5AZfB9uwRRlantfxXoem8thlzH9yRH8kBvAiCj2CQSBqnLEFlh7nWUAi74J6fOJ02
	 kevzQ7CVZ7slUVjHyKWx+DcSBGYiYEvGbIAYMmhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.19 169/378] Revert "usb: gadget: u_ether: Add auto-cleanup helper for freeing net_device"
Date: Tue, 17 Mar 2026 17:32:06 +0100
Message-ID: <20260317163013.227419779@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit 46662d3a1ad40282ba9f753cccc6f909ec4468cc upstream.

This reverts commit 0c0981126b99288ed354d3d414c8a5fd42ac9e25.

This commit is being reverted as part of a series-wide revert.

By deferring the net_device allocation to the bind() phase, a single
function instance will spawn multiple network devices if it is symlinked
to multiple USB configurations.

This causes regressions for userspace tools (like the postmarketOS DHCP
daemon) that rely on reading the interface name (e.g., "usb0") from
configfs. Currently, configfs returns the template "usb%d", causing the
userspace network setup to fail.

Crucially, because this patch breaks the 1:1 mapping between the
function instance and the network device, this naming issue cannot
simply be patched. Configfs only exposes a single 'ifname' attribute per
instance, making it impossible to accurately report the actual interface
name when multiple underlying network devices can exist for that single
instance.

All configurations tied to the same function instance are meant to share
a single network device. Revert this change to restore the 1:1 mapping
by allocating the network device at the instance level (alloc_inst).

Reported-by: David Heidelberg <david@ixit.cz>
Closes: https://lore.kernel.org/linux-usb/70b558ea-a12e-4170-9b8e-c951131249af@ixit.cz/
Fixes: 56a512a9b410 ("usb: gadget: f_ncm: align net_device lifecycle with bind/unbind")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260309-f-ncm-revert-v2-4-ea2afbc7d9b2@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |   15 ---------------
 drivers/usb/gadget/function/u_ether.h |    2 --
 2 files changed, 17 deletions(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -1125,21 +1125,6 @@ void gether_cleanup(struct eth_dev *dev)
 }
 EXPORT_SYMBOL_GPL(gether_cleanup);
 
-void gether_unregister_free_netdev(struct net_device *net)
-{
-	if (!net)
-		return;
-
-	struct eth_dev *dev = netdev_priv(net);
-
-	if (net->reg_state == NETREG_REGISTERED) {
-		unregister_netdev(net);
-		flush_work(&dev->work);
-	}
-	free_netdev(net);
-}
-EXPORT_SYMBOL_GPL(gether_unregister_free_netdev);
-
 /**
  * gether_connect - notify network layer that USB link is active
  * @link: the USB link, set up with endpoints, descriptors matching
--- a/drivers/usb/gadget/function/u_ether.h
+++ b/drivers/usb/gadget/function/u_ether.h
@@ -283,8 +283,6 @@ int gether_get_ifname(struct net_device
 int gether_set_ifname(struct net_device *net, const char *name, int len);
 
 void gether_cleanup(struct eth_dev *dev);
-void gether_unregister_free_netdev(struct net_device *net);
-DEFINE_FREE(free_gether_netdev, struct net_device *, gether_unregister_free_netdev(_T));
 
 void gether_setup_opts_default(struct gether_opts *opts, const char *name);
 void gether_apply_opts(struct net_device *net, struct gether_opts *opts);


