Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F37933F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FB1C433F0;
	Mon, 16 Jan 2023 16:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885540;
	bh=E66UfLByuvpiFkZgPsyqOojYpRvUYbgfQf0UxwG0EZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqZR8GZx7BLDS6zdLCE+jzCd5Js4BUVjLrwUsLi9bD4NgyGmI2s0JQ9dLPqgWJYMy
	 Cnu+XMdn7ckJWsjiIvIz4cjSstRPA4sF+CYBicYz+IMVLmYlDQ3EcEX6rrr2aLNuAN
	 YJ8DsKb9QSpY3dT8bPBqEV/7wLWPy89RLAcpforU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/658] MIPS: vpe-mt: fix possible memory leak while module exiting
Date: Mon, 16 Jan 2023 16:42:30 +0100
Message-Id: <20230116154912.510831670@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5822e8cc84ee37338ab0bdc3124f6eec04dc232d ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically,
it need be freed when module exiting, call put_device() to give up
reference, so that it can be freed in kobject_cleanup() when the
refcount hit to 0. The vpe_device is static, so remove kfree() from
vpe_device_release().

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/vpe-mt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/vpe-mt.c b/arch/mips/kernel/vpe-mt.c
index 2e003b11a098..9fd7cd48ea1d 100644
--- a/arch/mips/kernel/vpe-mt.c
+++ b/arch/mips/kernel/vpe-mt.c
@@ -313,7 +313,6 @@ ATTRIBUTE_GROUPS(vpe);
 
 static void vpe_device_release(struct device *cd)
 {
-	kfree(cd);
 }
 
 static struct class vpe_class = {
@@ -497,6 +496,7 @@ int __init vpe_module_init(void)
 	device_del(&vpe_device);
 
 out_class:
+	put_device(&vpe_device);
 	class_unregister(&vpe_class);
 
 out_chrdev:
@@ -509,7 +509,7 @@ void __exit vpe_module_exit(void)
 {
 	struct vpe *v, *n;
 
-	device_del(&vpe_device);
+	device_unregister(&vpe_device);
 	class_unregister(&vpe_class);
 	unregister_chrdev(major, VPE_MODULE_NAME);
 
-- 
2.35.1



