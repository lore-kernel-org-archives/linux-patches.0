Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DD431326F;
	Mon, 13 Oct 2025 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367237; cv=none; b=YUlcE1zhyk1x2gVapcgZmvdpQtWQBe0JhdT5BLzbefIVCW+TwMfbhwVzZxauWboAT3aZAu6elDnHnpXNvYIoSQuLXq6TZ5R/1kOQPG/JW6BeVO00CDOuUHu4MuPbaWUggrUQCPPxVRR7tv0y5Z9SYIn8JBydFVKfszWluGHwFac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367237; c=relaxed/simple;
	bh=SpQoJY4qBgx2CaqXdBXY8rgT8/c9Jq4hUz8EcL5jNjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kpIwbKK8ogqy1mZ6cxZaWb5YxoIorAjgxsRQ3Fu36Wkf7IPhCHAPTBV8ApDfxfEwENfEseF9Wn/dKzOZOVCimmoYjmJsoQUZgk+E7MRI/N67A5SKUfx7ilPHHpJ20+V/0TVoKNbhkg6jN/8Ozk4FfVrfEPsGu1UWkYLzgp8Pu2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cNdi+HZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cNdi+HZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7033FC19422;
	Mon, 13 Oct 2025 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367237;
	bh=SpQoJY4qBgx2CaqXdBXY8rgT8/c9Jq4hUz8EcL5jNjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cNdi+HZVGb1iSh6MAty1Sk7wGjGdCCoCu1ywmGoP/eSxJIKmV6jQrca03ovKFg75
	 goUvkr1XjXYHwpNXaWxGLaZvLI+DEuqJ7joTyobAjWsfhvbq/OTUS44b2y8rgMOcnm
	 GSBcqY3ezPateM8ZCHAMxOdUKiwcIvzer3gqvNmM=
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
Subject: [PATCH 6.1 140/196] sparc: fix accurate exception reporting in copy_{from_to}_user for UltraSPARC III
Date: Mon, 13 Oct 2025 16:45:13 +0200
Message-ID: <20251013144319.758901658@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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



