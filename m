Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3E479C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342DCC433D2;
	Thu, 12 Jan 2023 14:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533145;
	bh=cYKpT8JglNn0RlDKOQ9mj4eNl6hxGc7+A3CVt9rJlL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akWz29jFPYTRZI++f9JwZG9jAu4A/MtPgBoze5Zqu5laFs0RYMLa3Bfgt8I9EZKAf
	 faTPjWokeSAszCO7qLsYnG0WfsdzmmOg5ibUYZ06k9lLaAF4h9XBZY73+gRM1HibS6
	 asbuDVdZE628f+twOt4uQ4ufzXJ6LppCwfN6Kr6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/783] vme: Fix error not catched in fake_init()
Date: Thu, 12 Jan 2023 14:51:41 +0100
Message-Id: <20230112135542.150939922@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 7bef797d707f1744f71156b21d41e3b8c946631f ]

In fake_init(), __root_device_register() is possible to fail but it's
ignored, which can cause unregistering vme_root fail when exit.

 general protection fault,
 probably for non-canonical address 0xdffffc000000008c
 KASAN: null-ptr-deref in range [0x0000000000000460-0x0000000000000467]
 RIP: 0010:root_device_unregister+0x26/0x60
 Call Trace:
  <TASK>
  __x64_sys_delete_module+0x34f/0x540
  do_syscall_64+0x38/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Return error when __root_device_register() fails.

Fixes: 658bcdae9c67 ("vme: Adding Fake VME driver")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221205084805.147436-1-chenzhongjin@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vme/bridges/vme_fake.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vme/bridges/vme_fake.c b/drivers/vme/bridges/vme_fake.c
index 6a1bc284f297..eae78366eb02 100644
--- a/drivers/vme/bridges/vme_fake.c
+++ b/drivers/vme/bridges/vme_fake.c
@@ -1073,6 +1073,8 @@ static int __init fake_init(void)
 
 	/* We need a fake parent device */
 	vme_root = __root_device_register("vme", THIS_MODULE);
+	if (IS_ERR(vme_root))
+		return PTR_ERR(vme_root);
 
 	/* If we want to support more than one bridge at some point, we need to
 	 * dynamically allocate this so we get one per device.
-- 
2.35.1



