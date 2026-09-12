Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935E036B90A;
	Sat, 12 Sep 2026 17:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232444; cv=none; b=JUKja20/C/0jwtKY1/5aYvZe/wC4YdChEw4DUCAEaNx1f12Cl04dpY4r/YHkpZRRaBJK2Dz+ljsHfDaZFOPkCXrW2porKz19ukdpqO4UGCfON2/SvWmqv4+xYYVXhn7HD/2rAKiOyPIDEqOTBU8CnOxkObMLBtzDzjonCCNUEyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232444; c=relaxed/simple;
	bh=16ck+0p6EcdglIhYUUsuofhSCAmDlub9XlG+BjJY9eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCTGFQzuNzBMrZ1giI7Cc5yjwOU0B/EnhwA8pn+UE76sbrrHUKUfJALikHFiVk2kJLhuXgiS9JzttQRYHUzLENUmjq0PfGqvcBWBrRnICVeHf/Doabl6wKjKa7w0qms+BJa29aNSoubjRelUiQb84UJcdqp6IsaJlpOAWIHG88M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G88qi5+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G88qi5+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0751F000FF;
	Sat, 12 Sep 2026 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232442;
	bh=TDZjII4zhXiGKGp72cGYeF3Avh6lItRXBvUE7ZVwn1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G88qi5+5ERGLNOSbL1IFAR1JVY+L2e8jkV8rmfBchyYGcgWtSJq6FSYQWPCIzkWnX
	 GgVdUmxlb9SnqZQVBk1S2pmGFTNTQe/hU/uu6u1PZUdzw0UcfT1aBidK3K0POmnrPf
	 txy+K8lzzTBrZIbYC+oFio6aHJEEkLJMJOy50CHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.15 012/935] powerpc/powermac: fix OF node refcount
Date: Sat, 12 Sep 2026 08:50:42 +0200
Message-ID: <20260912065527.121033540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


