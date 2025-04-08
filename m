Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D51227BA4;
	Tue,  8 Apr 2025 12:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115400; cv=none; b=dfhmMT9gyzQZwu11sP4ZDcDsq/Leyrf9t17gRwYK90zzy+24zYff29JRSPVguu1CQAjAA3OYBTpFwd9q/qKJp0QR+yJ001Dvd46T5brDw69ZU3Fld0N7/bvIH8Ws7kB1U2/T2+YU+cmnb+81O3JboBOkGzbL3a42iI3jcLce9Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115400; c=relaxed/simple;
	bh=jBQ9hzWy5YFx2WKqHNQcsvufsyRg8bpgBiiudWgvKhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTvRq1gzDbg/KMER+n86jYScN9nmZb+Vc5opgLCj3EvZEh6JJ3cc8OonbcV1yPkgKW0mXhgQMDBkc8agYs2LL5RwxfLQGtCZOZ5IY3UWN7p8AifE1sXXOIrT9BWRe9aTNI72RV+F6UYd8lbKsUPFvQlKBoLX6H37LlCA+xiaaAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMaifllR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMaifllR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D957C4CEE5;
	Tue,  8 Apr 2025 12:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115399;
	bh=jBQ9hzWy5YFx2WKqHNQcsvufsyRg8bpgBiiudWgvKhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMaifllR8PSRB2/HKB62FJH4eoy8w4ThIvudLuqTglC76pOXCqw8Qq5oScycjuTDQ
	 INAZ+gipOLKFRdO4Gp2C5HdD4VplKuj1iKQ7n0mbzwZFZxi8921jG5SlvdW5jYSdig
	 CFbIX/Yf6ttvUqMXRDLMS4nyxk2U449pC73gzx7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.13 459/499] ARM: 9444/1: add KEEP() keyword to ARM_VECTORS
Date: Tue,  8 Apr 2025 12:51:11 +0200
Message-ID: <20250408104902.681842827@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


