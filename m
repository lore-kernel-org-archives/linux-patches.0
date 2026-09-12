Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3112747ECF4;
	Sat, 12 Sep 2026 13:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219829; cv=none; b=H6P19K5flHqfEJXU9etsFFQbZpZpR1zvjMYyJzfGefMy/rjOo/LyT+5P0ZF2Ym1mQ95xw3HKyoZc/blkXiawvAi8RkHxMO8+oqkU6vpconwittk2kMy4v8TX5nhrDxtpIjsv0Lgi2Dx0w0RTppKU1o5/5OqZcSpYsHcSSzQqh38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219829; c=relaxed/simple;
	bh=5N1nZf3BHFc95j/7xitSAWvUbst34DUX/wuL1myitg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3aYBCjOl16XirWrY418wxDp1nmYrxY1M64LdUAYZwc10oRNCAUl/PViHg4gMjf0TPMXl/9/0WzUspvPEO1VzvCIqOR77CvD8be0wrMYM5wbsKUjy683drxKnfk1phWVU+5/iNX3P2CfdHF+O20tfhqJ4FEGyu5hWBky3HETJIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edLQ/eWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edLQ/eWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F192A1F000FF;
	Sat, 12 Sep 2026 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219827;
	bh=+Sffa6XY023PABy11hZ3W3nFdKlIiPa5vhGzkcUnGUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edLQ/eWZxK+HBPCOhC4ydsTvE1rhh3EJ6+rrneq8UP3Pgbya1iw1uiw3fwlivOPBW
	 Kn4eHofhXjFuqfEuzFs8wi5tqdtqK7ad2QK2AhkMefQxlDb5au2xPHxuZGgEY5bBA8
	 gSPlr5TIL4gqzrt2prmppLvfZmS2NFm4SXHg3iTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 0026/1424] powerpc/powermac: fix OF node refcount
Date: Sat, 12 Sep 2026 08:40:58 +0200
Message-ID: <20260912065607.890359787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1502,7 +1502,7 @@ static int __init pmac_i2c_create_platfo
 		if (bus->platform_dev == NULL)
 			return -ENOMEM;
 		bus->platform_dev->dev.platform_data = bus;
-		bus->platform_dev->dev.of_node = bus->busnode;
+		bus->platform_dev->dev.of_node = of_node_get(bus->busnode);
 		platform_device_add(bus->platform_dev);
 	}
 


