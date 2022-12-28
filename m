Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512151863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9114C433EF;
	Wed, 28 Dec 2022 15:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240513;
	bh=lx1ls6BJYhsGptyycfrqrX5A8rYuX6cFVvKtRoB/R/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ko7s1Zqxq0Wb+TnQe2YXGc9cm3WeU5cGFbNtnUxMBr19gZgFxArjg99T9YgqilSFb
	 kMQbJitTQgnET3Xu0KiSXpldVUqt3ZYxV9WLnGpovS/JdiRzu8io2i3vk3wSyPzwT3
	 1YQr/+45CMH0bid1tqp/t57fBK6xgViAkvTW2t98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0134/1146] MIPS: vpe-cmp: fix possible memory leak while module exiting
Date: Wed, 28 Dec 2022 15:27:53 +0100
Message-Id: <20221228144333.790417103@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit c5ed1fe0801f0c66b0fbce2785239a5664629057 ]

dev_set_name() allocates memory for name, it need be freed
when module exiting, call put_device() to give up reference,
so that it can be freed in kobject_cleanup() when the refcount
hit to 0. The vpe_device is static, so remove kfree() from
vpe_device_release().

Fixes: 17a1d523aa58 ("MIPS: APRP: Add VPE loader support for CMP platforms.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/vpe-cmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/vpe-cmp.c b/arch/mips/kernel/vpe-cmp.c
index e673603e11e5..92140edb3ce3 100644
--- a/arch/mips/kernel/vpe-cmp.c
+++ b/arch/mips/kernel/vpe-cmp.c
@@ -75,7 +75,6 @@ ATTRIBUTE_GROUPS(vpe);
 
 static void vpe_device_release(struct device *cd)
 {
-	kfree(cd);
 }
 
 static struct class vpe_class = {
@@ -157,6 +156,7 @@ int __init vpe_module_init(void)
 	device_del(&vpe_device);
 
 out_class:
+	put_device(&vpe_device);
 	class_unregister(&vpe_class);
 
 out_chrdev:
@@ -169,7 +169,7 @@ void __exit vpe_module_exit(void)
 {
 	struct vpe *v, *n;
 
-	device_del(&vpe_device);
+	device_unregister(&vpe_device);
 	class_unregister(&vpe_class);
 	unregister_chrdev(major, VPE_MODULE_NAME);
 
-- 
2.35.1



