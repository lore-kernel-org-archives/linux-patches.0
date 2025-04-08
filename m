Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E937226FA41;
	Tue,  8 Apr 2025 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117128; cv=none; b=RSt0j/Fv3WITXsckElSij1bGfNBjAgRwawISuWBAdIIUompnOQ1hlXTLdEgdMWBVUv3KEu/lkYXxJqMcAoLMubTE9YevP31K/xSdxtPwbBtAtRG/RV5qcBuhvsN0J8zGmTHtxOdB+gdCuasDdF+GqsFJD0xz89bOhVCQDClPgj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117128; c=relaxed/simple;
	bh=txtXaLH9Cm8XE4652u73zy5wVfCPcgEG+ogn4mgfcSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFCu0FQlocdcO9b+ahkSoTZgbQZPC9LDx+/EfDIm89IwjU5T5bVEuhbaEdZZCQY9AkIVPh3yexn6JFuUJbLA1TAa8ee3MVMMABzAVScZxNkX4QSlqttM00eONy+ZqmrUjghNspnCxu9rW5f+kuzngGjIFP5oXhef31xr85EH4UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfGWHDLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfGWHDLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78041C4CEE5;
	Tue,  8 Apr 2025 12:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117127;
	bh=txtXaLH9Cm8XE4652u73zy5wVfCPcgEG+ogn4mgfcSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfGWHDLGO2xmuqamin1EwJr3DsYFShMEQT1FGf7NnZ7kSGZoqkOJpFsqVO7z1Idt5
	 dRxFZxaiybE+b8fovVkrM4iMTQj1RIuA6zm/mE3FVwoR4rlmjMz/LuTwDKuF8H1vZ1
	 IaPJcaIy7SBQDglFQofBw5O7qsu0KoEJV2W/Om1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.12 387/423] ARM: 9444/1: add KEEP() keyword to ARM_VECTORS
Date: Tue,  8 Apr 2025 12:51:53 +0200
Message-ID: <20250408104854.902730168@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Christian Eggers <ceggers@arri.de>

commit c3d944a367c0d9e4e125c7006e52f352e75776dc upstream.

Without this, the vectors are removed if LD_DEAD_CODE_DATA_ELIMINATION
is enabled.  At startup, the CPU (silently) hangs in the undefined
instruction exception as soon as the first timer interrupt arrives.

On my setup, the system also boots fine without the 2nd and 3rd KEEP()
statements, so I cannot tell whether these are actually required.

[nathan: Use OVERLAY_KEEP() to avoid breaking old ld.lld versions]

Cc: stable@vger.kernel.org
Fixes: ed0f94102251 ("ARM: 9404/1: arm32: enable HAVE_LD_DEAD_CODE_DATA_ELIMINATION")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/vmlinux.lds.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/vmlinux.lds.h
+++ b/arch/arm/include/asm/vmlinux.lds.h
@@ -125,13 +125,13 @@
 	__vectors_lma = .;						\
 	OVERLAY 0xffff0000 : NOCROSSREFS AT(__vectors_lma) {		\
 		.vectors {						\
-			*(.vectors)					\
+			OVERLAY_KEEP(*(.vectors))			\
 		}							\
 		.vectors.bhb.loop8 {					\
-			*(.vectors.bhb.loop8)				\
+			OVERLAY_KEEP(*(.vectors.bhb.loop8))		\
 		}							\
 		.vectors.bhb.bpiall {					\
-			*(.vectors.bhb.bpiall)				\
+			OVERLAY_KEEP(*(.vectors.bhb.bpiall))		\
 		}							\
 	}								\
 	ARM_LMA(__vectors, .vectors);					\


