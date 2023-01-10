Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F466FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C95C433D2;
	Tue, 10 Jan 2023 18:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375527;
	bh=Zk/s7rsz7AClG+7lB9C48wODoVcp7IrNq8sQq/J/GdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0M/YFkW1Z3nrBvB60S28QYGaQ+brp5TTLZd1K0qhTVLPRowPa1AWt14Z9qXa5oPVd
	 oZTAF8pRr2IXT4lTmgO+CSiSPWZ4wL0YlpHgF/Nsw6J/vLsqmTquUu5YxiiLF//RN9
	 6BYkZRpZC6T3YS3O31+Ia4L+dXRBSgZfwZVhtBXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 218/290] vhost/vsock: Fix error handling in vhost_vsock_init()
Date: Tue, 10 Jan 2023 19:05:10 +0100
Message-Id: <20230110180039.524709158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 7a4efe182ca61fb3e5307e69b261c57cbf434cd4 ]

A problem about modprobe vhost_vsock failed is triggered with the
following log given:

modprobe: ERROR: could not insert 'vhost_vsock': Device or resource busy

The reason is that vhost_vsock_init() returns misc_register() directly
without checking its return value, if misc_register() failed, it returns
without calling vsock_core_unregister() on vhost_transport, resulting the
vhost_vsock can never be installed later.
A simple call graph is shown as below:

 vhost_vsock_init()
   vsock_core_register() # register vhost_transport
   misc_register()
     device_create_with_groups()
       device_create_groups_vargs()
         dev = kzalloc(...) # OOM happened
   # return without unregister vhost_transport

Fix by calling vsock_core_unregister() when misc_register() returns error.

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Message-Id: <20221108101705.45981-1-yuancan@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 97bfe499222b..74ac0c28fe43 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -968,7 +968,14 @@ static int __init vhost_vsock_init(void)
 				  VSOCK_TRANSPORT_F_H2G);
 	if (ret < 0)
 		return ret;
-	return misc_register(&vhost_vsock_misc);
+
+	ret = misc_register(&vhost_vsock_misc);
+	if (ret) {
+		vsock_core_unregister(&vhost_transport.transport);
+		return ret;
+	}
+
+	return 0;
 };
 
 static void __exit vhost_vsock_exit(void)
-- 
2.35.1



