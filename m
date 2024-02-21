Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760C447A7C;
	Wed, 21 Feb 2024 13:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523302; cv=none; b=nbclPA4OxSkLEGofncMgeIWRYRPLJwU6jCzHY1cU44KTEtxLsjWiVhStFP4FSV12mSqiayl1DdLRMYjmvenPj3Qc2otY4AtZeEW92+DPp5eDyV1y4+3o6wkeeDPtBmxcr+/ZobVusEahdX4k4xUiVP05qCsmR3chNC0ToxtouOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523302; c=relaxed/simple;
	bh=CFjsY6XUhvEp3zWZlyXjpgPHaaC3kFlm0T2QM5N7Jm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYm6zEj1Yh8bvY4CKq/UIoK6K23bOQy4AqrlpUnFwyZuVmkv/lJ/CZuj8AlI+ErUpEV/SVUQ4YBFUVrTFbqJZcXBxE9o62AImwZXUElLPP8DrVpX9fQy5CXlY0oJz5ZsQrQBUOZisnKl9xPs8fnNU+oAdGR3f9sWBpZ8a4iUYHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjFp3Vec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjFp3Vec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BE6C433C7;
	Wed, 21 Feb 2024 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523302;
	bh=CFjsY6XUhvEp3zWZlyXjpgPHaaC3kFlm0T2QM5N7Jm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjFp3Vec4K4h+wRu1MqILvtzj5ZwQ0XpDxk7Rc8ZWBQuqwFZQjB71xPXsdLnhRv2H
	 5KtNOvy+dOU7KCESL78+9+Y1AYdhiKk+ZvN4dZWnCfxYLFckuO/nHkefbfgokL08Jp
	 yX6K2f6kLt2Gfv/Be/0GC7XtHZ8prskS7BPbYoNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 356/476] scs: add CONFIG_MMU dependency for vfree_atomic()
Date: Wed, 21 Feb 2024 14:06:47 +0100
Message-ID: <20240221130021.162038771@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -605,6 +605,7 @@ config SHADOW_CALL_STACK
 	bool "Clang Shadow Call Stack"
 	depends on CC_IS_CLANG && ARCH_SUPPORTS_SHADOW_CALL_STACK
 	depends on DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
+	depends on MMU
 	help
 	  This option enables Clang's Shadow Call Stack, which uses a
 	  shadow stack to protect function return addresses from being


