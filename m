Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC682E718B;
	Sat, 12 Sep 2026 07:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198501; cv=none; b=fSq7sxOS2kbzELmkwwmXxIId7CBCCzB2fk5xb1+UFIEjwt5vyBKYqErhaNRoeQ6tne4rQAbhPPX/wTxBWKt1dJEQs/rDFcEWWJJtFzycoWTI1nUA57TThWiZ7UK1SmWIkMGwIeDqwQ50qaHVVrM1uiM6X3tT2T6ds5ZzcRxVwnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198501; c=relaxed/simple;
	bh=4uKdTyqQfm6XKyTBulWyKLvOL/E3gWXxsuaZ1q6LTXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2/fQBjvrm/ytx/Sr6m3bQnsobL5srjw18gNQecIQvoRmaV2T74RXurUt0MhixBxm54LoVv3w4FU/IuH8Urng9Lcoz0FHnwmRwz+DFIwY++OKuvhRncT/nUeqGz64leDhvFoJ1gsIpe3Gw2BzHmVvQwClH9fXDhOLwsHdl06OFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybVHMEIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybVHMEIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4841F000FF;
	Sat, 12 Sep 2026 07:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198499;
	bh=UeQCLdls4p4ko50BG9rs352YrN5NvqMHtFpPl08jbmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybVHMEIrIYwFBbyS1y+dePoKFdzkg+7JOzg0NvvrTcWu9jpClxRvncwxX0NkI0QhD
	 YbVfXON3Vbluzle/e1o/GDc6xt11NVGgVyiQp64X9cdiieUhprVqPKv1IKVSfKPeWX
	 HL4R2ufgk00R9XAODng0gxawV60hBQJz78a96940=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Stevens <stevensd@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0392/1815] x86/entry/fred: Encode frame pointer on entry
Date: Sat, 12 Sep 2026 08:35:42 +0200
Message-ID: <20260912065658.097285016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Stevens <stevensd@google.com>

[ Upstream commit dab01c597f6bd40e0efe7da967b8374ca1971b79 ]

Add missing ENCODE_FRAME_POINTER macro invocation into FRED_ENTER macro,
to prevent the unwinder from encountering a NULL stack frame pointer
when CONFIG_UNWINDER_FRAME_POINTER is enabled

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Signed-off-by: David Stevens <stevensd@google.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Link: https://patch.msgid.link/20260424191456.2679717-12-stevensd@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64_fred.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index 0d2768ab836c4..b98f8945dfff4 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -7,6 +7,7 @@
 #include <linux/kvm_types.h>
 
 #include <asm/asm.h>
+#include <asm/frame.h>
 #include <asm/fred.h>
 #include <asm/segment.h>
 
@@ -19,6 +20,7 @@
 	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR
 	PUSH_AND_CLEAR_REGS
+	ENCODE_FRAME_POINTER
 	movq	%rsp, %rdi	/* %rdi -> pt_regs */
 .endm
 
-- 
2.53.0



