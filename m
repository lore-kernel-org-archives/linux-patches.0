Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABF71AB6DC;
	Mon, 14 Oct 2024 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919060; cv=none; b=MgA1Ivr4qZlit+Tlajlz0kUN4oEFXrQTqM4Vj9iYVnLo55NopB0xDjc33IRe+qB6BFLtZeIxjjSC/DrS8KTGv3Get2iL05GN2oj2NmcEgTQpTU39xSMlUnPNLqWRu9+2O3QELBdGo7w0Jz4F96mfmLVS3+06H7Z9yOrxAu3ZgOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919060; c=relaxed/simple;
	bh=oc0/1VS7C8sBpPAJlpS6TSOMnJlR0z2WpDRKgWOvB4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQYfUYGsP4pGUeLAzgduTwBO1/9sk1baFOU8XJUMwbeWH+Xflj9l5/pb7T/4WPuQiaQ+J4rT1nhEhL4XpCDBECeMU3TXgmrNYpdGYlz/XEX5ejt0nemFz5AARBOH03UPZhjlUT/+f/eWjd2K+doWLe+qkRqcpx9+ggKLtMVaKJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqQibnLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqQibnLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1619C4CEC3;
	Mon, 14 Oct 2024 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919060;
	bh=oc0/1VS7C8sBpPAJlpS6TSOMnJlR0z2WpDRKgWOvB4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqQibnLQVaIiR+Qo7lBioXYNZMCuUeY22R+j3I5JVnNpRZV8OZP6Gl64+FwDusqHy
	 mX10/Pyi2NamV0wzcO8GcHstvhoulmQ2qrxcJXmvxqcEzwlfPWmc8nPh0yBlNhBCzw
	 HGI12NYWkTW2IFgNV+Aesn6qwcfLBEOC74LOEPug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 460/798] tools/x86/kcpuid: Protect against faulty "max subleaf" values
Date: Mon, 14 Oct 2024 16:16:54 +0200
Message-ID: <20241014141236.045859245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ahmed S. Darwish <darwi@linutronix.de>

[ Upstream commit cf96ab1a966b87b09fdd9e8cc8357d2d00776a3a ]

Protect against the kcpuid code parsing faulty max subleaf numbers
through a min() expression.  Thus, ensuring that max_subleaf will always
be ≤ MAX_SUBLEAF_NUM.

Use "u32" for the subleaf numbers since kcpuid is compiled with -Wextra,
which includes signed/unsigned comparisons warnings.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20240718134755.378115-5-darwi@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/arch/x86/kcpuid/kcpuid.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/arch/x86/kcpuid/kcpuid.c b/tools/arch/x86/kcpuid/kcpuid.c
index dae75511fef71..bbeb2dc86410b 100644
--- a/tools/arch/x86/kcpuid/kcpuid.c
+++ b/tools/arch/x86/kcpuid/kcpuid.c
@@ -7,7 +7,8 @@
 #include <string.h>
 #include <getopt.h>
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
+#define min(a, b)	(((a) < (b)) ? (a) : (b))
 
 typedef unsigned int u32;
 typedef unsigned long long u64;
@@ -203,12 +204,9 @@ static void raw_dump_range(struct cpuid_range *range)
 #define MAX_SUBLEAF_NUM		32
 struct cpuid_range *setup_cpuid_range(u32 input_eax)
 {
-	u32 max_func, idx_func;
-	int subleaf;
+	u32 max_func, idx_func, subleaf, max_subleaf;
+	u32 eax, ebx, ecx, edx, f = input_eax;
 	struct cpuid_range *range;
-	u32 eax, ebx, ecx, edx;
-	u32 f = input_eax;
-	int max_subleaf;
 	bool allzero;
 
 	eax = input_eax;
@@ -254,7 +252,7 @@ struct cpuid_range *setup_cpuid_range(u32 input_eax)
 		 * others have to be tried (0xf)
 		 */
 		if (f == 0x7 || f == 0x14 || f == 0x17 || f == 0x18)
-			max_subleaf = (eax & 0xff) + 1;
+			max_subleaf = min((eax & 0xff) + 1, max_subleaf);
 
 		if (f == 0xb)
 			max_subleaf = 2;
-- 
2.43.0



