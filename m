Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B51372B4B;
	Fri,  4 Sep 2026 05:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500471; cv=none; b=mxyOov9N0HXVXjsheIoknuFzP3Ds5E0Yzl9mAa6ZfMtF7txBqchlAB/7M/DHEqLlopZDqMYS9wIkL31RI3QG/v/XpqZukNQ+2XIRa/rB5usIyQzJjCdwdGFDgbP4iMb2xsIfUbcKgrN4jp4+fKAvhB0qovXR+yOZeI1rL1BIp4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500471; c=relaxed/simple;
	bh=hyREfidowScfbg+SQStHOMQmVrk6+R5Gw4vTXxXVAoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3QoX++182E7iDmAM1R+6Next8opoOmvc7TfAag+Re8TNtTLpij+58+GVmG2ESH+Uhx2g8N1WyH++4LbsR2f15tNR8MEhfHGphUTpLChCdvCc/tFdHJ0Ls1ytfEeZvctIQ+yXQkMg7puF5OoNqYXWjhUEI/I+MjG3GoNOQ8kJ8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foEetCOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foEetCOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D416D1F00A3D;
	Fri,  4 Sep 2026 05:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500470;
	bh=/lCHCmMSwQLp04kPrtTH8szW6i3aUwH25jF1EAeWCbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=foEetCObRYkjEXecMWysOoZlGhp0qwBEZqUSyUBp1rDbcbBTKSsIuMK2vechF3iS+
	 FR5V4KCeKtLX3004XKqxiYkqOhIed1eoooDfZDUmmWCzXpplv8wCDwJEL+7z9pg2jq
	 3tqwRvsJggwW3FQdCSfjlM674y/Sv2OV4ii2QBTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 066/552] powerpc/powermac: fix OF node refcount
Date: Fri,  4 Sep 2026 06:53:43 +0200
Message-ID: <20260904045749.345015548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1505,7 +1505,7 @@ static int __init pmac_i2c_create_platfo
 		if (bus->platform_dev == NULL)
 			return -ENOMEM;
 		bus->platform_dev->dev.platform_data = bus;
-		bus->platform_dev->dev.of_node = bus->busnode;
+		bus->platform_dev->dev.of_node = of_node_get(bus->busnode);
 		platform_device_add(bus->platform_dev);
 	}
 


