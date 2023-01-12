Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272FD749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D22C433D2;
	Thu, 12 Jan 2023 14:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532430;
	bh=C17CgSPHaUYY3MPHYjzuqKeYCVYYcfgrVYayM62m9sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCkwlWo6pmtM2QQoX1nAhA4m326nSJstR4nqIRYJaa54Bbi3EBdWcbl/yxTIRRg7V
	 8n93phE0pQkficU398kukUXLqnqbSk1nzTY30b2oW9ooS+nK7M9su0Zd156pD8I+FG
	 JemhB0mBp10xvwlit3cg64dYdoOsNRtFfspNNsz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/783] media: solo6x10: fix possible memory leak in solo_sysfs_init()
Date: Thu, 12 Jan 2023 14:47:55 +0100
Message-Id: <20230112135531.715016555@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index d497afc7e7b7..4ebb1e020fad 100644
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



