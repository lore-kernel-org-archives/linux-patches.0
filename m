Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6810F46BA0;
	Mon,  4 Mar 2024 21:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588008; cv=none; b=BcdABIXi1jqsDK12hbyIqPwT+wVVUIGQqtw0DE/2J/cJxzTmaKzgLjXlUOtRT88HxxUHXb4k6nXeJOsFG5Q6eAQ7/mAnXw8vDS26dV4lmYnjVNPmUGfFiuC1IH7NnIAW5/xifppVBI/RXWKZBkBtKE//9lGb1vrqFRlk4soEnAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588008; c=relaxed/simple;
	bh=j0qgxw7OeYVUY79yhC7WH4Gl3xEqyNw8yckMxFcvwFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwXtFHW6+2FiU/OSgaNnsxqGzqFkh+1jG9aVHke4E82W2pdHsjtFkD+UXaghkRxIBNIwizApsJObaDYIvWtCac+x07jDyRv614JDjXNvASmf/7I9/Q1KLiYT+SqllDVCubosRQbWs7FEJZiaAEXRAzghc+AvmLtSHgOvJUuUK2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWqyxoSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWqyxoSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF53DC433F1;
	Mon,  4 Mar 2024 21:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588008;
	bh=j0qgxw7OeYVUY79yhC7WH4Gl3xEqyNw8yckMxFcvwFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWqyxoSqjMaQDDXraAuoM9QAR/FFXZW2Mp5uDe2tzIkz0iHxYRhDdfxh/x4yYKJ2t
	 JJQC6g1G34l8XnWuIq3FEUnOcKQu1R2+uEo6TlHn44zxcWc2q6oATVY9mSvahkhEkG
	 wS8JhbkoKdt5z0+lFmi50Tqdg7lQ0o+JpM69jmoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/25] efi/capsule-loader: fix incorrect allocation size
Date: Mon,  4 Mar 2024 21:23:48 +0000
Message-ID: <20240304211536.152680968@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211535.741936181@linuxfoundation.org>
References: <20240304211535.741936181@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b82cc8beac671..78c02717c368d 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -291,7 +291,7 @@ static int efi_capsule_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	}
 
-	cap_info->phys = kzalloc(sizeof(void *), GFP_KERNEL);
+	cap_info->phys = kzalloc(sizeof(phys_addr_t), GFP_KERNEL);
 	if (!cap_info->phys) {
 		kfree(cap_info->pages);
 		kfree(cap_info);
-- 
2.43.0



