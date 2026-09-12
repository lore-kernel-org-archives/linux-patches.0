Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192B938DC48;
	Sat, 12 Sep 2026 19:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240920; cv=none; b=YvVl375RkRatX4Hko9EwT/RE4coZBaCKfqh0sOI2nKpLYEycOSzkW/3IoUHPS4I2KsNmwvJjx/2iq1C1dtI8K48lxhEXLJ+uYQ0CDEequyy55S2JP27Lry0Szwy6/OGUgS+snd+ITNLxyubB13khLHaBNVvh57o+bqrZ2O6Ynfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240920; c=relaxed/simple;
	bh=VcTk38w6+9Yxzn1t9fo/89ONTXH7uKSorlkApBBDbIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2zLzDMYDD6926m+SrywCWj5lGFXazb65qIGJVgrDnipl/vEJ8SzLG9msyPV2xS/D0pl6tsmZLIKMVkDZKqRQlHTqT4pkLYDSdLF4hicr5v666FanpkKgcTBho6c/JwAMfcheY/wlGP3uQ2NB1H9YxjR3mfXBFFY1Z208hSDu5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVF8P2Rr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVF8P2Rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98281F00893;
	Sat, 12 Sep 2026 19:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240909;
	bh=t1onNDH7rXFgJ2MzGCyQArpzYlyOIRPUMLAy/lWnSss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVF8P2RrWKan7RuFpfdMLtI6zvtee5zHn/3ONx6qySSY63kn1ugK2hvPoDjPkL+9m
	 SgtgK2Q72VQkPY/L2JOjAOiXS5PpLKgE4ovJqyw9iGIF/1YIAe+yF/tO02Browo00D
	 HNg3AUPdZ8vSFASiyTrJZNTT9Ct32TO4Ni5cr4m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.10 011/798] powerpc/powermac: fix OF node refcount
Date: Sat, 12 Sep 2026 08:53:59 +0200
Message-ID: <20260912065517.216759962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit bd0abfe6b013aeb2a1aebc5fbc7ceeb50355bda3 upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 81e5d8646ff6 ("i2c/powermac: Register i2c devices from device-tree")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260706-pdev-fwnode-ref-v3-1-1ff028e33779@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powermac/low_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -1501,7 +1501,7 @@ static int __init pmac_i2c_create_platfo
 		if (bus->platform_dev == NULL)
 			return -ENOMEM;
 		bus->platform_dev->dev.platform_data = bus;
-		bus->platform_dev->dev.of_node = bus->busnode;
+		bus->platform_dev->dev.of_node = of_node_get(bus->busnode);
 		platform_device_add(bus->platform_dev);
 	}
 


