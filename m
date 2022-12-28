Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804C41863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00CAC433EF;
	Wed, 28 Dec 2022 14:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239364;
	bh=J5Od7YALa/hq23/+T6cu9swVfU4oJMnR0f8eH49DHrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gk+td5Nh5kdT4A7waRZoi/m0+ZBJkChdXxN4KLzgrEZcc1WB9NweOy+rYohFsUJpB
	 UGRf6aFrgUHwysAqwvR5kez6ATbLI5taOo3JS9wZV+NU1t9yo3rTWWFAtbBIcLCMy8
	 s4SiqoZM5AIKqmmy+OFJFwP5xuiZb6Xdy43e4RSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/731] media: solo6x10: fix possible memory leak in solo_sysfs_init()
Date: Wed, 28 Dec 2022 15:35:19 +0100
Message-Id: <20221228144302.703406220@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 4a546eeefe38..6d87fbb0ee04 100644
--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -420,6 +420,7 @@ static int solo_sysfs_init(struct solo_dev *solo_dev)
 		     solo_dev->nr_chans);
 
 	if (device_register(dev)) {
+		put_device(dev);
 		dev->parent = NULL;
 		return -ENOMEM;
 	}
-- 
2.35.1



