Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27AD4E06F5;
	Thu, 17 Sep 2026 17:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666183; cv=none; b=FjOF4K+3sM1MjYhJLkZYXRzMJVY+JqMkUK542FD9v3WyqvNpfkl7F5Lo6LoNaCs1GMvUgZ8nCb0vhrSY/APbXrQ26TfAiOTtvEa3vI6hG03spKm1DJZNZty+UHxvVt4CAGF8tjAyWlL22Ni5VjHLn7buLE37SwcpF2kLnMgJKFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666183; c=relaxed/simple;
	bh=uOMTN0u6Lrg1ubVBdXOUI7ZpzmHGf+5A+CCYCX7ShOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7D39XkFhhUagk1LK0pv+QokHpwMlekjkKex+SdO0sHILgJkSnyVOJhe1KB6ALPkvqyJcp+rm8cWdFLCGWoBr4PlAXvh2N9bJJRXZV7A5xWxfK97kTarsrbB6DJLuGWZaIE0tPL1lGG1jYbPT21bWKMhmYxVBhs/F06XEbrkvxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0vj4HGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0vj4HGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C561F000FF;
	Thu, 17 Sep 2026 17:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666182;
	bh=yVoJLLGvvrXcKnCxLNL6J//nVxTU4a7oQ0hhX+XfCqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0vj4HGmSLZe6N4johZS7XeIsPRmVPFkys5uo45StcesoYiJNL0p/9iGH1Eb5ec8F
	 NCtnmLiQUiOZXZC56Y05Ljej0uUOcphxaAZ3bDJutVlj/PyvuLSaFsd9ZrKTyou2GW
	 HjhEL9tEh6sopN9365Z5+C0AMQ2amEt5EFkFIR7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 0953/1250] powerpc/ps3: Fix repository.c build failure
Date: Thu, 17 Sep 2026 16:12:28 +0100
Message-ID: <20260917151617.850923539@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


