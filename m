Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440DC329C55;
	Mon, 27 Oct 2025 18:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591107; cv=none; b=AhWzZlgiAWCRjpuPAbT7YeGUV9+C3k1x8mh+4Jg2+vsSjOuElq93S8j4nQUD4yYZFel8+IpXs4B/WJlqAcSGSBIABt3wFXVqzw4QeCkT/WU9XTIxn61oYHjWpgIumJzqET9I71n2oUC+p0s5Jvtepsw5Z2uuq8BCVOSzV7d6Xl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591107; c=relaxed/simple;
	bh=qMuYhav60/zy34DW6u9h7MyDDrBEIoIb80ax28mOJjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kzpRmBSNoEFzDXaJEQpS+BrV8isoeQexZ+w/OwII3TFoOF1aH0MFuHSRz3Cbg9uixAnS7yoYJtkg0eIl9deK6hucqUpRDbYaDdQLkmDDfxJq1SlTgrHvnKzgCuD5GjnkC9dznJT6NVThnu9USgH6bz6hCd6Ze+26Rx1iFG3LUMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLVtE1Ux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLVtE1Ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1F5C4CEF1;
	Mon, 27 Oct 2025 18:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591107;
	bh=qMuYhav60/zy34DW6u9h7MyDDrBEIoIb80ax28mOJjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLVtE1UxOnHfk0t7NKyC/E5Oi1+k4ifO6tLqarmWpuzeBjDO1WfabXrq+Z6zb+aUe
	 rHWlTzyaPlCXs/CSg4fdGPmZYmceV/BsmRZ9TkAVcoXebf1U6A0OSpyoZt6/AHTmE3
	 7EeYXy6aUtvT9zxwlOaDPlQTqUPbPurVG+JqDWHg=
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
Subject: [PATCH 5.10 069/332] sparc: fix accurate exception reporting in copy_{from_to}_user for UltraSPARC III
Date: Mon, 27 Oct 2025 19:32:02 +0100
Message-ID: <20251027183526.441153369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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



