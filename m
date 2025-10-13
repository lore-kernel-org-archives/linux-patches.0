Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B488D30AADB;
	Mon, 13 Oct 2025 15:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367778; cv=none; b=CqDV7sr0smbKleXyeq2PzMv9SbAue9xO3K82JltLdH7ebiZizklaGXSXxpfgudLpMf6OjvyJX2V7nFz5hI1C7imulPWijM9Ld+dAyJsdhSlGxiSFKtHB+ROGK1t10javWHy0TLsvuG6OZuOTQTupMJZGJGJuqpjMkuo/O9d90W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367778; c=relaxed/simple;
	bh=Y4kSbedNVFl2u4y8P6bYsY01G2wGQscatg3v7ywRndU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQQtpQR8+nY6+xNd+YsIDi5orfko125YSL4ckA6WGRk6XajPjF2L/pCYsB7EQS8NxgPxhaVlE2gAJ2yOWsTnwJEBjuFCrP8/+I8TJ+ItMTR98s/7cr96Sjt+jH+tKqE4dAGZKmB4p9YtHRfxCXdJ1CK4Mfo8E4N0/8d1Tvt3Gws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fG9pHSUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fG9pHSUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4034AC4CEE7;
	Mon, 13 Oct 2025 15:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367778;
	bh=Y4kSbedNVFl2u4y8P6bYsY01G2wGQscatg3v7ywRndU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fG9pHSUfTn5QACbFXzxPRaB94KLqeXjScBjHSvuVnnBjgYBJzjro4UuapvRry1V9t
	 p0hAzeaXAzT684lWJ0Yqy2pUhAGuibVNY+WVKHHU+3YRP/MFOrjNmLU0PQ6xXkgTzP
	 kV/olZMJix3lXWECqgVubAnw+ZcQrUKlkhZslOrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactcode.com>
Subject: [PATCH 6.6 130/196] sparc: fix accurate exception reporting in copy_{from_to}_user for UltraSPARC III
Date: Mon, 13 Oct 2025 16:45:21 +0200
Message-ID: <20251013144320.013308338@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

[ Upstream commit 47b49c06eb62504075f0f2e2227aee2e2c2a58b3 ]

Anthony Yznaga tracked down that a BUG_ON in ext4 code with large folios
enabled resulted from copy_from_user() returning impossibly large values
greater than the size to be copied. This lead to __copy_from_iter()
returning impossible values instead of the actual number of bytes it was
able to copy.

The BUG_ON has been reported in
https://lore.kernel.org/r/b14f55642207e63e907965e209f6323a0df6dcee.camel@physik.fu-berlin.de

The referenced commit introduced exception handlers on user-space memory
references in copy_from_user and copy_to_user. These handlers return from
the respective function and calculate the remaining bytes left to copy
using the current register contents. The exception handlers expect that
%o2 has already been masked during the bulk copy loop, but the masking was
performed after that loop. This will fix the return value of copy_from_user
and copy_to_user in the faulting case. The behaviour of memcpy stays
unchanged.

Fixes: ee841d0aff64 ("sparc64: Convert U3copy_{from,to}_user to accurate exception reporting.")
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> # on Sun Netra 240
Reviewed-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Tested-by: René Rebe <rene@exactcode.com> # on UltraSparc III+ and UltraSparc IIIi
Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20250905-memcpy_series-v4-2-1ca72dda195b@mkarcher.dialup.fu-berlin.de
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/lib/U3memcpy.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/lib/U3memcpy.S b/arch/sparc/lib/U3memcpy.S
index 9248d59c734ce..bace3a18f836f 100644
--- a/arch/sparc/lib/U3memcpy.S
+++ b/arch/sparc/lib/U3memcpy.S
@@ -267,6 +267,7 @@ FUNC_NAME:	/* %o0=dst, %o1=src, %o2=len */
 	faligndata	%f10, %f12, %f26
 	EX_LD_FP(LOAD(ldd, %o1 + 0x040, %f0), U3_retl_o2)
 
+	and		%o2, 0x3f, %o2
 	subcc		GLOBAL_SPARE, 0x80, GLOBAL_SPARE
 	add		%o1, 0x40, %o1
 	bgu,pt		%XCC, 1f
@@ -336,7 +337,6 @@ FUNC_NAME:	/* %o0=dst, %o1=src, %o2=len */
 	 * Also notice how this code is careful not to perform a
 	 * load past the end of the src buffer.
 	 */
-	and		%o2, 0x3f, %o2
 	andcc		%o2, 0x38, %g2
 	be,pn		%XCC, 2f
 	 subcc		%g2, 0x8, %g2
-- 
2.51.0



