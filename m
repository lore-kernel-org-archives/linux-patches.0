Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C21EB5A;
	Mon,  4 Mar 2024 21:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587669; cv=none; b=IefrDGHLgly3NJqVF2XUPt3F73rtjx3d04FDdmYy6WJ5Fb4H1RYeovfexklB0+UdwuKaLrN+Jn1dpU+Gy7cEEHzjBIQaUDT/Rw7PssI+HeKmFX2V9Z5rWeaBQ/z2wWr6rTFJWjIll6vZZtJ7qAvrDXtl9EY3PIbhqrBy+kXCoVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587669; c=relaxed/simple;
	bh=8g0gtRXL8yiiy92QCebRXWUdeJ+XX+ruZcEnxgomZUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yay8pUkAmsq+icbOLMdICGf644y4jp84K1MhewRzdOUjv45zIBu0HXjYO5/JLrGHiar3iTA1lybOHQ5cS1ZY9sT4M6GE7ttiGj4OLTTHLS6HX+N+DYHq/5n4bRvp4HmPl6Awfl2XN40driy8KGRW9YCZ1KqRZ+QrTNOPB5QTOe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11vZN8lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11vZN8lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575E6C433F1;
	Mon,  4 Mar 2024 21:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587669;
	bh=8g0gtRXL8yiiy92QCebRXWUdeJ+XX+ruZcEnxgomZUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11vZN8ljq1T9WYXaQ7xey5d3iuUV33VuNCoygjX+fikCC5ztf9HFRcwe6ugyp1rx8
	 lLy7ZhN7MDhmTgg7Mkkb+tz+BrMTX7UlVAmHS+eDaMRKjo9avW2MocBpER5ULMWeso
	 S45xuGzR8yaBqGQG/YryfRyuuI5oiUFBvzxrg+Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 045/162] efi/capsule-loader: fix incorrect allocation size
Date: Mon,  4 Mar 2024 21:21:50 +0000
Message-ID: <20240304211553.292581639@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



