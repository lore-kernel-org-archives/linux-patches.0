Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A5BB641;
	Tue, 16 Jul 2024 15:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144393; cv=none; b=HokyOJvEzK4+GMzuL+OeHPjAnVJ9LZeLy99ZuY6zn+tYHt/xC5bxykZY/khjVKaliNLTiNnU4AmW1nLyRnUpJHKHOHMYc9C2BsVTTp0U2u/HdlwpYU82wDzBgwnnVTNtbIDiHNGjXYMIvycdFBjuBEzkqI3f8ldcUv+lGcPjIqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144393; c=relaxed/simple;
	bh=B82YaMOnWn1IdYKXqA+yNi9ocdOzCIh0IBtEfsqw0XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC2B/mBxaTtedGpP7sdRrbTNsNqGAsHhZX0ihZ0sI8j0ZFEDtxRoLdBjVSGKjxA1a7X8voFC9vgwHhDQwDMgv0mgygdSEzK2gNSZLKpuwQd+oRuNaIPu4KYnQ+7Aqnzlt7tHgWGp5srwtumicWGe4FoSpen4WLUUGnw52AhH81o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg7B+Za/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg7B+Za/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB11DC116B1;
	Tue, 16 Jul 2024 15:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144393;
	bh=B82YaMOnWn1IdYKXqA+yNi9ocdOzCIh0IBtEfsqw0XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg7B+Za/aFmcUS7G7RmIvJrXojex+xOhAo8dI7U1A2iM0UI8tfFGUhPH0V69JnfQY
	 e6aj9Szlog3AiQiB6F8VEQTwwSUPkpM71wFBCANaqa3TO7uTlRNXqYOwA5hL3lAmjC
	 ASAYRqvQRUpUFX4/3BCFI89qfsVPca6nx57FSYtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/78] powerpc/64: Set _IO_BASE to POISON_POINTER_DELTA not 0 for CONFIG_PCI=n
Date: Tue, 16 Jul 2024 17:30:49 +0200
Message-ID: <20240716152741.297452016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit be140f1732b523947425aaafbe2e37b41b622d96 ]

There is code that builds with calls to IO accessors even when
CONFIG_PCI=n, but the actual calls are guarded by runtime checks.

If not those calls would be faulting, because the page at virtual
address zero is (usually) not mapped into the kernel. As Arnd pointed
out, it is possible a large port value could cause the address to be
above mmap_min_addr which would then access userspace, which would be
a bug.

To avoid any such issues, set _IO_BASE to POISON_POINTER_DELTA. That
is a value chosen to point into unmapped space between the kernel and
userspace, so any access will always fault.

Note that on 32-bit POISON_POINTER_DELTA is 0, so the patch only has an
effect on 64-bit.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240503075619.394467-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index e86516ff8f4b3..f5c9504f6071d 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -46,7 +46,7 @@ extern struct pci_dev *isa_bridge_pcidev;
  * define properly based on the platform
  */
 #ifndef CONFIG_PCI
-#define _IO_BASE	0
+#define _IO_BASE	POISON_POINTER_DELTA
 #define _ISA_MEM_BASE	0
 #define PCI_DRAM_OFFSET 0
 #elif defined(CONFIG_PPC32)
-- 
2.43.0



