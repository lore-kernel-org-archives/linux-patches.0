Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6106428725B;
	Mon,  9 Feb 2026 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648663; cv=none; b=L6/7FWWno+iwR/ZR5TJVjJgyOmZz3lY/7pVT3enh5wPRdWUsH2yFxOG9RPh1BZcCHjrG94ZYXCqq0wjnyRp07kTTHgy6mgvewXWwb/VnpSgseV6yszTkwWmAX0nNEmlopIZeLIctfj72jVe6YkUZ1feqMoAj/wX2OhRscyUT+0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648663; c=relaxed/simple;
	bh=uAAqR/oAqdrIgqVbpNrfW9SLTG3GtjU2iiDc23l8ORY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IkW7klC6km8XJYB+qwShnJgsmRUPaWD/d0r2r5FO7NWF/VAV8Lq5LdOrf5zeQU7dp1SOdyZxIG22N011nlFfEXPmV2nqWHusVQl/9ca7U/J1zzZPEzkFwlnwCwNL8gDqlI9aDT3Ptrp64r4l4oQra7XXEIMLZoM6LcgPKBOiSws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpmCQy1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpmCQy1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF160C116C6;
	Mon,  9 Feb 2026 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648663;
	bh=uAAqR/oAqdrIgqVbpNrfW9SLTG3GtjU2iiDc23l8ORY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpmCQy1cM6uH6fsPV8Upu/IHJGKl28PtsQkScAEZK4EuAOGz/JqFbLsmhaFkm9Q23
	 7zi/0rdF9YIO5sXhHxmLb9D8MXBuDBUDhiqPedVJ6UAeyD33u1qjdV8UOU2pTL0UrW
	 q2zMfombwYZf7RXaSL/V1hFkSc+vMOWmOTmlZgbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 02/41] ARM: 9468/1: fix memset64() on big-endian
Date: Mon,  9 Feb 2026 15:24:23 +0100
Message-ID: <20260209142256.889650945@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -36,7 +36,10 @@ static inline void *memset32(uint32_t *p
 extern void *__memset64(uint64_t *, uint32_t low, __kernel_size_t, uint32_t hi);
 static inline void *memset64(uint64_t *p, uint64_t v, __kernel_size_t n)
 {
-	return __memset64(p, v, n * 8, v >> 32);
+	if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
+		return __memset64(p, v, n * 8, v >> 32);
+	else
+		return __memset64(p, v >> 32, n * 8, v);
 }
 
 #endif


