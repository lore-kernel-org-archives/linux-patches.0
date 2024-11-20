Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F4915853A;
	Wed, 20 Nov 2024 12:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107507; cv=none; b=G20sOK8Dj6PjV0TNeRpIfsduGM498fPCflaFO968c1sP/4eO5GcbdEPZBJvLYJrvbdVMR9koWjZDyxwtwkbfRh0EjwT9oRUAyPiA8Ekki0hSdKX/rO7ZvmTaqERDncjULUa1M2RyXKWBvA/QwR7htcYkTQX+zXBe4WEBOBABdr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107507; c=relaxed/simple;
	bh=RA46DoDYlVKXpRMMGjYXncSGUpBjEof4Uhf4B6Nnq3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UpLZPiZGPW8YT1wYFxJhxJjJAY5GgfRjZwgh4lrS1FP0kGg8y+Clwpn6YHua++6d4aQz0RS7GAyb8xR26/kBL+3qyi32dXDYvlRpk85KfFmg2xwxsrJATV9OKixOHGD7SUbj8bR+7GveCDK+zvaJ3uaKVCyS82KkGUxAqOfYUKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D++EuP3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D++EuP3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B566C4CECD;
	Wed, 20 Nov 2024 12:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107507;
	bh=RA46DoDYlVKXpRMMGjYXncSGUpBjEof4Uhf4B6Nnq3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D++EuP3TRz5Zs2+H/GRAO+8cdJBTT12kbvf1fUIYWQKq+fFIOJh2P4542kd4ektL0
	 VUJq5o1G0CrXVsxCGPJSqA4Bm7w5EljOiLPMFlnCTtDEEb+O1MwrvOfYQVw54xAb5F
	 k1bIU+ectB7cLVlafml53SpfYL4DL8NVS40q2D3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Pecio?= <michal.pecio@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 033/107] ARM: fix cacheflush with PAN
Date: Wed, 20 Nov 2024 13:56:08 +0100
Message-ID: <20241120125630.426610820@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit ca29cfcc4a21083d671522ad384532e28a43f033 ]

It seems that the cacheflush syscall got broken when PAN for LPAE was
implemented. User access was not enabled around the cache maintenance
instructions, causing them to fault.

Fixes: 7af5b901e847 ("ARM: 9358/2: Implement PAN for LPAE by TTBR0 page table walks disablement")
Reported-by: Michał Pecio <michal.pecio@gmail.com>
Tested-by: Michał Pecio <michal.pecio@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/traps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 480e307501bb4..6ea645939573f 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -570,6 +570,7 @@ static int bad_syscall(int n, struct pt_regs *regs)
 static inline int
 __do_cache_op(unsigned long start, unsigned long end)
 {
+	unsigned int ua_flags;
 	int ret;
 
 	do {
@@ -578,7 +579,9 @@ __do_cache_op(unsigned long start, unsigned long end)
 		if (fatal_signal_pending(current))
 			return 0;
 
+		ua_flags = uaccess_save_and_enable();
 		ret = flush_icache_user_range(start, start + chunk);
+		uaccess_restore(ua_flags);
 		if (ret)
 			return ret;
 
-- 
2.43.0



