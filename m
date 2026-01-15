Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0573D3480;
	Thu, 15 Jan 2026 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498218; cv=none; b=Pj533Goio39wKRZ6TBomiO7pTI+lTjbUuw59sAqIEBaT0Xq7AOui2Uyan0r8gcO40yLZVAcjOZ7sBIfKlq0/NPrbwDpSa9ae08SpCuKNHXdNDcWOwphDGXYED4TUax6QCvGh5j3HtKAOi58twO/YgyfzRy1+2Ls/hL05/44nmHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498218; c=relaxed/simple;
	bh=GCyEyVvXc3Laf0pnbgcHa3A1QMVt9LjNiQw4ZM/lORw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMUv8A//uw+0lbLvAvBXPoPrQ1ooOQB/GZwzAOkl7O94IKALGK+0Jw4udCHSkoDokpe99/rQEGRZSetOFD+FUpag4m9Df4T7yi7kNRzLF60VYtGaRHrrCipKHzxp09mkz56jAPwt7irSubx+/Mels74VJFpIcwU8G7oTxp9Blwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4UpiOnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4UpiOnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A64C116D0;
	Thu, 15 Jan 2026 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498218;
	bh=GCyEyVvXc3Laf0pnbgcHa3A1QMVt9LjNiQw4ZM/lORw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4UpiOnF2wvi3bU0aVBsdKDBJQwwZe7QCw+1S+VQLjwEVoOP4Kq5eI0Ju0hzxMoS7
	 EfQsuQfhhkeE2vL1ZV1YASBjJlszbIyyw5stA+AS4d+vXaE7B/xQMDBmwkm2EPm/OS
	 61hhB4SoitA8qFcjbCFiLdr0uRiBR4o6KwGGLXS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiyuan Xie <xiejiyuan@vivo.com>,
	Zhichi Lin <zhichi.lin@vivo.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Will Deacon <will@kernel.org>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Marco Elver <elver@google.com>,
	Yee Lee <yee.lee@mediatek.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 311/554] scs: fix a wrong parameter in __scs_magic
Date: Thu, 15 Jan 2026 17:46:17 +0100
Message-ID: <20260115164257.487684465@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhichi Lin <zhichi.lin@vivo.com>

commit 08bd4c46d5e63b78e77f2605283874bbe868ab19 upstream.

__scs_magic() needs a 'void *' variable, but a 'struct task_struct *' is
given.  'task_scs(tsk)' is the starting address of the task's shadow call
stack, and '__scs_magic(task_scs(tsk))' is the end address of the task's
shadow call stack.  Here should be '__scs_magic(task_scs(tsk))'.

The user-visible effect of this bug is that when CONFIG_DEBUG_STACK_USAGE
is enabled, the shadow call stack usage checking function
(scs_check_usage) would scan an incorrect memory range.  This could lead
to:

1. **Inaccurate stack usage reporting**: The function would calculate
   wrong usage statistics for the shadow call stack, potentially showing
   incorrect value in kmsg.

2. **Potential kernel crash**: If the value of __scs_magic(tsk)is
   greater than that of __scs_magic(task_scs(tsk)), the for loop may
   access unmapped memory, potentially causing a kernel panic.  However,
   this scenario is unlikely because task_struct is allocated via the slab
   allocator (which typically returns lower addresses), while the shadow
   call stack returned by task_scs(tsk) is allocated via vmalloc(which
   typically returns higher addresses).

However, since this is purely a debugging feature
(CONFIG_DEBUG_STACK_USAGE), normal production systems should be not
unaffected.  The bug only impacts developers and testers who are actively
debugging stack usage with this configuration enabled.

Link: https://lkml.kernel.org/r/20251011082222.12965-1-zhichi.lin@vivo.com
Fixes: 5bbaf9d1fcb9 ("scs: Add support for stack usage debugging")
Signed-off-by: Jiyuan Xie <xiejiyuan@vivo.com>
Signed-off-by: Zhichi Lin <zhichi.lin@vivo.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yee Lee <yee.lee@mediatek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/scs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -121,7 +121,7 @@ static void scs_check_usage(struct task_
 	if (!IS_ENABLED(CONFIG_DEBUG_STACK_USAGE))
 		return;
 
-	for (p = task_scs(tsk); p < __scs_magic(tsk); ++p) {
+	for (p = task_scs(tsk); p < __scs_magic(task_scs(tsk)); ++p) {
 		if (!READ_ONCE_NOCHECK(*p))
 			break;
 		used += sizeof(*p);


