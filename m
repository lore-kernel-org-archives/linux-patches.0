Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8336FB1;
	Tue,  5 Dec 2023 03:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBagUNeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C263C433C8;
	Tue,  5 Dec 2023 03:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747473;
	bh=5ErkSKrCRZJ48d+QaM2W3+C++K/Bsj8wcRlj51LJUH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBagUNeXNb2+q7pIzvB5Zidx1FRsDYE8vmKBOU6dbTEfYUf+stKc57SdhHnYWyhbi
	 RD7jJ4X2xfB1F1B+lXZOxjFpFHGK4z2bDXup3PDYrCXMQu2MWtt5zP0cf3TeK2Ceqf
	 Xf9t1CEyDQTn6UbgiFfbWJB5VJnTsCTOsFAfgTGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 055/135] hv_netvsc: Fix race of register_netdevice_notifier and VF register
Date: Tue,  5 Dec 2023 12:16:16 +0900
Message-ID: <20231205031533.919449561@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 85520856466ed6bc3b1ccb013cddac70ceb437db upstream.

If VF NIC is registered earlier, NETDEV_REGISTER event is replayed,
but NETDEV_POST_INIT is not.

Move register_netdevice_notifier() earlier, so the call back
function is set before probing.

Cc: stable@vger.kernel.org
Fixes: e04e7a7bbd4b ("hv_netvsc: Fix a deadlock by getting rtnl lock earlier in netvsc_probe()")
Reported-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2771,12 +2771,17 @@ static int __init netvsc_drv_init(void)
 	}
 	netvsc_ring_bytes = ring_size * PAGE_SIZE;
 
+	register_netdevice_notifier(&netvsc_netdev_notifier);
+
 	ret = vmbus_driver_register(&netvsc_drv);
 	if (ret)
-		return ret;
+		goto err_vmbus_reg;
 
-	register_netdevice_notifier(&netvsc_netdev_notifier);
 	return 0;
+
+err_vmbus_reg:
+	unregister_netdevice_notifier(&netvsc_netdev_notifier);
+	return ret;
 }
 
 MODULE_LICENSE("GPL");


