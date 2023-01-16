Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2F06FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541C6C433EF;
	Mon, 16 Jan 2023 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888919;
	bh=iipozZfwKxuvFHMN2/LylZ200fRqCNZUPm8J4aIeik0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAChVNm7L2YvOJQkfz6yqiNz8KgbIy3ZGJsl0fRvXgZZIUDACPOJrkwg3FSPb4kn3
	 xPdRS1jbqFWnm4PDLdgVmuw83y5rGREltyKvqOMmWMmCYGevStVTg+A2Nm50Reoq6H
	 EROM1NpNsZSTShaZDnZmZUE2dzx2AavOoY7oQUdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Redfearn <matt.redfearn@mips.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	=?UTF-8?q?Petr=20Van=C4=9Bk?= <arkamar@atlas.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 190/338] include/uapi/linux/swab: Fix potentially missing __always_inline
Date: Mon, 16 Jan 2023 16:51:03 +0100
Message-Id: <20230116154829.222255143@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matt Redfearn <matt.redfearn@mips.com>

[ Upstream commit defbab270d45e32b068e7e73c3567232d745c60f ]

Commit bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining
of some byteswap operations") added __always_inline to swab functions
and commit 283d75737837 ("uapi/linux/stddef.h: Provide __always_inline to
userspace headers") added a definition of __always_inline for use in
exported headers when the kernel's compiler.h is not available.

However, since swab.h does not include stddef.h, if the header soup does
not indirectly include it, the definition of __always_inline is missing,
resulting in a compilation failure, which was observed compiling the
perf tool using exported headers containing this commit:

In file included from /usr/include/linux/byteorder/little_endian.h:12:0,
                 from /usr/include/asm/byteorder.h:14,
                 from tools/include/uapi/linux/perf_event.h:20,
                 from perf.h:8,
                 from builtin-bench.c:18:
/usr/include/linux/swab.h:160:8: error: unknown type name `__always_inline'
 static __always_inline __u16 __swab16p(const __u16 *p)

Fix this by replacing the inclusion of linux/compiler.h with
linux/stddef.h to ensure that we pick up that definition if required,
without relying on it's indirect inclusion. compiler.h is then included
indirectly, via stddef.h.

Fixes: 283d75737837 ("uapi/linux/stddef.h: Provide __always_inline to userspace headers")
Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Petr Vaněk <arkamar@atlas.cz>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/swab.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
index 7272f85d6d6a..3736f2fe1541 100644
--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -3,7 +3,7 @@
 #define _UAPI_LINUX_SWAB_H
 
 #include <linux/types.h>
-#include <linux/compiler.h>
+#include <linux/stddef.h>
 #include <asm/bitsperlong.h>
 #include <asm/swab.h>
 
-- 
2.35.1



