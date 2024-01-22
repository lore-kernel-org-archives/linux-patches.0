Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5015397;
	Tue, 23 Jan 2024 00:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970808; cv=none; b=DqoWyXA3Cev1pgsluxs5VvktHuCuyDlwiOFncck+/8G7IQk7QxG+9CpyqEKSLAClr3Pe22Oc9qw3K12VfhSat3bfIWFrHzpg9/pMEBVVqtNsk6AiqSSeK6YSspiu3xTXkcCMVtEKKwdkTnRMZU7KaBNx5BsOLBtYDR8mji/HS7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970808; c=relaxed/simple;
	bh=vkJaJ9cbSlIYUtGUf1999cttgAJhKKLcdsNZn3hyd/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S48OSGR3Z78QeWqKPe9OK3jROfK6qWn6WHmqI4npYPTTkqdtpDGoRO6G6BN5lzpx9ZuoYiV6vSGZAvhDYuRBufb/zmk0P1y6vEgfT+ptjK1NEGQgw/LoejEH4FNyHz7wdMoF8y9hvWvCgXWf+bpFH1WofVsW53JNSXpOByAeAzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZztFnDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZztFnDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38031C43390;
	Tue, 23 Jan 2024 00:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970808;
	bh=vkJaJ9cbSlIYUtGUf1999cttgAJhKKLcdsNZn3hyd/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZztFnDF24IN8Lja1/a3G9outv/T7bmHF8dmKrzQTuDm0wz9yxCt6MlbCuqwH8yQ2
	 oJKHGc73szHx92BTpp2j9wr4cK9Vlhqx8h3jwvG4vqJpb/n8M3FjUC6aUWb6sHzvK7
	 +V1LlBY6U0cJTsWnR2LxSJRzmpeqNk/nPztaAqA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/417] block: Set memalloc_noio to false on device_add_disk() error path
Date: Mon, 22 Jan 2024 15:54:41 -0800
Message-ID: <20240122235755.680254290@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -567,6 +567,7 @@ out_del_integrity:
 out_del_block_link:
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(ddev));
+	pm_runtime_set_memalloc_noio(ddev, false);
 out_device_del:
 	device_del(ddev);
 out_free_ext_minor:


