Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F573033C4;
	Wed, 28 Jan 2026 15:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615921; cv=none; b=TPhtvWPtkLBmfBoEpr+N8vyTqd2lPX+AOzfuFHLBodOI6S3bhtFpLX2QJa1YfeNG19tth9bTBB1M4YWcZyZJwNGKf2iWiDZSPxmxkfFEhvWk6VonKQ5aBFGdeNJ1Pm+T4paCmTMTnTAXskQBCXr1wWXBrz+954DiINQhKNX0L70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615921; c=relaxed/simple;
	bh=fOK+cxiqC3Av4hc68UkY8n7KK8GSTtaC3ntasj9lUK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYmrfGVyloHlrmns9vsrAlgqg9e4UumILNh7sIsb2cmlqsP1CHdEvUEWL4JIRcTwxx985yOuhFJa09R6849+FT0WuHBjy8UiIMwWYe1blcwF/5sATviywNSJMXPV8+Hft1duXRqRcokyMI4cOPzjvtByyGk2B2DWrighH7FOsKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9iDn6vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9iDn6vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8473C4CEF1;
	Wed, 28 Jan 2026 15:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615921;
	bh=fOK+cxiqC3Av4hc68UkY8n7KK8GSTtaC3ntasj9lUK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9iDn6vqC2LJtvUEiH23WsuXKiHfgBW8ItQAnRGBA06ISp4Tv5Ls/kVKD1l3OZBxP
	 ZGmQkzH1NlkrGzXqR5axHLQym30LOUTmZsY5Y4hyGuChcH84dUiSqWnQW+jBkSYoIF
	 g/e+MumyrLBCgHiyByH/UXSDl5F3u0YIFWyGzPw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Joel Granados <joel.granados@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 153/227] panic: only warn about deprecated panic_print on write access
Date: Wed, 28 Jan 2026 16:23:18 +0100
Message-ID: <20260128145349.960034539@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

commit 90f3c123247e9564f2ecf861946ec41ceaf5e198 upstream.

The panic_print_deprecated() warning is being triggered on both read and
write operations to the panic_print parameter.

This causes spurious warnings when users run 'sysctl -a' to list all
sysctl values, since that command reads /proc/sys/kernel/panic_print and
triggers the deprecation notice.

Modify the handlers to only emit the deprecation warning when the
parameter is actually being set:

 - sysctl_panic_print_handler(): check 'write' flag before warning.
 - panic_print_get(): remove the deprecation call entirely.

This way, users are only warned when they actively try to use the
deprecated parameter, not when passively querying system state.

Link: https://lkml.kernel.org/r/20260106163321.83586-1-gal@nvidia.com
Fixes: ee13240cd78b ("panic: add note that panic_print sysctl interface is deprecated")
Fixes: 2683df6539cb ("panic: add note that 'panic_print' parameter is deprecated")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/panic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -131,7 +131,8 @@ static int proc_taint(const struct ctl_t
 static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
-	panic_print_deprecated();
+	if (write)
+		panic_print_deprecated();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 
@@ -1010,7 +1011,6 @@ static int panic_print_set(const char *v
 
 static int panic_print_get(char *val, const struct kernel_param *kp)
 {
-	panic_print_deprecated();
 	return  param_get_ulong(val, kp);
 }
 


