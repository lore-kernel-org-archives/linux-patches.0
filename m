Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C18BBA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52CCC433D2;
	Tue,  7 Mar 2023 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211684;
	bh=QDmSBcuuHKYL8R3kvia2vQJi88UAyL72m+Gws6HYhE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEcSKd2aHroqZYe8Ffyk+CfsF3wFpvfVWCKk9ghglAZGOCS9ymau1Gr2PKQk/ffn+
	 a57y/wc12S4ZWHacoaoA7FuV+tG1GgT2hjp2L1eS29cTMfYVEwsZmNScbusxyeklZF
	 lRltzn/TmWUo1Tkhz3rdV6n5lFf2y5/VW+IcY62U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhao <yan.y.zhao@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.2 0943/1001] vfio: Fix NULL pointer dereference caused by uninitialized group->iommufd
Date: Tue,  7 Mar 2023 18:01:55 +0100
Message-Id: <20230307170103.062777649@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yan Zhao <yan.y.zhao@intel.com>

commit d649c34cb916b015fdcb487e51409fcc5caeca8d upstream.

group->iommufd is not initialized for the iommufd_ctx_put()

[20018.331541] BUG: kernel NULL pointer dereference, address: 0000000000000000
[20018.377508] RIP: 0010:iommufd_ctx_put+0x5/0x10 [iommufd]
...
[20018.476483] Call Trace:
[20018.479214]  <TASK>
[20018.481555]  vfio_group_fops_unl_ioctl+0x506/0x690 [vfio]
[20018.487586]  __x64_sys_ioctl+0x6a/0xb0
[20018.491773]  ? trace_hardirqs_on+0xc5/0xe0
[20018.496347]  do_syscall_64+0x67/0x90
[20018.500340]  entry_SYSCALL_64_after_hwframe+0x4b/0xb5

Fixes: 9eefba8002c2 ("vfio: Move vfio group specific code into group.c")
Cc: stable@vger.kernel.org
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Link: https://lore.kernel.org/r/20230222074938.13681-1-yan.y.zhao@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/group.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 0e9036e2b9c4..160deff6649b 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -137,7 +137,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 
 		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
 		if (ret) {
-			iommufd_ctx_put(group->iommufd);
+			iommufd_ctx_put(iommufd);
 			goto out_unlock;
 		}
 
-- 
2.39.2



