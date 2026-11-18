Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026077;
	b=q8tpBwD2ksvXcdtMHxOOYO3jslnydrlVZYBeCoVhO9bm8Id0Rwqu+pD6MVH3EWjGftrg
	 NU6o2S/jDMo6i4oQ091TAwoWZcTyI8T1x9N1zPCXIO5KB1+zD2/a/0zbS9X0ojCd+yIWJ
	 Rx0tgQ/hWK6M/CWlNCyzpkJ7zUsvhv6/0rGMSNMoaNXFz/b4JLe9Ne7lBpw4kRdXiuWmQ
	 gxLFbKEqSlyIM90KPOHTfCsAay9Xx5xDnYPtbUawn+DbLZzfxr4irIx3VFn0j04YpDnoQ
	 KZlEa19oCuykOecTRbxfZS3gQft6iCRbMgZEz2Up051aNbWeURPwvExYQ3LZPGaQxPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RQgkOZ6JTlpK8MBlo4gNBz9Tgj9JeQZw6mNPIDQb2Ys=;
	b=ElkVUfQ5JekeZCUKCkHdZ7Tg5mhUjUB6nVpSEXwzmpCYJ95TCpyZbFYD6J/jhYg5YbOo
	 LYzy5wdp0cNLQmZ6BGjVtT4PCPvzhYLtWZSmZOaB5Y2lsyqGv9fSG09QiplDJyzykQCDq
	 8XbuY+1XWHCbpaLJuIvxkmDm8oXg8twvR+SS9uSFaMMlYRX4wSNoRalktCpvgwg+Mq65M
	 7P/sdSn6HYWKbYPEc2A+vHQOaCKAuB70WeXunRSL2NO0moK7VcRbFgZ/HUnksaysA+50p
	 U5hH9CLdsG9k+SU1uytKzYOu2TZNuBUZw7lUim3xC5svIEW7ARdJk0lANYUYnIP10YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKchL6Wy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CA4606A32A;
	Wed, 18 Nov 2026 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKchL6Wy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598E01F000C7;
	Wed, 18 Nov 2026 18:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026076;
	bh=RQgkOZ6JTlpK8MBlo4gNBz9Tgj9JeQZw6mNPIDQb2Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKchL6WyrBNAwf83/yLCAmyZg8u5Jah2r/1E4XPtiuxCRlTOqWTDnfVGBzwOVYZ0r
	 QfCjuWMnI0wwFa6/WehtOkVw1a+Ebvgw2aY575rALJlx/ZU1rvCFrqxuPK6LJqLIar
	 nrPB29xMK7/Yo27S4eUuC11zLn/OKiaC3VM8imJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1306/2151] vfio/pci: Drain eventfd RCU callbacks on module exit
Date: Wed, 18 Nov 2026 15:50:41 +0100
Message-ID: <20261118150209.674698049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 3b2e9b05011ee74543b6d17401bb02f1df3b93ff ]

vfio_pci_eventfd_replace_locked() defers freeing replaced eventfds to
vfio_pci_eventfd_rcu_free(). A callback can remain queued after
close_device() returns and the device driver module reference is dropped.
Once the dependent driver is removed, vfio-pci-core can be unloaded while
the callback still points into its module text.

Wait for outstanding RCU callbacks before vfio-pci-core exits.

Fixes: 98693e0897f7 ("vfio/pci: Use RCU for error/request triggers to avoid circular locking")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://lore.kernel.org/r/20261003093806.544631-1-yaojiale02@163.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a807a678277c6..b2f9ff2e4fef4 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2607,6 +2607,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_set_params);
 static void vfio_pci_core_cleanup(void)
 {
 	vfio_pci_uninit_perm_bits();
+	rcu_barrier();
 }
 
 static int __init vfio_pci_core_init(void)
-- 
2.53.0



