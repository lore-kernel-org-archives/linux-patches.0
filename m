Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319D63B9DA2;
	Mon, 23 Mar 2026 15:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278983; cv=none; b=qjS3/Lsr4XN9vIPN+/SSaoS/KWTMzQodil7heyvz1OfFH/aI3w8bqnnwg7g6MFVEz5jXB1wdpRaXN05zScM2qlnY0YV3H3LvjEd5ETKEFh4ULuYhIVCJLKTE6L1XEjaykxOqvhJNfxBU2CDm/19ZXQGWMRh3zEURbtN8y1wDmwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278983; c=relaxed/simple;
	bh=BiTz4gjRO1H5onjj5Zt1lmpMuqZfRAD0kWdE90acyAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mthuCmrZLwHFSONfd0RJnuycG+gS7gxPiXdny3atS8x8mwrzQ6ffwaCnBFNuJ0cPgBa25PGdk04s3rDCqxj3ft2O+OW/Y8h/fEDUrpydNVMQSnBTLS16zbjEAuU2YsHITrC3qzY01eXkQmoqprt/stYr2+naZlbIqwS1rnBFhoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEiGZBbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEiGZBbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF002C4CEF7;
	Mon, 23 Mar 2026 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278983;
	bh=BiTz4gjRO1H5onjj5Zt1lmpMuqZfRAD0kWdE90acyAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEiGZBbNqH+QhsxUIqiJ7f/D0r3G11ZQ9IXz/aNG0QxhnAPVTe6LOcud0usGakIqF
	 /57I1aXMQ69bDecVKVGdiE7+mwFBbs3TMA8PYq2Y1OCURXBrVHHVxF7zMJZWAfzv6g
	 y4IuzzgWEkN4AoL+PFQgII//1lunXK37vT5j7ls4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	Finn Thain <fthain@linux-m68k.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 481/567] mtd: Avoid boot crash in RedBoot partition table parser
Date: Mon, 23 Mar 2026 14:46:41 +0100
Message-ID: <20260323134545.880030421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


