Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC2728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1073C433EF;
	Mon, 12 Dec 2022 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852952;
	bh=NH2DpwhekoQkusuqQjIL1tLQwfVlzVQXzp7Nj5TpWkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSwANxUY8vWbyW+kS3su+rvJNqZkQLccVn2Azs3GiZqWipko1dIVlB0EormIsSE69
	 U7h1br9ySge1XMB7FP02d5W/OarC8HFexXDHRO2FFCASO/ZQv9lf8zprk9wyyQYJak
	 K3acPZThPVB2e7wQj8uYrP1TcuV1ILLkdk0bmqM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/49] Bluetooth: Fix not cleanup led when bt_init fails
Date: Mon, 12 Dec 2022 14:19:06 +0100
Message-Id: <20221212130915.069368517@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
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

[ Upstream commit 2f3957c7eb4e07df944169a3e50a4d6790e1c744 ]

bt_init() calls bt_leds_init() to register led, but if it fails later,
bt_leds_cleanup() is not called to unregister it.

This can cause panic if the argument "bluetooth-power" in text is freed
and then another led_trigger_register() tries to access it:

BUG: unable to handle page fault for address: ffffffffc06d3bc0
RIP: 0010:strcmp+0xc/0x30
  Call Trace:
    <TASK>
    led_trigger_register+0x10d/0x4f0
    led_trigger_register_simple+0x7d/0x100
    bt_init+0x39/0xf7 [bluetooth]
    do_one_initcall+0xd0/0x4e0

Fixes: e64c97b53bc6 ("Bluetooth: Add combined LED trigger for controller power")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/af_bluetooth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index ee60c30f3be2..798f8f485e5a 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -743,7 +743,7 @@ static int __init bt_init(void)
 
 	err = bt_sysfs_init();
 	if (err < 0)
-		return err;
+		goto cleanup_led;
 
 	err = sock_register(&bt_sock_family_ops);
 	if (err)
@@ -779,6 +779,8 @@ static int __init bt_init(void)
 	sock_unregister(PF_BLUETOOTH);
 cleanup_sysfs:
 	bt_sysfs_cleanup();
+cleanup_led:
+	bt_leds_cleanup();
 	return err;
 }
 
-- 
2.35.1



