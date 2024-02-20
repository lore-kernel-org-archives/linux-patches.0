Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5183151CD0;
	Tue, 20 Feb 2024 20:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462785; cv=none; b=aV+VgFRhE5ZIC7g40Vp5j9WMGz3uOSJa6LpGobrU1tGVl1iBqv2pOesnEYARZSVzO/5gw//+E+bU7NQLu5hryGZRX1bPSTP8w4G+D+znLT7XFoXxI+TSj2kP6ob6/bM29CIXZR9WLj7/6q70FQW3Uu3fh8FRRJMBPbObkveptGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462785; c=relaxed/simple;
	bh=74lC50DPYRGJOQJfK5t8c5SbkjIl76+4GKU03NveRYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSkfPkXpdEa5EPaWwY9axlKWD/OIUa28fRQ5+t5csgd2BDbWmvglcpMW24apoy8VV0l2WO6oZTKE7ZnXMrqJddr7kOL3NKC24802+iZcYEV+rrLl7B2ZpWj21opilfkeEqqKhxZmfGJjCsAr6TyeyfW1KNzPn8r+0hegHd+fYIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kpie/LUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kpie/LUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33089C43609;
	Tue, 20 Feb 2024 20:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462784;
	bh=74lC50DPYRGJOQJfK5t8c5SbkjIl76+4GKU03NveRYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kpie/LUJrQCjFORAtm/jcZHSNQBSm6ThNEh9YsXNEteeW4njOnW5wzcXugMxhKtHM
	 Jw5iRHS+B6cQrHzzAm4A2T7L/Ix1JvJn7Wt61tILM1ACUkQ/aTbjozUrMU1ggO0Vhd
	 EYmcy/04Isjm9DWw3adcN1rBdecwdpmEnqkWRCe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 034/197] scs: add CONFIG_MMU dependency for vfree_atomic()
Date: Tue, 20 Feb 2024 21:49:53 +0100
Message-ID: <20240220204842.101083922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

commit 6f9dc684cae638dda0570154509884ee78d0f75c upstream.

The shadow call stack implementation fails to build without CONFIG_MMU:

  ld.lld: error: undefined symbol: vfree_atomic
  >>> referenced by scs.c
  >>>               kernel/scs.o:(scs_free) in archive vmlinux.a

Link: https://lkml.kernel.org/r/20240122175204.2371009-1-samuel.holland@sifive.com
Fixes: a2abe7cbd8fe ("scs: switch to vmapped shadow stacks")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -642,6 +642,7 @@ config SHADOW_CALL_STACK
 	bool "Shadow Call Stack"
 	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
 	depends on DYNAMIC_FTRACE_WITH_ARGS || DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
+	depends on MMU
 	help
 	  This option enables the compiler's Shadow Call Stack, which
 	  uses a shadow stack to protect function return addresses from


