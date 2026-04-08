Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8587132A3FD;
	Wed,  8 Apr 2026 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674662; cv=none; b=Ghdq2v73mA8Rg8zNEaYfXkhKoaxHyqdb8Nw/rDOyf04spuCXic2TZpT5ejBsZWdtSYhxbuGQJY/geRLFbl7VjjjT4ZJW/F0m31zqAkEkBRMV+ny13FoudsrUuHzT5FGR91DhjT71RwUbbgWHlEQaCQsjLDRcufzR2eECcCEI3Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674662; c=relaxed/simple;
	bh=vJYfX6GIhRvpKdM1grpMN+U0yQS2t9w4KfEHfbyqirs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX4TTOFzssfaeEOJqWi/T0ySzOXqZUO53eFUsDJzObMHaWedyuCBJrBjAKQMsfYukmV+J1BleMsuCUcRcMtRCj7MZoc/pub0p9GDAeN5DuNE10MUIRANK4+QdmObbeORtE64MXf1RsjPxCvsWSnWsNMR0Gz3MYxWTSSJBMuNuXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l51m1tak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l51m1tak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C486BC19421;
	Wed,  8 Apr 2026 18:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674662;
	bh=vJYfX6GIhRvpKdM1grpMN+U0yQS2t9w4KfEHfbyqirs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l51m1tak2wDp1gfZxgWBAdMC0qoKym0yZiAdKHvQYa7R62bxCqLpqj22qfXeLn2AZ
	 M8CHIECaC0aU3vZgdY2nk3shUN33hA/rssGRwiprLFqZfXnJf09cOS8QYLvGroWCgp
	 8mXuACo3ChStx2LM6aips/YMYCjVmVw4tYzSIgaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.19 185/311] MIPS: Fix the GCC version check for `__multi3 workaround
Date: Wed,  8 Apr 2026 20:03:05 +0200
Message-ID: <20260408175946.319551178@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit ec8bf18814915460d9c617b556bf024efef26613 upstream.

It was only GCC 10 that fixed a MIPS64r6 code generation issue with a
`__multi3' libcall inefficiently produced to perform 64-bit widening
multiplication while suitable machine instructions exist to do such a
calculation.  The fix went in with GCC commit 48b2123f6336 ("re PR
target/82981 (unnecessary __multi3 call for mips64r6 linux kernel)").

Adjust our code accordingly, removing build failures such as:

mips64-linux-ld: lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
div64.c:(.text+0x84): undefined reference to `__multi3'

with the GCC versions affected.

Fixes: ebabcf17bcd7 ("MIPS: Implement __multi3 for GCC7 MIPS64r6 builds")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601140146.hMLODc6v-lkp@intel.com/
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v4.15+
Reviewed-by: David Laight <david.laight.linux@gmail.com.
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/lib/multi3.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/lib/multi3.c
+++ b/arch/mips/lib/multi3.c
@@ -4,12 +4,12 @@
 #include "libgcc.h"
 
 /*
- * GCC 7 & older can suboptimally generate __multi3 calls for mips64r6, so for
+ * GCC 9 & older can suboptimally generate __multi3 calls for mips64r6, so for
  * that specific case only we implement that intrinsic here.
  *
  * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82981
  */
-#if defined(CONFIG_64BIT) && defined(CONFIG_CPU_MIPSR6) && (__GNUC__ < 8)
+#if defined(CONFIG_64BIT) && defined(CONFIG_CPU_MIPSR6) && (__GNUC__ < 10)
 
 /* multiply 64-bit values, low 64-bits returned */
 static inline long long notrace dmulu(long long a, long long b)
@@ -51,4 +51,4 @@ ti_type notrace __multi3(ti_type a, ti_t
 }
 EXPORT_SYMBOL(__multi3);
 
-#endif /* 64BIT && CPU_MIPSR6 && GCC7 */
+#endif /* 64BIT && CPU_MIPSR6 && GCC9 */


