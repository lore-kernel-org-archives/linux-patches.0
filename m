Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2994051C44;
	Tue, 23 Jan 2024 01:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974052; cv=none; b=orsyCp15Jcky4Pjg8Jcqfk1mZ3xN5asUUyaY604gJgWYfSUPPUUSFADDVELAJ8jFsWZEcyUCF6ZwlGKuYX/+xpPNiJY6WhxQiienIE7V5mIllDyWNM4raOndOHY/wHg/9b0Jql8Niuah9mYIXcf6hlQGmfgbcDgeD/ZwbD+TcCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974052; c=relaxed/simple;
	bh=m3Mq/rbEyt5zqMgFQHmTCmzwxjmfOocU2bXEfWN7INQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtK1FG1Qo6XS3IoPompdV7C7zRAqcFvsHCE1g4/6L2VqjxYIb73ytBiUZjcYU++b1BqunfBxchQomywHCQt5ZqwwIdWyfyNqdoMuHDI0baEgkntR3BEdE7mZx3F9GopqARnHB/roP26sEYcdXVCEofcTXQpyvCHNw6RWxXI6Rvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c42DDETr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c42DDETr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F63BC433C7;
	Tue, 23 Jan 2024 01:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974051;
	bh=m3Mq/rbEyt5zqMgFQHmTCmzwxjmfOocU2bXEfWN7INQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c42DDETrXzvXuSrF6QiVeWFlX9IDFrqF7mkZ6wBGbgYfpItMW6QNhfgj0uSwZ+1Le
	 CjpnWZ+cC2HfsVP5LKc7KRxJ7VcHTrEqYMQWxJ269Gsz+YKxG0u3n0if4g1mUp/5Au
	 tAmR390lgA6qBN8RdHUi5vf0IFSr8UcmlAb6lVxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/374] block: Set memalloc_noio to false on device_add_disk() error path
Date: Mon, 22 Jan 2024 15:56:37 -0800
Message-ID: <20240122235749.533080395@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 5fa3d1a00c2d4ba14f1300371ad39d5456e890d7 ]

On the error path of device_add_disk(), device's memalloc_noio flag was
set but not cleared. As the comment of pm_runtime_set_memalloc_noio(),
"The function should be called between device_add() and device_del()".
Clear this flag before device_del() now.

Fixes: 25e823c8c37d ("block/genhd.c: apply pm_runtime_set_memalloc_noio on block devices")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231211075356.1839282-1-linan666@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -538,6 +538,7 @@ out_del_integrity:
 out_del_block_link:
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(ddev));
+	pm_runtime_set_memalloc_noio(ddev, false);
 out_device_del:
 	device_del(ddev);
 out_free_ext_minor:


