Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D75E2417DE;
	Thu, 17 Sep 2026 18:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671008; cv=none; b=Tlu67FlQZ9g/EMq9PvJ3j7kHSb2siHHaqJt59rk2PmoWRvjqNHaQGnJ3hw4pgmKG5NVoeVNElmmlR+yZq0B/0mYOWAAiUGgmCuBlvPSFa9/9Uiq8obUCyAfgvqOoLqAulTmOGcmsL23nyamrP5Elg+bfdM0Qh8AWUGX8Xd4OlUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671008; c=relaxed/simple;
	bh=cg2tDUuUFoJNDrE42mSgErQJ7kHBfSHp2TTcLsE2YzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=queT+zSFXC3WsQkyce50tLpPBA1EzQJPTxHnNuub6YiZcBbnLlwFADmbW1gV9uW9Z3HgsMCbw7b8Ksrihr8HeTnM6Ec8ozaq2yqTvUEV2bLYNykth5d4Rz5fnXSPU99cnHYKhy/V8xl1Loq426b9pDOov3NoqkAUGCRwxzpwtvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuIrA62i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuIrA62i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68FB1F000FF;
	Thu, 17 Sep 2026 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671007;
	bh=azEEzA2RkDmqs3DpgayJJtaYNqJai9I3AELc0C0YbGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuIrA62iBfYNdDgVN2odzg3cIGYU22k3LxP/f27bCfPUqfyzP21R2Ncjeu+FUQqoV
	 a7BpauGzqZ9ljOiKzz+m05EwQ9mQAw5lrYZ3expzYxp9vw8YokXXU0JNuMTBvG8SoF
	 tfxoy0EbSyPsrzEwmwo57bYao21i9U6XvJSzDuks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 0802/1102] powerpc/ps3: Fix repository.c build failure
Date: Thu, 17 Sep 2026 16:12:25 +0100
Message-ID: <20260917151600.612183933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/powerpc/platforms/ps3/repository.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/ps3/repository.c
+++ b/arch/powerpc/platforms/ps3/repository.c
@@ -6,6 +6,8 @@
  *  Copyright 2006 Sony Corp.
  */
 
+#include <linux/minmax.h>
+
 #include <asm/lv1call.h>
 
 #include "platform.h"
@@ -74,8 +76,9 @@ static void _dump_node(unsigned int lpar
 static u64 make_first_field(const char *text, u64 index)
 {
 	u64 n = 0;
+	size_t len = min(strlen(text), sizeof(n));
 
-	memcpy((char *)&n, text, strnlen(text, sizeof(n)));
+	memcpy(&n, text, len);
 	return PS3_VENDOR_ID_NONE + (n >> 32) + index;
 }
 


