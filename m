Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC5E1C6AB;
	Mon,  4 Mar 2024 21:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589262; cv=none; b=hwPad5Igi8B2m+HzQYSVLF1Uj1jwcPoxG0/ibT6fL3UTRJ9dUIHkEBoXkOWAjxjfLj2lRmQnFDc7Ux0l8vN+xwcauYj3djFG5UmYZ+LCD+W5n6sePP7PVMAae3WRV1NYZX6/jCOMZksF90XH90G0Bgq/hfWNJ4AUA5F4Fx1Ijrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589262; c=relaxed/simple;
	bh=7uQwv7+ZHas6hv2qpx/wK0kqI3+9cmsPJVVoJ9n8h/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWdq5ZXFH4roGYgMRHA6h9lvd+8fV96+ZxxUer3hD5sCx1MLZvx8KIXwEdQ9C1e9jxkd0fYL9sGlIgn6jfI8EPBioVsB3CPrRxKF+MlZ5Iy+rHolNYR8IovBjjA4/hnWNIZON+i//mN9wdsEw/z3c56kAnM19LxriyJA8NUTnUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUFoUWA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUFoUWA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A455BC433F1;
	Mon,  4 Mar 2024 21:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589262;
	bh=7uQwv7+ZHas6hv2qpx/wK0kqI3+9cmsPJVVoJ9n8h/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUFoUWA1rkskjC0aZYtXoorFcBYFuGCCkVqHN7tlFQwObRN6OGzTOOsDHYTIHZuY1
	 nHcW++mNjSrBS6jy2bpMhUkRj152FsWukM09HqxXiYHBm1pvMGGAR5chSOMhG2IMzk
	 ActecXpWzRXnSjRHTCMkLtZMs0O1YAIbgd7HeOw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/84] efi/capsule-loader: fix incorrect allocation size
Date: Mon,  4 Mar 2024 21:24:14 +0000
Message-ID: <20240304211543.701474598@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



