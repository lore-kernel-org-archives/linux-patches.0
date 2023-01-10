Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3FBA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1E8C433EF;
	Tue, 10 Jan 2023 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374170;
	bh=ctHuvUTSwO7WxGPPCVVMtKJt4e3FJszocVsAHkTaXjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fICqnQEOVZXYBVUZA4U97XnzfWm9ZZnWmBg3Djprin+fGxJVRf1+3N4Dd3UQUR7gq
	 YxO4es4q4WFtKm6u0+GHwpsb5hs4V91BRmaWJL9YU2pgkHXSXv7FK8UiTRR0DkrQyf
	 8YfqCYO2uDaHggnExL0yCSjCl0+RBbdWyOdFhKJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie <ruanjinjie@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 041/148] vdpa_sim: fix possible memory leak in vdpasim_net_init() and vdpasim_blk_init()
Date: Tue, 10 Jan 2023 19:02:25 +0100
Message-Id: <20230110180018.523659885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit aeca7ff254843d49a8739f07f7dab1341450111d ]

Inject fault while probing module, if device_register() fails in
vdpasim_net_init() or vdpasim_blk_init(), but the refcount of kobject is
not decreased to 0, the name allocated in dev_set_name() is leaked.
Fix this by calling put_device(), so that name can be freed in
callback function kobject_cleanup().

(vdpa_sim_net)
unreferenced object 0xffff88807eebc370 (size 16):
  comm "modprobe", pid 3848, jiffies 4362982860 (age 18.153s)
  hex dump (first 16 bytes):
    76 64 70 61 73 69 6d 5f 6e 65 74 00 6b 6b 6b a5  vdpasim_net.kkk.
  backtrace:
    [<ffffffff8174f19e>] __kmalloc_node_track_caller+0x4e/0x150
    [<ffffffff81731d53>] kstrdup+0x33/0x60
    [<ffffffff83a5d421>] kobject_set_name_vargs+0x41/0x110
    [<ffffffff82d87aab>] dev_set_name+0xab/0xe0
    [<ffffffff82d91a23>] device_add+0xe3/0x1a80
    [<ffffffffa0270013>] 0xffffffffa0270013
    [<ffffffff81001c27>] do_one_initcall+0x87/0x2e0
    [<ffffffff813739cb>] do_init_module+0x1ab/0x640
    [<ffffffff81379d20>] load_module+0x5d00/0x77f0
    [<ffffffff8137bc40>] __do_sys_finit_module+0x110/0x1b0
    [<ffffffff83c4d505>] do_syscall_64+0x35/0x80
    [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

(vdpa_sim_blk)
unreferenced object 0xffff8881070c1250 (size 16):
  comm "modprobe", pid 6844, jiffies 4364069319 (age 17.572s)
  hex dump (first 16 bytes):
    76 64 70 61 73 69 6d 5f 62 6c 6b 00 6b 6b 6b a5  vdpasim_blk.kkk.
  backtrace:
    [<ffffffff8174f19e>] __kmalloc_node_track_caller+0x4e/0x150
    [<ffffffff81731d53>] kstrdup+0x33/0x60
    [<ffffffff83a5d421>] kobject_set_name_vargs+0x41/0x110
    [<ffffffff82d87aab>] dev_set_name+0xab/0xe0
    [<ffffffff82d91a23>] device_add+0xe3/0x1a80
    [<ffffffffa0220013>] 0xffffffffa0220013
    [<ffffffff81001c27>] do_one_initcall+0x87/0x2e0
    [<ffffffff813739cb>] do_init_module+0x1ab/0x640
    [<ffffffff81379d20>] load_module+0x5d00/0x77f0
    [<ffffffff8137bc40>] __do_sys_finit_module+0x110/0x1b0
    [<ffffffff83c4d505>] do_syscall_64+0x35/0x80
    [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 899c4d187f6a ("vdpa_sim_blk: add support for vdpa management tool")
Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported devices")

Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20221110082348.4105476-1-ruanjinjie@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 4 +++-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index c8bfea3b7db2..cc0534f8ae93 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -427,8 +427,10 @@ static int __init vdpasim_blk_init(void)
 	int ret;
 
 	ret = device_register(&vdpasim_blk_mgmtdev);
-	if (ret)
+	if (ret) {
+		put_device(&vdpasim_blk_mgmtdev);
 		return ret;
+	}
 
 	ret = vdpa_mgmtdev_register(&mgmt_dev);
 	if (ret)
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index 886449e88502..c2e19dd06419 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -304,8 +304,10 @@ static int __init vdpasim_net_init(void)
 	int ret;
 
 	ret = device_register(&vdpasim_net_mgmtdev);
-	if (ret)
+	if (ret) {
+		put_device(&vdpasim_net_mgmtdev);
 		return ret;
+	}
 
 	ret = vdpa_mgmtdev_register(&mgmt_dev);
 	if (ret)
-- 
2.35.1



