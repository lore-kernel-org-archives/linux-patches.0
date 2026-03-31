Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E013F8E04;
	Tue, 31 Mar 2026 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975863; cv=none; b=sFQKLfPC3exEFjngPwUlLpFmLq3ffVVUboFrIp9L1HO59g6zfN7M0+XDypwral+TMmwnlIZpTZ/2v+E0BPvIoBixlNfM1H9n/vQAJxNQss9UUFzwpI6ef7Wv8A+pRDPRAWkoC8DiWO/KhiLt80FD8gfOm58yqK9jkqYlHrNufek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975863; c=relaxed/simple;
	bh=n51NG3/m5hFockB6UNLdifs3/S0QOgA12G2WnoHVFr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6C76aNelPW6OUqWjnxwbupCV4+qWdlJ2IqUpTv61LT9eA3qZ6qqT7RDRzq3EJNzCOwYLY1iJJ9nXtt4Xj/6GzJJmxPxBqdcfhIMD7vJzhOwoUhq3sQNsvnGaLOpiAjH5FE92to8T7g9XVNa9iniyzdltGqDxLlIZKptzuXm4y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=012lMG/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="012lMG/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5376BC19423;
	Tue, 31 Mar 2026 16:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975862;
	bh=n51NG3/m5hFockB6UNLdifs3/S0QOgA12G2WnoHVFr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=012lMG/KVaok/Wy7Cg23xgsS1jP+FXDk6HG0tnuDS0mW8kvWmNcXbyVAws3nCCuN5
	 srf92sPVpdIGhdrhYmjbb0Jt4BkjEYtGkhuU3xkUEUaKJvwPx2Z1OIV/t6FQTAgQGo
	 0owbKEvQTFx6tARm7FBKWEiMAzVnlxEeHUGnulFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/244] x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size
Date: Tue, 31 Mar 2026 18:21:06 +0200
Message-ID: <20260331161745.947919314@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 217c0a5c177a3d4f7c8497950cbf5c36756e8bbb ]

ranges_to_free array should have enough room to store the entire EFI
memmap plus an extra element for NULL entry.
The calculation of this array size wrongly adds 1 to the overall size
instead of adding 1 to the number of elements.

Add parentheses to properly size the array.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: a4b0bf6a40f3 ("x86/efi: defer freeing of boot services memory")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index df3b45ef1420c..a29efaf6fe411 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -424,7 +424,7 @@ void __init efi_unmap_boot_services(void)
 	if (efi_enabled(EFI_DBG))
 		return;
 
-	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
+	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
 	ranges_to_free = kzalloc(sz, GFP_KERNEL);
 	if (!ranges_to_free) {
 		pr_err("Failed to allocate storage for freeable EFI regions\n");
-- 
2.53.0



