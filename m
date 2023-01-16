Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CB56FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8D3C433EF;
	Mon, 16 Jan 2023 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888935;
	bh=gbUaiQ8eiOAytPUL8ZXCFHkgrf09cc/Qz3QcWKn+O3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBqDUoVb/Q5Uf/4g1BOo5tsloDfHE0vrQq/Y/3wR3v+HUIdsECuV+agcoiBtI14uz
	 xfW3AnvOC0x7BPj96AhJ0iJPhRZXx8+vk4xwhfo9BVntztXXWmhqij6qaAIaW1UwqT
	 jFemij0BD3gF2Dlns9rOvuuqYqP7AdGkKDiUz9dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 178/338] vme: Fix error not catched in fake_init()
Date: Mon, 16 Jan 2023 16:50:51 +0100
Message-Id: <20230116154828.671447588@linuxfoundation.org>
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
index e81ec763b555..150ee8b3507f 100644
--- a/drivers/vme/bridges/vme_fake.c
+++ b/drivers/vme/bridges/vme_fake.c
@@ -1077,6 +1077,8 @@ static int __init fake_init(void)
 
 	/* We need a fake parent device */
 	vme_root = __root_device_register("vme", THIS_MODULE);
+	if (IS_ERR(vme_root))
+		return PTR_ERR(vme_root);
 
 	/* If we want to support more than one bridge at some point, we need to
 	 * dynamically allocate this so we get one per device.
-- 
2.35.1



