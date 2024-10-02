Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373A229CE7;
	Wed,  2 Oct 2024 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875949; cv=none; b=fk1riLaq8ore3jdCTddgCOGByfS2gntP0dNb5QthJbpYHR+63m0qG2eisiXZv+BcamZPfj53xvU39XmID4coHIC1xc2qopTOZzuygqLfppuA0Z7EFD5fvIjBZCVB4ZfS5I0+OzK8rpOiyVLPS/MCM8APsHBuD8i7nbaufMmT1kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875949; c=relaxed/simple;
	bh=Ofq69ArRMN4a9UX1xBA2idVKIJS/+sX3GZ/uGq/SkGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5mIsrxKmb1VY3J/W68Pxq8BBfs2fQH69IgjLtAsPWH46wqf4hwbIcBd8+810PYiWfyoM4FCagXSloOgsquUqt3lnciXHwX+fGAFxaN0jOmWUVacb/ADlhH4bbDepb9PkY5kJI9SHnDWGPDg24kzw9yKSh3fdpK9PbrXRX5eZgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOU92/w2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOU92/w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B19C4CEC5;
	Wed,  2 Oct 2024 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875949;
	bh=Ofq69ArRMN4a9UX1xBA2idVKIJS/+sX3GZ/uGq/SkGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOU92/w2d0ERU0OkmyBaz3BbDyMYjNsWj50YyktI0vPE93BBUiMG9FKAG4DQ6GKHB
	 +gEIqQDMeiywJe8YeXf9uvvAryppKD77afFkQ0CcTjjKKRc2IiKG2rYVfLtj2l/T3y
	 BfYfUBgYwrR+5K8daorqovs6OOrOQg7KRsOIjsVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 276/695] selftests/bpf: Fix compiling core_reloc.c with musl-libc
Date: Wed,  2 Oct 2024 14:54:34 +0200
Message-ID: <20241002125833.462494440@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit debfa4f628f271f72933bf38d581cc53cfe1def5 ]

The type 'loff_t' is a GNU extension and not exposed by the musl 'fcntl.h'
header unless _GNU_SOURCE is defined. Add this definition to fix errors
seen compiling for mips64el/musl-libc:

  In file included from tools/testing/selftests/bpf/prog_tests/core_reloc.c:4:
  ./bpf_testmod/bpf_testmod.h:10:9: error: unknown type name 'loff_t'
     10 |         loff_t off;
        |         ^~~~~~
  ./bpf_testmod/bpf_testmod.h:16:9: error: unknown type name 'loff_t'
     16 |         loff_t off;
        |         ^~~~~~

Fixes: 6bcd39d366b6 ("selftests/bpf: Add CO-RE relocs selftest relying on kernel module BTF")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/11c3af75a7eb6bcb7ad9acfae6a6f470c572eb82.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 47f42e6801056..26019313e1fc2 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include "progs/core_reloc_types.h"
 #include "bpf_testmod/bpf_testmod.h"
-- 
2.43.0



