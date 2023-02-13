Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737318F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E54C433D2;
	Mon, 13 Feb 2023 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300300;
	bh=gC3rWtyoNiyAOpriVBS0nnAfJ/cJrEw8adVRNTvHG/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akW3E4BgtFd4iW1qTA3IUuuLRhbqXK0oO58l5X4HusloT2os8JxeYRNeL2LevQJQC
	 Yt/xlV4WpzcuUyqYNUlSoVqoo4b544RBnTcVgKSwvkyGAvxTKn287IVllgiREKMOGc
	 S1cmCj187emJSjxw7wEeI4lPJxkTm6s34yrhy6Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Herton R. Krzesinski" <herton@redhat.com>,
	Carlos ODonell <carlos@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 26/67] uapi: add missing ip/ipv6 header dependencies for linux/stddef.h
Date: Mon, 13 Feb 2023 15:49:07 +0100
Message-Id: <20230213144733.621397215@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herton R. Krzesinski <herton@redhat.com>

[ Upstream commit 03702d4d29be4e2510ec80b248dbbde4e57030d9 ]

Since commit 58e0be1ef6118 ("net: use struct_group to copy ip/ipv6
header addresses"), ip and ipv6 headers started to use the __struct_group
definition, which is defined at include/uapi/linux/stddef.h. However,
linux/stddef.h isn't explicitly included in include/uapi/linux/{ip,ipv6}.h,
which breaks build of xskxceiver bpf selftest if you install the uapi
headers in the system:

$ make V=1 xskxceiver -C tools/testing/selftests/bpf
...
make: Entering directory '(...)/tools/testing/selftests/bpf'
gcc -g -O0 -rdynamic -Wall -Werror (...)
In file included from xskxceiver.c:79:
/usr/include/linux/ip.h:103:9: error: expected specifier-qualifier-list before ‘__struct_group’
  103 |         __struct_group(/* no tag */, addrs, /* no attrs */,
      |         ^~~~~~~~~~~~~~
...

Include the missing <linux/stddef.h> dependency in ip.h and do the
same for the ipv6.h header.

Fixes: 58e0be1ef611 ("net: use struct_group to copy ip/ipv6 header addresses")
Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
Reviewed-by: Carlos O'Donell <carlos@redhat.com>
Tested-by: Carlos O'Donell <carlos@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/ip.h   | 1 +
 include/uapi/linux/ipv6.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index d2f143393780c..860bbf6bf29cb 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -18,6 +18,7 @@
 #ifndef _UAPI_LINUX_IP_H
 #define _UAPI_LINUX_IP_H
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <asm/byteorder.h>
 
 #define IPTOS_TOS_MASK		0x1E
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 62e5e16ef539d..39c6add59a1a6 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -4,6 +4,7 @@
 
 #include <linux/libc-compat.h>
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <linux/in6.h>
 #include <asm/byteorder.h>
 
-- 
2.39.0



