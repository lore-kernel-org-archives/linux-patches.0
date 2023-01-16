Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FDE6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8335FC433EF;
	Mon, 16 Jan 2023 16:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887733;
	bh=4egZIMYlZb6BBOSH4JS0tYwXsZtXp2iKIdAmbHPM49w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11cLtu+1uCGiRaK1+dSvWKv0emvyAzrITQut3iwrXrIiBxQRlitwOR8w5lTnv42T/
	 ohheFfaTni9tLvjfEnkgYQagdO/lO/NbjNQShgjSdh3b21A37Y9FQHF4ZgYKJzoPhF
	 e3uyBziaumyZwc0VNdE4l00/s6ZOkFXuLdkbItrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 232/521] test_firmware: fix memory leak in test_firmware_init()
Date: Mon, 16 Jan 2023 16:48:14 +0100
Message-Id: <20230116154857.520225941@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 7610615e8cdb3f6f5bbd9d8e7a5d8a63e3cabf2e ]

When misc_register() failed in test_firmware_init(), the memory pointed
by test_fw_config->name is not released. The memory leak information is
as follows:
unreferenced object 0xffff88810a34cb00 (size 32):
  comm "insmod", pid 7952, jiffies 4294948236 (age 49.060s)
  hex dump (first 32 bytes):
    74 65 73 74 2d 66 69 72 6d 77 61 72 65 2e 62 69  test-firmware.bi
    6e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  n...............
  backtrace:
    [<ffffffff81b21fcb>] __kmalloc_node_track_caller+0x4b/0xc0
    [<ffffffff81affb96>] kstrndup+0x46/0xc0
    [<ffffffffa0403a49>] __test_firmware_config_init+0x29/0x380 [test_firmware]
    [<ffffffffa040f068>] 0xffffffffa040f068
    [<ffffffff81002c41>] do_one_initcall+0x141/0x780
    [<ffffffff816a72c3>] do_init_module+0x1c3/0x630
    [<ffffffff816adb9e>] load_module+0x623e/0x76a0
    [<ffffffff816af471>] __do_sys_finit_module+0x181/0x240
    [<ffffffff89978f99>] do_syscall_64+0x39/0xb0
    [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: c92316bf8e94 ("test_firmware: add batched firmware tests")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20221119035721.18268-1-shaozhengchao@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_firmware.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index a74b1aae7461..f4cc874021da 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -902,6 +902,7 @@ static int __init test_firmware_init(void)
 
 	rc = misc_register(&test_fw_misc_device);
 	if (rc) {
+		__test_firmware_config_free();
 		kfree(test_fw_config);
 		pr_err("could not register misc device: %d\n", rc);
 		return rc;
-- 
2.35.1



