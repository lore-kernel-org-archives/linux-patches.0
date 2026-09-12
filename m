Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66632F617C;
	Sat, 12 Sep 2026 12:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215440; cv=none; b=Ipa8tlnPwUrBWSjc3/CI+WG4zUyMlFlpXld/iiWqCFM10YJt6aWsmETot09zEWqRrnGxnrdcSxY3hz3T3eRPJYK8/oA46JQ7O84jpjg+hon4RwKc7wNqXjz+tIkcSfHvaLFRvl8cSSUm5aoWyWWxqwJrVhTnYIs3fT25Za4mEoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215440; c=relaxed/simple;
	bh=GVrNVQgdEa+coKPuVzPUvDShGbWsPT1cxcs4Kn7RIvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/Wq5aFnCUCnGniF+mB4ZDCl1TiG3xPuWZrr/VLVd4yrom6GwQwoVDnHSOvprlx+d1uzScg0SXc9F6OGNvkUAS4DdYJV1Xt7pz0dIudMOfyDhEBBykYwSAfBQ1KHzJPE5DLBCaT4f5gqfxNLHBWwiEqMBLDQAx7AcqTzd6y1rWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxF6ZVn6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxF6ZVn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A857D1F000FF;
	Sat, 12 Sep 2026 12:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215438;
	bh=tjTWVlxwwBGy4wBY9twsA95OWwNIlkwxSi4HvTe+Qh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxF6ZVn6VWULuie2BM6Zidfq8OBRv1sj8AIUit2Fe+NejIl6w9EZVJuByGlUzgd6u
	 tRGSj7G1q3sd+JCHGPOWTeTt8ekjoFo9Hd2kmnOpr2dchHs3VmCwpDCYJGSimHOC7x
	 CmndUVIXSbqqZbzzKEWUAWRq6TKqzcjXUl2+0kOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Stevens <stevensd@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0532/1376] x86/entry/fred: Encode frame pointer on entry
Date: Sat, 12 Sep 2026 08:49:18 +0200
Message-ID: <20260912065619.397967250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 0ca9db540b16d..3c1bf47af56c2 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -6,6 +6,7 @@
 #include <linux/export.h>
 
 #include <asm/asm.h>
+#include <asm/frame.h>
 #include <asm/fred.h>
 #include <asm/segment.h>
 
@@ -18,6 +19,7 @@
 	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR
 	PUSH_AND_CLEAR_REGS
+	ENCODE_FRAME_POINTER
 	movq	%rsp, %rdi	/* %rdi -> pt_regs */
 .endm
 
-- 
2.53.0



