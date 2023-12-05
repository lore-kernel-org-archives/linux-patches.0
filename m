Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7DCA4C;
	Tue,  5 Dec 2023 03:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZQMJ56m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82BBC433CA;
	Tue,  5 Dec 2023 03:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747937;
	bh=u7oB92hKpW2TmB+DyQb+Pakipp77TSFSGgHEvpJ3JLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZQMJ56m8q2ajQoYhlJRypkSG2r6+4kwTXQdL26DhH91NBLllOLyuFKg89PnvZJXo
	 NYVDGmwhpHq5lXIJHafFTwj+0KsYRUNEXKgNGbEZ4CXHezvwXjPLvTZiBNBEB96I4q
	 UYV8N5RiVRbZ3/YigiPjOrFSJFexGs3K0aAknBUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 5.4 53/94] firewire: core: fix possible memory leak in create_units()
Date: Tue,  5 Dec 2023 12:17:21 +0900
Message-ID: <20231205031525.812169398@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

commit 891e0eab32a57fca4d36c5162628eb0bcb1f0edf upstream.

If device_register() fails, the refcount of device is not 0, the name
allocated in dev_set_name() is leaked. To fix this by calling put_device(),
so that it will be freed in callback function kobject_cleanup().

unreferenced object 0xffff9d99035c7a90 (size 8):
  comm "systemd-udevd", pid 168, jiffies 4294672386 (age 152.089s)
  hex dump (first 8 bytes):
    66 77 30 2e 30 00 ff ff                          fw0.0...
  backtrace:
    [<00000000e1d62bac>] __kmem_cache_alloc_node+0x1e9/0x360
    [<00000000bbeaff31>] __kmalloc_node_track_caller+0x44/0x1a0
    [<00000000491f2fb4>] kvasprintf+0x67/0xd0
    [<000000005b960ddc>] kobject_set_name_vargs+0x1e/0x90
    [<00000000427ac591>] dev_set_name+0x4e/0x70
    [<000000003b4e447d>] create_units+0xc5/0x110

fw_unit_release() will be called in the error path, move fw_device_get()
before calling device_register() to keep balanced with fw_device_put() in
fw_unit_release().

Cc: stable@vger.kernel.org
Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Fixes: a1f64819fe9f ("firewire: struct device - replace bus_id with dev_name(), dev_set_name()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/core-device.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -719,14 +719,11 @@ static void create_units(struct fw_devic
 					fw_unit_attributes,
 					&unit->attribute_group);
 
-		if (device_register(&unit->device) < 0)
-			goto skip_unit;
-
 		fw_device_get(device);
-		continue;
-
-	skip_unit:
-		kfree(unit);
+		if (device_register(&unit->device) < 0) {
+			put_device(&unit->device);
+			continue;
+		}
 	}
 }
 


