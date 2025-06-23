Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C651023BF9F;
	Mon, 23 Jun 2025 13:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684616; cv=none; b=eHeCcP0IuaVD4QEXIXADJO9Xg3aM0AvPeu5tVxaEeRk4glu7zvSr5rSUzckV1YmToqZSIY5fW6lKK0Q9GM3NJ/oNGHM8AumbMkVUmD/zVoVq0vye1wVZe7Hy4J4VNKTeNEn9BR6WdKF1U6dFnJf64j/aFUXJMuLdK9YquHIlWbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684616; c=relaxed/simple;
	bh=gbM7kOwXXWs2FUC4mOem9SLn2OqJEemdRv8D9j/A9m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rlpb6N9AXodPzjgKOZjU02Nt1JT8sus/ei2cvhuKu7mWFAF3hinugmqQKH63DnOv4uw0V0XoRkSt23JK84d8JebrV44gYOfg7/TY1mf9fEVQMXZeRlfi+QA1TEwAtiDfYwQj3qBuTUZqoRDfNeK5slMFW4ggHuvRUp9Aq9Ts/YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mas+HJNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mas+HJNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C28C4CEEA;
	Mon, 23 Jun 2025 13:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684616;
	bh=gbM7kOwXXWs2FUC4mOem9SLn2OqJEemdRv8D9j/A9m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mas+HJNOzKK3K4YAvWXt1XYv92b3B1x/8x/Rya2ShlIcD+qZWqcIs21EiOkvQE+o9
	 eKsgJvRnSfoXCR0yfGCAKVHAfRMN51koHUh6DZMgLCfjxf4hKaNE4WPORVxdE3VEO6
	 +FIYYaKARrY6KfqO2J0isg1kO+KOTo5JBSmkbz6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.15 136/592] parisc: fix building with gcc-15
Date: Mon, 23 Jun 2025 15:01:34 +0200
Message-ID: <20250623130703.507416973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


