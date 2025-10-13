Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19B030C625;
	Mon, 13 Oct 2025 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369110; cv=none; b=BmMUHVjLqHYm4Jo6rC9PAv+fEQGfRLyfm3bprSgn6HbgYUH3ip33niYqVsTP4CTWKpkh3jgFce+TFZDT3LQaA0m++tr9rq/WnOc5jO4mqPovABt0unbnZZimWf756FBrMU64Jo/gBncTNXDjWyCobPUAT4ovNZoMA43in1HzvD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369110; c=relaxed/simple;
	bh=zvmNBfvx22HP3dI0EPfpIgpbm8Eb2kITcpgPqfiQlgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQVIADblKqBfu/pSKaafYSEiy0le7Qt3ph9dPGxoFDdQ/W5PiWStEl1R6bvyXPZpumH3RH9FsYNRlrNfFJQgk5XKLjaQbJgmuS5IXcKhUqHRFjCxQo9fUrQGpobwHaBuz8M6DvKbidmDe6FkPj5Y7az075d0Eruumn3OyDD8ans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNJaY0mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNJaY0mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641A8C4CEE7;
	Mon, 13 Oct 2025 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369109;
	bh=zvmNBfvx22HP3dI0EPfpIgpbm8Eb2kITcpgPqfiQlgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNJaY0mzqtDV8gThR0pVskCqfmUpx2E9Zi36sNRwU/FRAF5gIHteE7/+tw59XiEcP
	 1JyuUMCIIbn0KBsBkxrsLJriCulR/fq1dIMCdMhM4mqt3WsJCbDzmbkjMQqzP1YOfC
	 RXmQWlSZGnmMosfjZKLS+msDtTZ4cd5e2ay3Qvmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Brian Norris <briannorris@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 088/563] genirq/test: Depend on SPARSE_IRQ
Date: Mon, 13 Oct 2025 16:39:09 +0200
Message-ID: <20251013144414.486368779@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 0c888bc86d672e551ce5c58b891c8b44f8967643 ]

Some architectures have a static interrupt layout, with a limited number of
interrupts. Without SPARSE_IRQ, the test may not be able to allocate any
fake interrupts, and the test will fail. (This occurs on ARCH=m68k, for
example.)

Additionally, managed-affinity is only supported with CONFIG_SPARSE_IRQ=y,
so irq_shutdown_depth_test() and irq_cpuhotplug_test() would fail without
it.

Add a 'SPARSE_IRQ' dependency to avoid these problems.

Many architectures 'select SPARSE_IRQ', so this is easy to miss.

Notably, this also excludes ARCH=um from running any of these tests, even
though some of them might work.

Fixes: 66067c3c8a1e ("genirq: Add kunit tests for depth counts")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/all/20250822190140.2154646-5-briannorris@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 08088b8e95ae9..a75df2bb9db66 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -147,6 +147,7 @@ config GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD
 config IRQ_KUNIT_TEST
 	bool "KUnit tests for IRQ management APIs" if !KUNIT_ALL_TESTS
 	depends on KUNIT=y
+	depends on SPARSE_IRQ
 	default KUNIT_ALL_TESTS
 	select IRQ_DOMAIN
 	imply SMP
-- 
2.51.0



