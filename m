Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6754C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A7FC43146;
	Mon, 14 Nov 2022 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430518;
	bh=reGresWj3rHPx51stcxQ4bCym5U4GSZbJq6jd9efBSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFPRMpAhuh9jwfnteGtQYcpUUAhfUDMoh1KwKP849Gu+2+gUvq+r7kbZWfVUMDWyQ
	 yJ1jGhj9+nXr1sivFk+TtSFMUqfiNX3MFA5KEL7C8Ou8N8GvEuFCYkNZRiK9808zB3
	 NGA62Yy2SaBgR0XF3GwszN6JkiXLQi5m85mNc34E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/131] net: lapbether: fix issue of invalid opcode in lapbeth_open()
Date: Mon, 14 Nov 2022 13:45:20 +0100
Message-Id: <20221114124450.890372420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

[ Upstream commit 3faf7e14ec0c3462c2d747fa6793b8645d1391df ]

If lapb_register() failed when lapb device goes to up for the first time,
the NAPI is not disabled. As a result, the invalid opcode issue is
reported when the lapb device goes to up for the second time.

The stack info is as follows:
[ 1958.311422][T11356] kernel BUG at net/core/dev.c:6442!
[ 1958.312206][T11356] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[ 1958.315979][T11356] RIP: 0010:napi_enable+0x16a/0x1f0
[ 1958.332310][T11356] Call Trace:
[ 1958.332817][T11356]  <TASK>
[ 1958.336135][T11356]  lapbeth_open+0x18/0x90
[ 1958.337446][T11356]  __dev_open+0x258/0x490
[ 1958.341672][T11356]  __dev_change_flags+0x4d4/0x6a0
[ 1958.345325][T11356]  dev_change_flags+0x93/0x160
[ 1958.346027][T11356]  devinet_ioctl+0x1276/0x1bf0
[ 1958.346738][T11356]  inet_ioctl+0x1c8/0x2d0
[ 1958.349638][T11356]  sock_ioctl+0x5d1/0x750
[ 1958.356059][T11356]  __x64_sys_ioctl+0x3ec/0x1790
[ 1958.365594][T11356]  do_syscall_64+0x35/0x80
[ 1958.366239][T11356]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 1958.377381][T11356]  </TASK>

Fixes: 514e1150da9c ("net: x25: Queue received packets in the drivers instead of per-CPU queues")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221107011445.207372-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 365edfd804ef..5037ef82be46 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -325,6 +325,7 @@ static int lapbeth_open(struct net_device *dev)
 
 	err = lapb_register(dev, &lapbeth_callbacks);
 	if (err != LAPB_OK) {
+		napi_disable(&lapbeth->napi);
 		pr_err("lapb_register error: %d\n", err);
 		return -ENODEV;
 	}
-- 
2.35.1



