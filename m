Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58A68F58;
	Mon,  4 Mar 2024 21:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588268; cv=none; b=Nns2kAM4fJo3OTdty3yBClDosLcgIH1Sl4B82u92UcuaWbhFzZcEH9TY5j20uYCRSTtpDTLhTLnvQmov95G0Mjdf4unJ7NNL+gj6GWuHR0GXwEvkUd0oC0ZU/jw69zBbQo+ij7GlhHXT9XsLJDb6QTcUTwAiL/0n6uGayCTFlag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588268; c=relaxed/simple;
	bh=eyOyIRIa4CONZPlCpLm1xUvxS9AcI4jt83c4qtTjGFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDQgekOgcv+vW6ND+aSqoqhUW2vkxJcNI3cF0f5cL0Yrpuyu7kVlaamQAqgD9STLUUzalVCGgY3utL3P4qnLwqCNVopMwcXcRZv845AKiCrN3gGarlSRwfKpjP9slBuWI3c0lkJrQm5/E5yEUqR5kbZoYaSNpVJ5JwhfnsSZMzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZ6IVeGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZ6IVeGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9B0C433C7;
	Mon,  4 Mar 2024 21:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588268;
	bh=eyOyIRIa4CONZPlCpLm1xUvxS9AcI4jt83c4qtTjGFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZ6IVeGdGTsIPE7/kxQdPFkHd0Y9MwKt7e9ESfUbk6itiG4/7t+doCl0Ry9HYp3b2
	 F5RbJq0WCbA3yrtHD3ZUwLS8udeYbOIh9AENTADi3qWlaOl1UHMk4Lqg+Cb65n0mw+
	 UzB+YtxLe9uF2StT4P9w296yiJ9wf8jNIL0UnR7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/143] efi/capsule-loader: fix incorrect allocation size
Date: Mon,  4 Mar 2024 21:22:42 +0000
Message-ID: <20240304211551.283044160@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fccfa646ef3628097d59f7d9c1a3e84d4b6bb45e ]

gcc-14 notices that the allocation with sizeof(void) on 32-bit architectures
is not enough for a 64-bit phys_addr_t:

drivers/firmware/efi/capsule-loader.c: In function 'efi_capsule_open':
drivers/firmware/efi/capsule-loader.c:295:24: error: allocation of insufficient size '4' for type 'phys_addr_t' {aka 'long long unsigned int'} with size '8' [-Werror=alloc-size]
  295 |         cap_info->phys = kzalloc(sizeof(void *), GFP_KERNEL);
      |                        ^

Use the correct type instead here.

Fixes: f24c4d478013 ("efi/capsule-loader: Reinstate virtual capsule mapping")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/capsule-loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 3e8d4b51a8140..97bafb5f70389 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -292,7 +292,7 @@ static int efi_capsule_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	}
 
-	cap_info->phys = kzalloc(sizeof(void *), GFP_KERNEL);
+	cap_info->phys = kzalloc(sizeof(phys_addr_t), GFP_KERNEL);
 	if (!cap_info->phys) {
 		kfree(cap_info->pages);
 		kfree(cap_info);
-- 
2.43.0



