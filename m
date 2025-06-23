Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712446136;
	Mon, 23 Jun 2025 21:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714620; cv=none; b=fUa1JUysHxRYpAdV9rZOrP0I4Vg2OqqoOJF3N4AN3pJGkWXpQLZ7IGcRKZvuKgo/tQeGjIBJ2iM9xppYYR5fg6kK8KmXRYVlpdNXGda1TiMntQrmAcJlmI3P6gdGCn3nZCt0ZjEPgVpPuBx2ZHdqHVGjG9GtUxG9WjM7usk4DKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714620; c=relaxed/simple;
	bh=AI87afpOE3k6NF9EdDO868TCooyUiFBF6/9qnVD27DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0DXgMZeuuV9hFOF5EvTe711wqV8UJMSmGVWh4l/XGfhBW7vM6rYTtwCG5W1iwnN/vVKiPQeAtlehFyV9yO9EUsM3HKioPiuAAyhK2FTXVy1bJyQV0kysVs1T1ooa+BIPXySn/cg8/XhyuQEprj0ykHBawJGEtELD6D3KPat6FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my3R+AQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my3R+AQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EE4C4CEEA;
	Mon, 23 Jun 2025 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714620;
	bh=AI87afpOE3k6NF9EdDO868TCooyUiFBF6/9qnVD27DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=my3R+AQtBDyLSnVNnIRRHTPrruSoPrd2V6ARQaXynsJGZnzNQN6dmr1zxwuS1Vgp5
	 DSwQuJiS/7O/rJP7bsIOGQbk3/Y+Ac3vmUbUjvwRowcjIFvXJXN/gE9gXGo2NjRHBz
	 s24PXqYOwtrxUmU62q9A/px/hWtql0gi9nBiioTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 112/414] parisc: fix building with gcc-15
Date: Mon, 23 Jun 2025 15:04:09 +0200
Message-ID: <20250623130644.890402284@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Arnd Bergmann <arnd@arndb.de>

commit 7cbb015e2d3d6f180256cde0c908eab21268e7b9 upstream.

The decompressor is built with the default C dialect, which is now gnu23
on gcc-15, and this clashes with the kernel's bool type definition:

In file included from include/uapi/linux/posix_types.h:5,
                 from arch/parisc/boot/compressed/misc.c:7:
include/linux/stddef.h:11:9: error: cannot use keyword 'false' as enumeration constant
   11 |         false   = 0,

Add the -std=gnu11 argument here, as we do for all other architectures.

Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/boot/compressed/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/boot/compressed/Makefile
+++ b/arch/parisc/boot/compressed/Makefile
@@ -18,6 +18,7 @@ KBUILD_CFLAGS += -fno-PIE -mno-space-reg
 ifndef CONFIG_64BIT
 KBUILD_CFLAGS += -mfast-indirect-calls
 endif
+KBUILD_CFLAGS += -std=gnu11
 
 LDFLAGS_vmlinux := -X -e startup --as-needed -T
 $(obj)/vmlinux: $(obj)/vmlinux.lds $(addprefix $(obj)/, $(OBJECTS)) $(LIBGCC) FORCE


