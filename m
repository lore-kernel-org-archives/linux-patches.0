Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873AB134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF96C433EF;
	Mon, 12 Jun 2023 10:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566695;
	bh=k+8h8SGvjs4mVpgQP+Iz9GTT9FbZaJrXgF70gd/xD7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bp+OrDFTC5AQgJJN8h0fWMSi45IqxFOUSlSXCntFioKNlaILWNCI7dmgTECFqHbjV
	 yHBqUB5zU/d/Gi6cfaQ60EwHeXfR8q8WnTVVOaHt/ZkE/npyZxPn5dPm9vE5lBJI8f
	 8HQOzDZmeDiaATsTn2CJfOoM43oTI4qtXQkgMkL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xie Yongji" <xieyongji@bytedance.com>,
	Xianjun Zeng <zengxianjun@bytedance.com>,
	Sheng Zhao <sheng.zhao@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/132] vduse: avoid empty string for dev name
Date: Mon, 12 Jun 2023 12:27:36 +0200
Message-ID: <20230612101715.780565122@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sheng Zhao <sheng.zhao@bytedance.com>

[ Upstream commit a90e8608eb0ed93d31ac0feb055f77ce59512542 ]

Syzkaller hits a kernel WARN when the first character of the dev name
provided is NULL. Solution is to add a NULL check before calling
cdev_device_add() in vduse_create_dev().

kobject: (0000000072042169): attempted to be registered with empty name!
WARNING: CPU: 0 PID: 112695 at lib/kobject.c:236
Call Trace:
 kobject_add_varg linux/src/lib/kobject.c:390 [inline]
 kobject_add+0xf6/0x150 linux/src/lib/kobject.c:442
 device_add+0x28f/0xc20 linux/src/drivers/base/core.c:2167
 cdev_device_add+0x83/0xc0 linux/src/fs/char_dev.c:546
 vduse_create_dev linux/src/drivers/vdpa/vdpa_user/vduse_dev.c:2254 [inline]
 vduse_ioctl+0x7b5/0xf30 linux/src/drivers/vdpa/vdpa_user/vduse_dev.c:2316
 vfs_ioctl linux/src/fs/ioctl.c:47 [inline]
 file_ioctl linux/src/fs/ioctl.c:510 [inline]
 do_vfs_ioctl+0x14b/0xa80 linux/src/fs/ioctl.c:697
 ksys_ioctl+0x7c/0xa0 linux/src/fs/ioctl.c:714
 __do_sys_ioctl linux/src/fs/ioctl.c:721 [inline]
 __se_sys_ioctl linux/src/fs/ioctl.c:719 [inline]
 __x64_sys_ioctl+0x42/0x50 linux/src/fs/ioctl.c:719
 do_syscall_64+0x94/0x330 linux/src/arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Cc: "Xie Yongji" <xieyongji@bytedance.com>
Reported-by: Xianjun Zeng <zengxianjun@bytedance.com>
Signed-off-by: Sheng Zhao <sheng.zhao@bytedance.com>
Message-Id: <20230530033626.1266794-1-sheng.zhao@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Cc: "Michael S. Tsirkin"<mst@redhat.com>, "Jason Wang"<jasowang@redhat.com>,
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 31017ebc4d7c7..72f924ec4658d 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1443,6 +1443,9 @@ static bool vduse_validate_config(struct vduse_dev_config *config)
 	if (config->vq_num > 0xffff)
 		return false;
 
+	if (!config->name[0])
+		return false;
+
 	if (!device_is_allowed(config->device_id))
 		return false;
 
-- 
2.39.2



