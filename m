Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FFF79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF59C433D2;
	Thu, 12 Jan 2023 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533112;
	bh=q1pAnY4UrtUlydqFO6L9UFny66bZFexFk7EojFBql1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2duQfYQoKegInbE06H8TChEBMQEuIWHpa7SjCFy+UA9ea3WVzig1zWLw8fKuogNPD
	 Q+/cvi7VPHGVWp6SSB91cV7HJMTh0ltiS0KRc/K9wIWhvxu/qpbnXkZO6GZCRGfcts
	 H8yD8IqWGbc9HtWE1FHepD7SSpNURtOlz8PXXp7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 343/783] class: fix possible memory leak in __class_register()
Date: Thu, 12 Jan 2023 14:50:59 +0100
Message-Id: <20230112135540.220553490@linuxfoundation.org>
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

[ Upstream commit 8c3e8a6bdb5253b97ad532570f8b5db5f7a06407 ]

If class_add_groups() returns error, the 'cp->subsys' need be
unregister, and the 'cp' need be freed.

We can not call kset_unregister() here, because the 'cls' will
be freed in callback function class_release() and it's also
freed in caller's error path, it will cause double free.

So fix this by calling kobject_del() and kfree_const(name) to
cleanup kobject. Besides, call kfree() to free the 'cp'.

Fault injection test can trigger this:

unreferenced object 0xffff888102fa8190 (size 8):
  comm "modprobe", pid 502, jiffies 4294906074 (age 49.296s)
  hex dump (first 8 bytes):
    70 6b 74 63 64 76 64 00                          pktcdvd.
  backtrace:
    [<00000000e7c7703d>] __kmalloc_track_caller+0x1ae/0x320
    [<000000005e4d70bc>] kstrdup+0x3a/0x70
    [<00000000c2e5e85a>] kstrdup_const+0x68/0x80
    [<000000000049a8c7>] kvasprintf_const+0x10b/0x190
    [<0000000029123163>] kobject_set_name_vargs+0x56/0x150
    [<00000000747219c9>] kobject_set_name+0xab/0xe0
    [<0000000005f1ea4e>] __class_register+0x15c/0x49a

unreferenced object 0xffff888037274000 (size 1024):
  comm "modprobe", pid 502, jiffies 4294906074 (age 49.296s)
  hex dump (first 32 bytes):
    00 40 27 37 80 88 ff ff 00 40 27 37 80 88 ff ff  .@'7.....@'7....
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
  backtrace:
    [<00000000151f9600>] kmem_cache_alloc_trace+0x17c/0x2f0
    [<00000000ecf3dd95>] __class_register+0x86/0x49a

Fixes: ced6473e7486 ("driver core: class: add class_groups support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221026082803.3458760-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/class.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index c3451481194e..ef7ff822bc08 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -192,6 +192,11 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	}
 	error = class_add_groups(class_get(cls), cls->class_groups);
 	class_put(cls);
+	if (error) {
+		kobject_del(&cp->subsys.kobj);
+		kfree_const(cp->subsys.kobj.name);
+		kfree(cp);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(__class_register);
-- 
2.35.1



