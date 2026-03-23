Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41252242D9D;
	Mon, 23 Mar 2026 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277163; cv=none; b=m4epD6z2B8/UXgTJ/85QUN60/Ks2pUbu9rGHD5MK9iQcYcNbiX1c2qXskBwszzLzRG27+zLLm1hZwghLIkQjfhChSn62vmdxAUpqnwUB8kYLwhypcfohEfsLbjd6RsE7ynzFdvIpSozidWAGDvGevDEc04tgWYUM/y2DY1vSuJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277163; c=relaxed/simple;
	bh=gSa16JcweLt+E+idJuUVOSthMS+PzTNXVusOKdWzQA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6k1szmn1i2J2eYQM3ODHUqrP3d3O9sC7iKd+Ttp8fgnLseCMIf/CoH01OXPwthNmFqNFzPAwYEi7VutmigWuJm/WnQSAuOahrc6LhmWf8duSwYftOi8WxU923THDUdEM5hzPBCwcySEAWsoXhYL8+IYHdyvOG1BUFXWY8EAlt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5lA6fev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5lA6fev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B7BC4CEF7;
	Mon, 23 Mar 2026 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277163;
	bh=gSa16JcweLt+E+idJuUVOSthMS+PzTNXVusOKdWzQA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5lA6fevlfUa/DCqp8L96YrZe1Zg5OgFNvCo30SyXPb0p4dgPS1aaZY6GPy/QCXzT
	 9u6GBfyvLsWkP8GOXt4ZMEMCYSgS1c/HZLaqGfDqFQwd7ZzQVzX1eqzkCJCy78yO1m
	 BwNgkC4lOlLeOtOAjIzlecf2b3/9LBxi3uKjelfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	Finn Thain <fthain@linux-m68k.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 342/460] mtd: Avoid boot crash in RedBoot partition table parser
Date: Mon, 23 Mar 2026 14:45:38 +0100
Message-ID: <20260323134534.939071120@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

commit 8e2f8020270af7777d49c2e7132260983e4fc566 upstream.

Given CONFIG_FORTIFY_SOURCE=y and a recent compiler,
commit 439a1bcac648 ("fortify: Use __builtin_dynamic_object_size() when
available") produces the warning below and an oops.

    Searching for RedBoot partition table in 50000000.flash at offset 0x7e0000
    ------------[ cut here ]------------
    WARNING: lib/string_helpers.c:1035 at 0xc029e04c, CPU#0: swapper/0/1
    memcmp: detected buffer overflow: 15 byte read of buffer size 14
    Modules linked in:
    CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.19.0 #1 NONE

As Kees said, "'names' is pointing to the final 'namelen' many bytes
of the allocation ... 'namelen' could be basically any length at all.
This fortify warning looks legit to me -- this code used to be reading
beyond the end of the allocation."

Since the size of the dynamic allocation is calculated with strlen()
we can use strcmp() instead of memcmp() and remain within bounds.

Cc: Kees Cook <kees@kernel.org>
Cc: stable@vger.kernel.org
Cc: linux-hardening@vger.kernel.org
Link: https://lore.kernel.org/all/202602151911.AD092DFFCD@keescook/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Kees Cook <kees@kernel.org>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/parsers/redboot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/parsers/redboot.c
+++ b/drivers/mtd/parsers/redboot.c
@@ -270,9 +270,9 @@ nogood:
 
 		strcpy(names, fl->img->name);
 #ifdef CONFIG_MTD_REDBOOT_PARTS_READONLY
-		if (!memcmp(names, "RedBoot", 8) ||
-		    !memcmp(names, "RedBoot config", 15) ||
-		    !memcmp(names, "FIS directory", 14)) {
+		if (!strcmp(names, "RedBoot") ||
+		    !strcmp(names, "RedBoot config") ||
+		    !strcmp(names, "FIS directory")) {
 			parts[i].mask_flags = MTD_WRITEABLE;
 		}
 #endif


