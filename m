Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C1A226D03;
	Tue,  8 Apr 2025 11:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112139; cv=none; b=hbV/pNaUkITbzmFUVx5Wa6huZgVpZ196nx+L1GZQA2ZUzOTO6sw+eqN63nKDneauuwZgvb+pP3kT6UJ7vSg4lK4tTusTFHyDsVN7xdRGm6VLvhwz1ElH2jRuk2japftn67K1MskvBZlVpsGMiZsPGywqJW5faCkq7BUU5eC5QKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112139; c=relaxed/simple;
	bh=w34X21WH+VBalLdHI3xRs0FKOmD1Nv8uEtnF6HsZh/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spTJOz4UiPZUgdZPCPR4P9nphthcbXawVcLQduaqGLXndAtDLTDfBwUxDSd1/vhKu1B2uohTSAgJwZeDjBE6c1eRf4MF/m9SXGGy8ExTtOWgtsPH3+TlIoMYz1GQ26McJaH6FZkC+y2FAgGXTEQfH7L+OWQe2/342kUr2ui9LWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naDcj78C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naDcj78C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB69C4CEE5;
	Tue,  8 Apr 2025 11:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112139;
	bh=w34X21WH+VBalLdHI3xRs0FKOmD1Nv8uEtnF6HsZh/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naDcj78CatHmYmvsu9YFGD2b2JN17LfhIyuSHrGW6ZO24Gt2crtx3R3UpUoKUqCvq
	 y3GJjYuZSsj1cOUb8AI84J6vwyyuQlb7vWaJcU0//g0uIie/lS096SX40AeOqnYlZm
	 yO5wjJvrRR3E2Vaj4O7xCPr9RS/NlHP5ylmVztVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.14 691/731] ARM: 9444/1: add KEEP() keyword to ARM_VECTORS
Date: Tue,  8 Apr 2025 12:49:48 +0200
Message-ID: <20250408104930.340608669@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -131,13 +131,13 @@
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


