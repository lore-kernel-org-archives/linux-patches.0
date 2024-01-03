Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CFA1C68A;
	Wed,  3 Jan 2024 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAr4hZuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF854C433C7;
	Wed,  3 Jan 2024 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302132;
	bh=m2mDrnyTL+38MoY8AY7DF4BI3+CpTPXO/Ai7+RQXUqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAr4hZuACaOucOvNOeYTwJH0hKyyoxjbOTARdjZcwNhYx4UuXWvdzK3z5jn6lypB5
	 AI4MaB+AFMlQx5vbOD22Wc38tt4wATOCIorbKlzKgA7goZaXcOn+3L9LkAz84+LRiW
	 mlIFk7JD2lPPbIRqB73zpuAi9bSsTxLYUOEcZxMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/49] linux/export: Fix alignment for 64-bit ksymtab entries
Date: Wed,  3 Jan 2024 17:55:46 +0100
Message-ID: <20240103164838.975338408@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit f6847807c22f6944c71c981b630b9fff30801e73 ]

An alignment of 4 bytes is wrong for 64-bit platforms which don't define
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS (which then store 64-bit pointers).
Fix their alignment to 8 bytes.

Fixes: ddb5cdbafaaa ("kbuild: generate KSYMTAB entries by modpost")
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/export-internal.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/export-internal.h b/include/linux/export-internal.h
index 45fca09b23194..b842aeecef791 100644
--- a/include/linux/export-internal.h
+++ b/include/linux/export-internal.h
@@ -16,10 +16,13 @@
  * and eliminates the need for absolute relocations that require runtime
  * processing on relocatable kernels.
  */
+#define __KSYM_ALIGN		".balign 4"
 #define __KSYM_REF(sym)		".long " #sym "- ."
 #elif defined(CONFIG_64BIT)
+#define __KSYM_ALIGN		".balign 8"
 #define __KSYM_REF(sym)		".quad " #sym
 #else
+#define __KSYM_ALIGN		".balign 4"
 #define __KSYM_REF(sym)		".long " #sym
 #endif
 
@@ -42,7 +45,7 @@
 	    "	.asciz \"" ns "\""					"\n"	\
 	    "	.previous"						"\n"	\
 	    "	.section \"___ksymtab" sec "+" #name "\", \"a\""	"\n"	\
-	    "	.balign	4"						"\n"	\
+		__KSYM_ALIGN						"\n"	\
 	    "__ksymtab_" #name ":"					"\n"	\
 		__KSYM_REF(sym)						"\n"	\
 		__KSYM_REF(__kstrtab_ ##name)				"\n"	\
-- 
2.43.0



