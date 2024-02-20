Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8EE14A4D2;
	Tue, 20 Feb 2024 21:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464663; cv=none; b=rk5LsiI1ehLmy8mkI64GCjn1zUxG/eOHX4zjvh6EaznclUL1i9DhrPgNTbsrX7qtVSbML5/v6VDibyeuCjWqxqDrvfbwBpF5eVUds0D+5pFOBCu4ZbMgt1T5wwch27wto04MqihXSO8kt1DG4+uVJpMkmw0ud3ux37hwxN49Ks0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464663; c=relaxed/simple;
	bh=Nq+Uj/U1ljAz3yf4UR6PHEku2LfmD6S1Pxi8tc4ccPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8HLJrs9LZsh0BJIvS8lu2m8Mw96vzP87y5bwaKwQCKY5oFVh+8lXxkGkdMbDUsrxMz/BsbULWSDSw4ofNL+ZMI8WhqJjGX1vnsFkeOUg8G7fofSlOkJ30l9RCdavXxb3rTsQ/rlq2I0jt92c8lZSn+Tv3j++LrCGhV/O0p3bTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nyh3f4tF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nyh3f4tF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9902AC433C7;
	Tue, 20 Feb 2024 21:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464663;
	bh=Nq+Uj/U1ljAz3yf4UR6PHEku2LfmD6S1Pxi8tc4ccPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nyh3f4tF5iK93bCD0Gs3EqGUd268gl71g3vZLaQQNMiquO85oEDJESYrm3+Moo86H
	 HAEaKQqW0Rj5B/nBeum6ve+k0BzXDm0bnt9PeHQy97zuwwg5UZXcnZcom9uGaV0X+g
	 J9zL4jlElmC17pa2rQYgCK0FrR1fhKPupKRLBQuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 066/309] scs: add CONFIG_MMU dependency for vfree_atomic()
Date: Tue, 20 Feb 2024 21:53:45 +0100
Message-ID: <20240220205635.279208766@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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
@@ -681,6 +681,7 @@ config SHADOW_CALL_STACK
 	bool "Shadow Call Stack"
 	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
 	depends on DYNAMIC_FTRACE_WITH_ARGS || DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
+	depends on MMU
 	help
 	  This option enables the compiler's Shadow Call Stack, which
 	  uses a shadow stack to protect function return addresses from


