Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6194156F9;
	Fri,  4 Sep 2026 06:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502043; cv=none; b=uLPAKMJD2gIhr1r7ToemWgJ7bNMN3F7jqsbnnmx7e2mBsW8dtNtr2akx+6ZyKj7B7arcmri4AzM0/pNNFEo/v1yF2Nx5o099a3uFoQ4fwb66I3MgC0V96etRJciwLHcb40EgqCH1lvS7RdqQ41KJoi1mg9zBzlE3KYwE9IhqJm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502043; c=relaxed/simple;
	bh=/LD3AwliDRUNjBOV73oLireuzmAArGxcQs57rjEQ3xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AP4BfJwc0IqtSM963C0zSmLH+tvq7oPR1PnnX28+3vy4MSVsjbKdOP73gNuEXEfb9mYcC96mXYmFrTtiy9ZhroMmr3SkjFre8FHzaRBOiAC8nvD0/6cPzK7zi25kvXeiMuYgM0xtj4SEd8s7ApOkOVIkcoR9gbx2+p4eXZuRL98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRj9TyHJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRj9TyHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F7F1F00A3D;
	Fri,  4 Sep 2026 06:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502042;
	bh=qyo/piXWCCCWhUjnyTyVaZtWDB4EIf7WyDdREjf6PoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRj9TyHJ1ic0FesMyuvB8i//HpK6U+sHYN1n4SscrNRzhlQRMtn2DolWdefcdk3O9
	 UBUaQpANw/KdQxcGNw5smubNrpK/bLaab3r2gaNO0nX3eRr0ivNW5dDAFVZdGosUFk
	 Y94L8Vibe3uH0tTAK6Z2KY9WEtMCKZKqSuv1jitA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 042/403] powerpc/powermac: fix OF node refcount
Date: Fri,  4 Sep 2026 06:57:25 +0200
Message-ID: <20260904045735.771724154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1504,7 +1504,7 @@ static int __init pmac_i2c_create_platfo
 		if (bus->platform_dev == NULL)
 			return -ENOMEM;
 		bus->platform_dev->dev.platform_data = bus;
-		bus->platform_dev->dev.of_node = bus->busnode;
+		bus->platform_dev->dev.of_node = of_node_get(bus->busnode);
 		platform_device_add(bus->platform_dev);
 	}
 


