Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705181;
	b=mpU+BIvZmf1fP8okkiNrODAt7NfWWzmRFnfL2uD4YkmHC80EdxE54RXppRZXAnuyPPuq
	 mgQ29wzXrfPoHdmsbgQAFaT++NMVLabP6Ggo7BOQeoD9Kyp1wQMD7oWPKa3iWrexvLQYT
	 M6u7r7d/Ebpj9xiMlyiTRR/+HYA7fFhvohd2kARjkh3ZwhazJ3307wwctQF3tcnFTB53i
	 RFc586Ed6PfUAzBlgFv7KfUC0PHXFmnRDYLk3n7XxrslckN6iLQXfLtn1OpoWshr4qBPe
	 kGSpkvNiIOTVWDFly26iKplOchpSEVlDtqV8QAHDEvfXRGsasEW6PZvuYQPg+kmxPhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=orE9dx3kaRGc1zWASG4lYAfn6nwlaJEeawXuwS/Qrdw=;
	b=Msu4nMy37Qq4Ms2VEPEjrUdDvLUEEYyt2vwSX8cQ6axCw1lkYarDzqwa/yUO5Lq5gcXC
	 YVmU3HIZCD4UYHZIK0X5vDixd5ldSy17zraZfzEj+A4lFHJ8anuTSoI7AR+z84aNI5lCS
	 7jibSy9LPl7Mizzla0uTNjN6doW1Jgc9ZqTCxyjTSPTAoM/C6Go6uXDGFFbKvjSVbaTGR
	 qXpf2Kx+5Jj3VcKXx8nOQG1HpqAjadByxYO5+D9cYsDjepga46viFfV3g90vR4kyh5FZy
	 PXxGLSWqfEqlvJb6ue+M9ZDThC89Ggddbz6iwsanSSdMmv5XwFrKE6w427RCirs7sYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHenSeBY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F76F606A31C;
	Thu, 26 Nov 2026 14:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHenSeBY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD501F000C6;
	Thu, 26 Nov 2026 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705180;
	bh=orE9dx3kaRGc1zWASG4lYAfn6nwlaJEeawXuwS/Qrdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHenSeBYNZGgy3NSEEmhZICVh77uMtzZRHT1mZOv3ogC+tR+Mt+9xAMWLe3wBYO7e
	 Y0F6AUFXRVw4jxSN4f7BRiALqWvzn7PvK6EkGRctW0Nt27HabDp+2tSJYMes2BEV6Y
	 HxjOfR6YXaS9g1FDaS8pdeaASqEwds5dpt8sCSFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/319] MIPS: Avoid dead code/data elimination when using recordmcount
Date: Thu, 26 Nov 2026 15:37:58 +0100
Message-ID: <20261126144009.226679473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 255d9dbd936f7db8b963e82429f6e57cd9d48999 ]

CONFIG_LD_DEAD_CODE_DATA_ELIMINATION builds with -ffunction-sections,
placing every function in its own section. recordmcount refuses to use
weak symbols as section bases, as a strong definition could override
them, so a weak function alone in its section, such as the generic
pcibios_fixup_bus() stub, breaks the build:

  Cannot find symbol for section 88: .text.pcibios_fixup_bus.
  drivers/pci/probe.o: failed

MIPS always records mcount locations with recordmcount, so this hits
any config with the function tracer and dead code elimination enabled,
e.g. malta_defconfig built with LLVM=1.

Only offer dead code elimination when recordmcount is not used, as
powerpc does since commit f8b2336f15f3 ("powerpc: Avoid dead code/data
elimination when using recordmcount"). In practice this makes it
unavailable together with the function tracer on MIPS.

Fixes: c0436b503591 ("MIPS: Enable dead code elimination")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b2869b606fd87..a113a7f505d1a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -79,7 +79,7 @@ config MIPS
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
+	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if !FTRACE_MCOUNT_USE_RECORDMCOUNT
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_PATA_PLATFORM
-- 
2.53.0



