Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2324418658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C385C433C7;
	Wed, 20 Sep 2023 11:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210573;
	bh=KdSshYQlRWeRgh3VCUsyGbdwzwQTyTTYQXEMdZ1FC6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVaJ+rZL+kVjz8hurbNVDCR04o7DxrGVaP+L1jTp1wVBt5R3qym+EjqyCDajmWNKB
	 rc8bZPoJeAqMYR2mK2W5KdKdgAUrNhjrnWXk+Wq39YVEtIZdTr3T3VTbuehg+G1nck
	 0BDyFKVWxJ09+VYj/X147ZhyTlHUpSS3YTXWZ+cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie <ruanjinjie@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 101/211] powerpc/pseries: fix possible memory leak in ibmebus_bus_init()
Date: Wed, 20 Sep 2023 13:29:05 +0200
Message-ID: <20230920112848.936347665@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit afda85b963c12947e298ad85d757e333aa40fd74 ]

If device_register() returns error in ibmebus_bus_init(), name of kobject
which is allocated in dev_set_name() called in device_add() is leaked.

As comment of device_add() says, it should call put_device() to drop
the reference count that was set in device_initialize() when it fails,
so the name can be freed in kobject_cleanup().

Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20221110011929.3709774-1-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/ibmebus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/ibmebus.c b/arch/powerpc/platforms/pseries/ibmebus.c
index 44703f13985bf..969cb9fc960f8 100644
--- a/arch/powerpc/platforms/pseries/ibmebus.c
+++ b/arch/powerpc/platforms/pseries/ibmebus.c
@@ -460,6 +460,7 @@ static int __init ibmebus_bus_init(void)
 	if (err) {
 		printk(KERN_WARNING "%s: device_register returned %i\n",
 		       __func__, err);
+		put_device(&ibmebus_bus_device);
 		bus_unregister(&ibmebus_bus_type);
 
 		return err;
-- 
2.40.1



