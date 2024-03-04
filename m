Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB362DDCB;
	Mon,  4 Mar 2024 21:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588177; cv=none; b=WVYXBomg8IjfwDczE0FuR2yuvjOaIquZmNgNe0Rme4Ik0w6zJXI99vHtODghMuRz6+2qPhZFaMtsmrjP8uB6TPJEv9BrodS6uL/1FUOCTWcc7nZQ4ArLR2dpbBZ6qamLsu2MCvvkOsKMoBRUhXnaXJqsig+lEqb/9FIK+HqlGEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588177; c=relaxed/simple;
	bh=Z+TPzIEDI66XMpXtp2F0k/6fux700NlBs4U89uoL3j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K27Q1zKGzx8ilPlJ5XQ+7vSpCogHE0K5ZSSbI1QskPBtr3u69Bdrt72f5xqdEyn2AICOfz2jD7xSkWcvztg0u4lCQfOelMV0CIXP1nF1HmKBPw878Yr119AyOEQVXD60TeujhvE5HFfwvN87+/dRkLv6EA/Q4amo+u0pH3XIGkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7C0hkj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7C0hkj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53284C433F1;
	Mon,  4 Mar 2024 21:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588177;
	bh=Z+TPzIEDI66XMpXtp2F0k/6fux700NlBs4U89uoL3j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7C0hkj6anWYNzOMrhjnJ8Q7il23eYY4W10KpIlJIzIOsVtFFLJo6ZbeFEBSVciig
	 V8aDldID2YdzdZMQK8AXlZ/96SApy9A1KK8UU7c2qbUqGPEG9t3KS9N5pW+GUZUASj
	 79zqjZsOFJpD8qLc9NpimWBREiCtzUwgozUzKOGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/42] efi/capsule-loader: fix incorrect allocation size
Date: Mon,  4 Mar 2024 21:23:44 +0000
Message-ID: <20240304211538.209136295@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



