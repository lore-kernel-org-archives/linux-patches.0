Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6D77B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B06BC433D7;
	Wed, 23 Nov 2022 08:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193981;
	bh=aUJhFyHohN20NlAGcixCwR5yZZi0/oiXnIScYpqYowk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJXzPYuERf+vQOr9tOPm3f/NJsAPnRUTbfKF82WX4HUOga0cVHXBluyxVQurc7gb2
	 I8xAgcbgBlev7fUD4myV7eM8nJ4NhZZHs2yeBUIW4GRc6jeNb8+lRDGnI1DIo8IG7S
	 9hwLFL1wJptKGrLv316Tk3e1XehohlanI9oo4EA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 37/88] ASoC: core: Fix use-after-free in snd_soc_exit()
Date: Wed, 23 Nov 2022 09:50:34 +0100
Message-Id: <20221123084549.785407816@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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

[ Upstream commit 6ec27c53886c8963729885bcf2dd996eba2767a7 ]

KASAN reports a use-after-free:

BUG: KASAN: use-after-free in device_del+0xb5b/0xc60
Read of size 8 at addr ffff888008655050 by task rmmod/387
CPU: 2 PID: 387 Comm: rmmod
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
Call Trace:
<TASK>
dump_stack_lvl+0x79/0x9a
print_report+0x17f/0x47b
kasan_report+0xbb/0xf0
device_del+0xb5b/0xc60
platform_device_del.part.0+0x24/0x200
platform_device_unregister+0x2e/0x40
snd_soc_exit+0xa/0x22 [snd_soc_core]
__do_sys_delete_module.constprop.0+0x34f/0x5b0
do_syscall_64+0x3a/0x90
entry_SYSCALL_64_after_hwframe+0x63/0xcd
...
</TASK>

It's bacause in snd_soc_init(), snd_soc_util_init() is possble to fail,
but its ret is ignored, which makes soc_dummy_dev unregistered twice.

snd_soc_init()
    snd_soc_util_init()
        platform_device_register_simple(soc_dummy_dev)
        platform_driver_register() # fail
    	platform_device_unregister(soc_dummy_dev)
    platform_driver_register() # success
...
snd_soc_exit()
    snd_soc_util_exit()
    # soc_dummy_dev will be unregistered for second time

To fix it, handle error and stop snd_soc_init() when util_init() fail.
Also clean debugfs when util_init() or driver_register() fail.

Fixes: fb257897bf20 ("ASoC: Work around allmodconfig failure")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221028031603.59416-1-chenzhongjin@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index febf2b649b96..b29c5a09267e 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4376,10 +4376,23 @@ EXPORT_SYMBOL_GPL(snd_soc_of_get_dai_link_codecs);
 
 static int __init snd_soc_init(void)
 {
+	int ret;
+
 	snd_soc_debugfs_init();
-	snd_soc_util_init();
+	ret = snd_soc_util_init();
+	if (ret)
+		goto err_util_init;
 
-	return platform_driver_register(&soc_driver);
+	ret = platform_driver_register(&soc_driver);
+	if (ret)
+		goto err_register;
+	return 0;
+
+err_register:
+	snd_soc_util_exit();
+err_util_init:
+	snd_soc_debugfs_exit();
+	return ret;
 }
 module_init(snd_soc_init);
 
-- 
2.35.1



