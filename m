Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C123236607D;
	Thu, 30 Jul 2026 15:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426451; cv=none; b=EAFvPj/l69SYBINfO5JX2jXUHUjm0ijswdvHyY/w445FSYqj0N1Lf3qefkuoRvcf//+UweqXLEspSqUH8Z/8gVsx2rN3dfC7m22L5/8x39rd+LrDGtc3kq2340FSx0A1Cs6udYVlNdy07DcBYAYzDB5+1/6/qYzPzB9iKCbRLsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426451; c=relaxed/simple;
	bh=mnDgaq1Z9B//rS1stFPMAxY1ZRzFbYpKJpAihYLpM98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1e++ZZWFxJGDbEmEtvucXbPGDNbzSqHjN1hKCus8OAqlc7g+T+cBohW3Yy2hVP23UsgzLwiZ42Iz3jXJ2yWN4qxylJQpRAi+wj7e6Kg6FC//N0C3G7Uv3EmOPCTDl/wlKXWA8hi2eykvuQDGUoz48U/RGHnGaGeDWBgNQ05Iwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPnjuQYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPnjuQYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1980D1F000E9;
	Thu, 30 Jul 2026 15:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426450;
	bh=YCopve5lxIufF5BkQFnfKYzV3yxc3DmcDY9PGxCuCFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPnjuQYtYhq+lTzZaaXs6NBBZ5Se4fJbT8usbKvEEJd8QldTeDOdhff4Uim8iJjKz
	 8pZ9SszxrYo8rYVdJBdbusnDKFbT1LeXCgAuDBdGMdIqyGX6XF/ggmbhDb5tSBaP0G
	 1Xtf31q4dzA5k+/cHDIDfY5CHIWMFM3uvMXoBkBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 380/602] tracing/probes: Fix potential underflow in LEN_OR_ZERO macro
Date: Thu, 30 Jul 2026 16:12:52 +0200
Message-ID: <20260730141443.943599737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 8ce20bfba48902e1382187cd1a852f7cf3a1e739 upstream.

In __set_print_fmt(), LEN_OR_ZERO is defined as (len ? len - pos : 0).
If len is non-zero but smaller than pos, len - pos evaluates to a negative
integer. When passed as a size argument to snprintf(), this negative value
is cast to a large unsigned size_t, bypassing buffer size limits.

Ensure len > pos before subtracting to avoid integer underflow.

Link: https://lore.kernel.org/all/178454234934.290363.15247317871499514139.stgit@devnote2/

Fixes: 5bf652aaf46c ("tracing/probes: Integrate duplicate set_print_fmt()")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1886,7 +1886,7 @@ int traceprobe_update_arg(struct probe_a
 }
 
 /* When len=0, we just calculate the needed length */
-#define LEN_OR_ZERO (len ? len - pos : 0)
+#define LEN_OR_ZERO (len > pos ? len - pos : 0)
 static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 			   enum probe_print_type ptype)
 {


