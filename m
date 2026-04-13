Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6475934AAE9;
	Mon, 13 Apr 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776101559; cv=none; b=glDtUrZMmSMG/FiBW7LvKAGRt2afI3W9ogLwPEVjasj6N4/LJjqZEypLm/YTv8F3PggawbVApglYBQhvNgkqScy4C4WoH9JseKeN6QTufeNz4zygYRX0DpBLKhtGR4BEHRCEHvhhnZYSTWUtMHJu67/T8CAGXkNRVvHnlCFmbi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776101559; c=relaxed/simple;
	bh=wbkJyl+9tnflmsiaEKK7ORay6rwZPFrTIkV7d2NGh60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OTqyHqFNuCiWHDTVst5U7eGS13eHbAOmaJYtBU/RO6mv83BbXqsvUpy2jy+oGLuo/QDjpX4aK7AMUaSuNVHsxiku2TUlo4fY0v42ReK/ZrFeFlwGa6Dx8eT4jva2WJV4/fli6jNR2U30at1bt61oPhHnNxZSP9JTvxdSRTDLt7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIuCU+Yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIuCU+Yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA0DC2BCB0;
	Mon, 13 Apr 2026 17:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776101559;
	bh=wbkJyl+9tnflmsiaEKK7ORay6rwZPFrTIkV7d2NGh60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIuCU+Ygli0IysEYz+J6NJbXIG1ydIBPMWkhhldyeeDj9tMc1OeUMykxoKmcsNLdE
	 K5JY/APWs/OvPhmRHFiaji7BDA789BRfNzHW5JkBxfgCBYlKB6nLuGk0FmP5gyPEZP
	 it6NnOzOXJY++Zy3fs46QA1Z8wPIE3Jj40rcjorU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.15 001/570] ARM: clean up the memset64() C wrapper
Date: Mon, 13 Apr 2026 17:52:12 +0200
Message-ID: <20260413155830.447140016@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b52343d1cb47bb27ca32a3f4952cc2fd3cd165bf ]

The current logic to split the 64-bit argument into its 32-bit halves is
byte-order specific and a bit clunky.  Use a union instead which is
easier to read and works in all cases.

GCC still generates the same machine code.

While at it, rename the arguments of the __memset64() prototype to
actually reflect their semantics.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk> # for -stable
Link: https://lore.kernel.org/all/1a11526ae3d8664f705b541b8d6ea57b847b49a8.camel@decadent.org.uk/
Suggested-by: https://lore.kernel.org/all/aZonkWMwpbFhzDJq@casper.infradead.org/ # for -stable
Link: https://lore.kernel.org/all/aZonkWMwpbFhzDJq@casper.infradead.org/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/string.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/string.h b/arch/arm/include/asm/string.h
index c35250c4991bc..96fc6cf460ecb 100644
--- a/arch/arm/include/asm/string.h
+++ b/arch/arm/include/asm/string.h
@@ -39,13 +39,17 @@ static inline void *memset32(uint32_t *p, uint32_t v, __kernel_size_t n)
 }
 
 #define __HAVE_ARCH_MEMSET64
-extern void *__memset64(uint64_t *, uint32_t low, __kernel_size_t, uint32_t hi);
+extern void *__memset64(uint64_t *, uint32_t first, __kernel_size_t, uint32_t second);
 static inline void *memset64(uint64_t *p, uint64_t v, __kernel_size_t n)
 {
-	if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
-		return __memset64(p, v, n * 8, v >> 32);
-	else
-		return __memset64(p, v >> 32, n * 8, v);
+	union {
+		uint64_t val;
+		struct {
+			uint32_t first, second;
+		};
+	} word = { .val = v };
+
+	return __memset64(p, word.first, n * 8, word.second);
 }
 
 /*
-- 
2.51.0



