Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD92745C12
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZBuBeNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CB4C433CB;
	Wed, 15 Nov 2023 22:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085796;
	bh=7p3+PvEga5tnB5wox6NAT5zK60WGZ73cy2u3LZZovGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZBuBeNhNReH2ltLd6sla/uuRC2rN8wht8kPxZGcs3is6TSsDfcnojLsh1sDOan9o
	 wPzKocvrNsyq0rzFAJTS2HBzCXFEujW6a6j0LYyD+5xbVBSC4P7s6tTwyarelZVJPa
	 Oq/vIgC97ROqN8T7l3iME9i5VEP88AExumqsVwIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Kursad Oney <kursad.oney@broadcom.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/119] ARM: 9321/1: memset: cast the constant byte to unsigned char
Date: Wed, 15 Nov 2023 17:00:49 -0500
Message-ID: <20231115220134.456617465@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kursad Oney <kursad.oney@broadcom.com>

[ Upstream commit c0e824661f443b8cab3897006c1bbc69fd0e7bc4 ]

memset() description in ISO/IEC 9899:1999 (and elsewhere) says:

	The memset function copies the value of c (converted to an
	unsigned char) into each of the first n characters of the
	object pointed to by s.

The kernel's arm32 memset does not cast c to unsigned char. This results
in the following code to produce erroneous output:

	char a[128];
	memset(a, -128, sizeof(a));

This is because gcc will generally emit the following code before
it calls memset() :

	mov   r0, r7
	mvn   r1, #127        ; 0x7f
	bl    00000000 <memset>

r1 ends up with 0xffffff80 before being used by memset() and the
'a' array will have -128 once in every four bytes while the other
bytes will be set incorrectly to -1 like this (printing the first
8 bytes) :

	test_module: -128 -1 -1 -1
	test_module: -1 -1 -1 -128

The change here is to 'and' r1 with 255 before it is used.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kursad Oney <kursad.oney@broadcom.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/lib/memset.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/lib/memset.S b/arch/arm/lib/memset.S
index 6ca4535c47fb6..e36d053a8a903 100644
--- a/arch/arm/lib/memset.S
+++ b/arch/arm/lib/memset.S
@@ -16,6 +16,7 @@
 ENTRY(mmioset)
 ENTRY(memset)
 UNWIND( .fnstart         )
+	and	r1, r1, #255		@ cast to unsigned char
 	ands	r3, r0, #3		@ 1 unaligned?
 	mov	ip, r0			@ preserve r0 as return value
 	bne	6f			@ 1
-- 
2.42.0



