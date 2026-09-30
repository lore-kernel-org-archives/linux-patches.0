Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8855734E75A;
	Wed, 30 Sep 2026 19:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795541; cv=none; b=gL0tGcP5R2hGGafUcU8SUkVmmnzfjemlKdXGPmLcOkTZ3Hv9SE0Gf9q3obbLpaJw60cSNcQq+/4qhtUO92LgzOeRWHArI+zw+sEqVFKXpEv26KcuWhTO+T+K6APNET4UVIn8hXoyZQhUPskjakYNnK/D1HPWQ8uJaIfVGbRLTuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795541; c=relaxed/simple;
	bh=rtvqPBtqkrRQvsYPAH4D3Wk5z0mgIViKqT7Vlt+ZL6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZZy9cwFOwpUP63If1QvktupEbqhOVhJLIJtp8IHOhaR/vH3wXZwYD5iYrTP8Bfjk0guvTtunNpaXOJBph+dEFwabhnBG+tQhsk2xFPYKcff/px0+47sw2qjEWQZQ/Ise84901CKx5EGGLtMfkT4dja/PPjuT1vqJml3ZkDE8Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOa03gXY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOa03gXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F1A1F000FF;
	Wed, 30 Sep 2026 19:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795540;
	bh=0HZDTY0euGNmK7vuSQQ3BOHw93TUpT16ZDOby+wS/qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOa03gXYd9VJ9dQsnaVG34ubWfkfeV6/pHXm4E1uCl9JnYAWtVUvvH+44xlJCh4Lp
	 suhUgLutwx5g1UOuLnU4POt/2uAW35C2c2W9IK5UhcZI7/Nf0sDpMniB0NsWjrU9xq
	 oVqDI3Yf0SfMkEnCw8FerMsjgKuTpP60eMYM3HAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 0596/1193] powerpc/ps3: Fix repository.c build failure
Date: Wed, 30 Sep 2026 17:21:20 +0200
Message-ID: <20260930152447.485366508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 5ba79d37403d86082ab4083b0f51ec3008a942cb upstream.

GCC fails to build ps3_defconfig with the following errors:

  arch/powerpc/platforms/ps3/repository.c: In function ‘make_first_field.constprop’:
  arch/powerpc/platforms/ps3/repository.c:78:9: error: ‘strnlen’ specified bound 8 exceeds source size 3 [-Werror=stringop-overread]
     78 |         memcpy((char *)&n, text, strnlen(text, sizeof(n)));
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  arch/powerpc/platforms/ps3/repository.c: In function ‘make_first_field.constprop’:
  arch/powerpc/platforms/ps3/repository.c:78:9: error: ‘strnlen’ specified bound 8 exceeds source size 4 [-Werror=stringop-overread]
     78 |         memcpy((char *)&n, text, strnlen(text, sizeof(n)));
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The current use of strnlen(text, sizeof(n)) triggers -Wstringop-overread
when text is a short string literal that is smaller than sizeof(n), such
as "bi" or "bus". Use strlen(text) instead and clamp the copy length to
sizeof(n) before memcpy().

Drop the redundant char * cast while at it.

Fixes: f94a84a09148 ("powerpc/ps3: refactor strncpy usage")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260703165834.137242-2-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/ps3/repository.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/ps3/repository.c b/arch/powerpc/platforms/ps3/repository.c
index b8c030eab138..0cc755ac3e7f 100644
--- a/arch/powerpc/platforms/ps3/repository.c
+++ b/arch/powerpc/platforms/ps3/repository.c
@@ -6,6 +6,8 @@
  *  Copyright 2006 Sony Corp.
  */
 
+#include <linux/minmax.h>
+
 #include <asm/lv1call.h>
 
 #include "platform.h"
@@ -74,8 +76,9 @@ static void _dump_node(unsigned int lpar_id, u64 n1, u64 n2, u64 n3, u64 n4,
 static u64 make_first_field(const char *text, u64 index)
 {
 	u64 n = 0;
+	size_t len = min(strlen(text), sizeof(n));
 
-	memcpy((char *)&n, text, strnlen(text, sizeof(n)));
+	memcpy(&n, text, len);
 	return PS3_VENDOR_ID_NONE + (n >> 32) + index;
 }
 
-- 
2.55.0



