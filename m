Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DD061675;
	Mon,  4 Mar 2024 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588704; cv=none; b=RR2DEPvRdBfv1Zdz+GnOszqD0wwefCPKb738zyXywW5L1lh2sBePXHCb7UDLZCWTdT8OriBlhh6yDAju6tjGrIHjb+4PdBj00+SFo2P+VmvhXmnSHybHCoq4huqizPPYdKeK6x0AmmWU8AEBQYri/JJvBW8HT7SJGuy/LVoJdRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588704; c=relaxed/simple;
	bh=yAs3eqcsAwMzkwGUFnMOuZJkHmtAyFGcoAz+QoCO6NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXJBuLx+Ix11dVU6fBT7U9b8PpCCchifXh1+4VHezybCPeb8wsl1NsNimhggLKaWgzRTHE0C4Q2rFZsVnUgoYJteS+UHt6Rbmye3BOnpOHrP8W1BDQprr8ODPWmzavkqsJmE0//+dhbhc6DZnmA9L08Yxf1z6WzYPIYQXyJbY14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6oxaI5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6oxaI5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4F0C433C7;
	Mon,  4 Mar 2024 21:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588704;
	bh=yAs3eqcsAwMzkwGUFnMOuZJkHmtAyFGcoAz+QoCO6NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6oxaI5zxxcdmQKDfNVNB/fWKgGGr7/2gGc7bSlrjHOLrqLvF8wSWvRUPvmznt3e9
	 7CqygTEzkS2Y4HQFd9bPez886/XocL3lM5AS9kO+0a2+1aEWt0m9xCjxkuyWgyF3qo
	 5mXO8BAspPsLhesBZ/Ulj2ILBFJDZBXShcM478Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/215] efi/capsule-loader: fix incorrect allocation size
Date: Mon,  4 Mar 2024 21:22:07 +0000
Message-ID: <20240304211559.015937596@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



