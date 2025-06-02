Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7D522257E;
	Mon,  2 Jun 2025 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876564; cv=none; b=BaEwj0z83vGp/QXXyXvtbxbuboHmZW8z3/OUkeC+fO33C23oD9t/FiCIWvYmXd7VnuH0EGnI67E+2azXCsGKJTBGScvTcWUFQrk3xKLqSwivxCdiUr3BaCVjBqzr1GcUz3eEG9GiT7HjRUwNFQ3nZmZ+DFy7ijxqlqwgsH2xH0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876564; c=relaxed/simple;
	bh=kt9md95zIo+NPYkM3IX4kAmCxyxSlkgjeH2DW7Q5CMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hs5zsqV3G7sUn4aJNn8DLi3kR2RJN0OK/Amqtu28V4+O7+tAF9YK4aANSGoti8hrXtNpfNzM9bc+XG3ZMsCnOgPxn1ECyBnTIQvgef/q9vOwuUso3wdXMDdj7HXbYmHbCVenU2xV2CR/67ZZVP474ITE2O3WD1cC6ewJRGAN7dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiF3K9FX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiF3K9FX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9C5C4CEEE;
	Mon,  2 Jun 2025 15:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876564;
	bh=kt9md95zIo+NPYkM3IX4kAmCxyxSlkgjeH2DW7Q5CMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiF3K9FX+onRGco06B0sKUrNQ/hEbaUb/ssDID9lqVnMwE4gzFquhOaSaBotSwxE4
	 ziZT2Vq2FGvWxh87sHp2SXZdI3nQH8+5/VRWma4DNphazh939O4qLPAy/CRfGspvMd
	 nD6vmpAP3spvU1ug2mC7WulkS2cB8RUvMFgtaBEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.15 189/207] x86/its: Fix undefined reference to cpu_wants_rethunk_at()
Date: Mon,  2 Jun 2025 15:49:21 +0200
Message-ID: <20250602134306.179957592@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Below error was reported in a 32-bit kernel build:

  static_call.c:(.ref.text+0x46): undefined reference to `cpu_wants_rethunk_at'
  make[1]: [Makefile:1234: vmlinux] Error

This is because the definition of cpu_wants_rethunk_at() depends on
CONFIG_STACK_VALIDATION which is only enabled in 64-bit mode.

Define the empty function for CONFIG_STACK_VALIDATION=n, rethunk mitigation
is anyways not supported without it.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: 5d19a0574b75 ("x86/its: Add support for ITS-safe return thunk")
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Link: https://lore.kernel.org/stable/0f597436-5da6-4319-b918-9f57bde5634a@roeck-us.net/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -98,7 +98,7 @@ static inline u8 *its_static_thunk(int r
 }
 #endif
 
-#ifdef CONFIG_RETHUNK
+#if defined(CONFIG_RETHUNK) && defined(CONFIG_STACK_VALIDATION)
 extern bool cpu_wants_rethunk(void);
 extern bool cpu_wants_rethunk_at(void *addr);
 #else


