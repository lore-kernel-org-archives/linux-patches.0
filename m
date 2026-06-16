Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B8837C912;
	Tue, 16 Jun 2026 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623665; cv=none; b=EjhcJr13joCq/NgG8nPOm487k+5Yxl5Vbc01RD/M5AmBw1gB+E/XTYwl2fn0fsRyJ0sHKHKs0MTQ75ChOeNhKKTi/WCyDXppkwDQt010lHcWEvN7d2AXmBlxdWamS9/KkZsgH7NUGUqbbOh+Ojq09Fsi2sRpbasRfALzLseNatk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623665; c=relaxed/simple;
	bh=I1tKj5yFxyi0kEwuX+U47wgb6oFnQOEyKfloF/lpvVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLl4h/hCis/Y0Xt0134j1X7Aem6yxFjSL7F9vfDiYc0Vqs0Pju0tRSYXapwi9e4fW0/hitt7Ybn81fTSgY43Edp+l4Z7TtRBjJvRRPgq57KnNGIvYU90SRa+xYch7rQ2+nZcSh29EjmHvC4OjjS8DO4e2VSslRepjwsdl3ANih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpMf23Zh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpMf23Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3DB1F000E9;
	Tue, 16 Jun 2026 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623664;
	bh=/vNpK+Si4HszgvXwo8DBi7XQ4jcyRxuuxVoYHn8nDkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LpMf23Zhz8YSeEIF6Htwja5F5EPzGPXBOrleTEQU89ijnodLbZPqJtQB2xMBpTLBY
	 aqm5mgTSXoliz+tyfOQRKEIHE1YxRs3E7PFNlaCoLPgnzJgDXsXisyEX8s9EEQ4reT
	 pjWYTnOUeebQGbijwkF0uiWBcqggExbdzXDdz740=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 7.0 193/378] cfi: Include uaccess.h for get_kernel_nofault()
Date: Tue, 16 Jun 2026 20:27:04 +0530
Message-ID: <20260616145120.542363679@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 979c294509f9248fe1e7c358d582fb37dd5ca12d upstream.

After commit 0652a3daa787 ("tracing: Fix CFI violation in probestub
being called by tprobes"), there are many build errors when building
ARCH=arm multi_v7_defconfig + CONFIG_CFI=y like:

  In file included from drivers/base/devres.c:17:
  In file included from drivers/base/trace.h:16:
  In file included from include/linux/tracepoint.h:23:
  include/linux/cfi.h:44:6: error: call to undeclared function 'get_kernel_nofault'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     44 |         if (get_kernel_nofault(hash, func - cfi_get_offset()))
        |             ^
  1 error generated.

get_kernel_nofault() is called in the generic version of
cfi_get_func_hash() but nothing ensures uaccess.h is always included for
a proper expansion and prototype.  Include uaccess.h in cfi.h to clear
up the errors.

Cc: stable@vger.kernel.org
Fixes: 0652a3daa787 ("tracing: Fix CFI violation in probestub being called by tprobes")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cfi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/cfi.h b/include/linux/cfi.h
index 1fd22ea6eba4..0f220d29225c 100644
--- a/include/linux/cfi.h
+++ b/include/linux/cfi.h
@@ -9,6 +9,7 @@
 
 #include <linux/bug.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 #include <asm/cfi.h>
 
 #ifdef CONFIG_CFI
-- 
2.54.0



