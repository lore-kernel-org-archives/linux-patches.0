Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C414FB676;
	Mon, 23 Jun 2025 22:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716952; cv=none; b=DhEeo7MPzujmuPiBDCZ/0U8L/2p+Gb/hfV5efcLkmfKj0hjHTLRWrcTJQ+lROimNBlQd30vw7QMl18xaREoinifNNz08Gv1+79xhy+Xtd3qA2o++p41nc3WFMI0uVz+RJv0Is0+WwqI9/CzUU07the1BIOQLYz9ck9V6ezrabIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716952; c=relaxed/simple;
	bh=uMD1aua5Bx4gTj60V2HB2kbCr4m0X49dju0tnsmOzUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2pK6ZmY44GY/fM3ehfFAKB5FHd1QTfuy4AZsXsvEA4c9Rqsrn9jynsoPllOm7wH9puwqzj8diA58J5hUgJ44FHziOrjpj1eORhHmRIUcU9KN8ypiS5SP65ostQlDKh+RBsdCO7zbickmK12yYuLBq5GpHdMCQcxk2Iy7KyA7HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgDOLyBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgDOLyBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C003C4CEEA;
	Mon, 23 Jun 2025 22:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716952;
	bh=uMD1aua5Bx4gTj60V2HB2kbCr4m0X49dju0tnsmOzUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgDOLyBonAWerasDIyL3693qad+MlYVpPqSoHuIqHmaKUHUYAdMn3xlsA4jT9asaX
	 +4uw2y2QQDyR+7RlRxLYlaCgEgSBLGJxW45I0Xo2hyh2met5WiuPjMxPVocqYeOuJ0
	 wSwMJsYP7Jh57nvSFF/Phjjp1wFp/Sn2tlIBuQPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 348/508] parisc: fix building with gcc-15
Date: Mon, 23 Jun 2025 15:06:33 +0200
Message-ID: <20250623130653.912522069@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -22,6 +22,7 @@ KBUILD_CFLAGS += -fno-PIE -mno-space-reg
 ifndef CONFIG_64BIT
 KBUILD_CFLAGS += -mfast-indirect-calls
 endif
+KBUILD_CFLAGS += -std=gnu11
 
 LDFLAGS_vmlinux := -X -e startup --as-needed -T
 $(obj)/vmlinux: $(obj)/vmlinux.lds $(addprefix $(obj)/, $(OBJECTS)) $(LIBGCC) FORCE


