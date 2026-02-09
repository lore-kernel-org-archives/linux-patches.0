Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C238036828A;
	Mon,  9 Feb 2026 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648203; cv=none; b=lSUoGqBaFAnfBm6mMv9HaNqgz3EPFOfo/I6IxFp7dHQayZZR5bN7id9rdcIKm8qFDpe+944BpQlPiPuDt/yrvs+fBZAKMr7BAEfIMsa04NaieE9LA4K5Ea3n17iklqoCLx0csgX8HYb3PsiaCtur/wZzNRTo6tT5TB5iYWrzZlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648203; c=relaxed/simple;
	bh=FIgOvMkoAWHNU897lNmJoNY0xSV3TcFb0xgJWUYSwhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h5dAkExJVEGZguokdoBSoxZK+Ah2GdNyHPEKeyWxnKDq27AI/VlbZqowyhQfJUqfWSgBIAtCHu5Ivdd7dsf5VDecA1jftw0ZKkJgMvLmd8OSWVx5/75EfKLmxOUYMD00l1xFeX//BbDX/k1DmG9ilzrZac2+PtS2Gk4py2LfS/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BngZs/ZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BngZs/ZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E04C19422;
	Mon,  9 Feb 2026 14:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648203;
	bh=FIgOvMkoAWHNU897lNmJoNY0xSV3TcFb0xgJWUYSwhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BngZs/ZUZKrNW3DEaIqTnYI9xF66W2qWpZVXSt4V0KdVhjizmIzG0PrpD7+aC0o5j
	 aMC2o96vSXVHCYGQypuGIKN5o4ubJAkh0CntFLrmNVEWfQo71nOhGKI2xabUzBoP2q
	 YooDCxPHHsQL1x03BBUK0JSqxKKYX8ofRkq9ysRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.1 05/69] ARM: 9468/1: fix memset64() on big-endian
Date: Mon,  9 Feb 2026 15:23:33 +0100
Message-ID: <20260209142302.110291679@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weissschuh <thomas.weissschuh@linutronix.de>

commit 23ea2a4c72323feb6e3e025e8a6f18336513d5ad upstream.

On big-endian systems the 32-bit low and high halves need to be swapped
for the underlying assembly implementation to work correctly.

Fixes: fd1d362600e2 ("ARM: implement memset32 & memset64")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/string.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm/include/asm/string.h
+++ b/arch/arm/include/asm/string.h
@@ -42,7 +42,10 @@ static inline void *memset32(uint32_t *p
 extern void *__memset64(uint64_t *, uint32_t low, __kernel_size_t, uint32_t hi);
 static inline void *memset64(uint64_t *p, uint64_t v, __kernel_size_t n)
 {
-	return __memset64(p, v, n * 8, v >> 32);
+	if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
+		return __memset64(p, v, n * 8, v >> 32);
+	else
+		return __memset64(p, v >> 32, n * 8, v);
 }
 
 /*


