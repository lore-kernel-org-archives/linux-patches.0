Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F33728030E;
	Sat, 12 Sep 2026 10:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207256; cv=none; b=VtKvt0Mwkak4s8590CrgVFzP/dBGSclmQcmjmjMIj90OVOe8XTOg0d7yZUQXcon1M/XQbVpbjjOzGSmlLEJZkfx3knUoW9o89i9y0BPr+MYLEfhCWOPbval0LZzKuDYFkoFbt3PqzPDevJr147NkaWZp5rJUPHn8cyWw+urdXm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207256; c=relaxed/simple;
	bh=HOTXIZSHgr51IMT2caRDyOHLJ62RApm3Ec8tMKqkfp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUI5k5sasICjC7c8Rsa5Bf+ytA9ct7dmYJAtB/hhLbeZ3GY2LQ4uXbo+YzHryrVIy+tn7Ez2lvG41AfPWSZdnwloTUkLNNMzuzsrp1cXI5ZcdCkk5Jzcr74KNYvS7dBK2Cn5IVNF2D3dBi1b9sOBnVxYe+fvaLUSYTJUkC7TWLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzdHzlk7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzdHzlk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248731F000FF;
	Sat, 12 Sep 2026 10:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207255;
	bh=PX90j8J1CuHatWjvJJgy0ggYFWHdsMBopVxPbDFudCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzdHzlk70hIRBeFpJmFBWw5MTGTNI6zdmj/89fwdZQQs2DQhNM0zexdwYUCLk2ouD
	 dlOSNViNOstmkmPrY8zCJGC7JbnfN28R3sygMKzSS8N3+FuwWhpM4Vwx1SO3VWLhiS
	 7uwqgQtpHJGvIE7bY9C9a8OsO6+qU7eTpEc0MgRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Stevens <stevensd@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0376/1518] x86/entry/fred: Encode frame pointer on entry
Date: Sat, 12 Sep 2026 08:42:25 +0200
Message-ID: <20260912065631.971396987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fafbd3e68cb87..3b40519602077 100644
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



