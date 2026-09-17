Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE532D97B7;
	Thu, 17 Sep 2026 17:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666261; cv=none; b=PgkdT4j6SetjxUpcYWjHD7t2X9WTuw+9Wj0uqdYzdN6N8gRPWf46NMQW4ITWAJjUVIycMf84c7nACnfF/IwTf+GeavN1PdUdhZPP6QS6pNCL8/qjtpxAEmLpdZajwCfO+UwO6FaRhZjNDqQ6EmoWbQUcRWS78dESTJJ7Yy3a6NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666261; c=relaxed/simple;
	bh=dou1flIEZuBJI3OCQt1jn34zxfx1gkiz6bMgtCUOkJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1khf209w4WRI6ytPdRZOZpnWgr8Yut3IXlWSQJmucS+HhaiFb7dawEaGXrFEfqVIR2Vq1kyFdOIuCP4CYQAZzRT9HdodbPrgkf0NeUC7Y/7W/z4ENSD4h5TkMNKMi0sgZlAXS+qsd4Xtpt7XzPYB9NBSnLK1WZU+AAhdymar1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/R3/l6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/R3/l6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64F31F000FF;
	Thu, 17 Sep 2026 17:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666260;
	bh=H1bzwxmU4Js6mF0Rem+2ZnW3IM9HXN1luNPYNb49cEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/R3/l6iwBOubH99wYWblN8HjtKZfNnGvGH002YKwxADBDtvgsHCVwNub3+f7s/l5
	 CJGdflnQTSOMuvHkTQfbTOKvHvHrgfjjYul1/4v3dy/8J3NG+i03Y/tuPxwHQH3c5V
	 VcEOaJFrYQebtjx0Axw2as+4zd5vYZEfAcrhCnoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 0977/1250] Revert "riscv: Reset pmm when PR_TAGGED_ADDR_ENABLE is not set"
Date: Thu, 17 Sep 2026 16:12:52 +0100
Message-ID: <20260917151618.496848993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

commit 2d2184ac90365a4af3274e23c98d469f09f91749 upstream.

This reverts commit 3033b2b1e3949274f33a140e2a97571b5a307298.

The reverted patch is userspace-visible behavior change, not a bug fix.
The two variables here (pmm and pmlen) control two independent features:
pmm is the _hardware_ pointer masking mode that applies while executing
in userspace. pmlen is the shift amount that the _kernel_ uses when
untagging addresses; PMLEN_0 means no untagging occurs, so the kernel
does not accept tagged addresses in syscall arguments.

It is valid (as documented and tested by the self test) to enable
pointer masking without enabling the tagged address ABI. This separation
is necessary to allow userspace to create an execution environment
similar to what the kernel supports on arm64 by default, where TBI is
enabled but the tagged address ABI is not. (On arm64, there is no
equivalent to PR_PMLEN_MASK because TBI is always enabled.)

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://patch.msgid.link/20260820014551.1979772-1-samuel.holland@sifive.com
Cc: stable@vger.kernel.org
Fixes: 3033b2b1e394 ("riscv: Reset pmm when PR_TAGGED_ADDR_ENABLE is not set")
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/process.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -324,10 +324,8 @@ long set_tagged_addr_ctrl(struct task_st
 	if (arg & PR_TAGGED_ADDR_ENABLE && (tagged_addr_disabled || !pmlen))
 		return -EINVAL;
 
-	if (!(arg & PR_TAGGED_ADDR_ENABLE)) {
+	if (!(arg & PR_TAGGED_ADDR_ENABLE))
 		pmlen = PMLEN_0;
-		pmm = ENVCFG_PMM_PMLEN_0;
-	}
 
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;


