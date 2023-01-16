Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E3F6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862F3C433EF;
	Mon, 16 Jan 2023 17:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888715;
	bh=57WJNM/Doia2ByJN1tCr+Lg9f1ORpCmkQcU3sEnTmPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwI3KBrbRPxIR6/SyqZUQ9jQq8/Q/va78Rs43SaoeJxbPPI8GjeNqIihSAxxG9o5x
	 L2lYdhnYErHle0qAAGw/1vAj+L/ezivF3qDGxpBFKhaaME7whZGyv2ddVDFleC+KYW
	 vhtTFgPnB0sYUHANoIuGsVwvpGElT45/dRn0HY6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 080/338] media: solo6x10: fix possible memory leak in solo_sysfs_init()
Date: Mon, 16 Jan 2023 16:49:13 +0100
Message-Id: <20230116154824.369180343@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

[ Upstream commit 7f5866dd96d95b74e439f6ee17b8abd8195179fb ]

If device_register() returns error in solo_sysfs_init(), the
name allocated by dev_set_name() need be freed. As comment of
device_register() says, it should use put_device() to give up
the reference in the error path. So fix this by calling
put_device(), then the name can be freed in kobject_cleanup().

Fixes: dcae5dacbce5 ("[media] solo6x10: sync to latest code from Bluecherry's git repo")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/solo6x10/solo6x10-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/solo6x10/solo6x10-core.c b/drivers/media/pci/solo6x10/solo6x10-core.c
index ca0873e47bea..a654cc5ddecd 100644
--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -428,6 +428,7 @@ static int solo_sysfs_init(struct solo_dev *solo_dev)
 		     solo_dev->nr_chans);
 
 	if (device_register(dev)) {
+		put_device(dev);
 		dev->parent = NULL;
 		return -ENOMEM;
 	}
-- 
2.35.1



