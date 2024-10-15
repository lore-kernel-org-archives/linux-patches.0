Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2D11D8DEA;
	Tue, 15 Oct 2024 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993534; cv=none; b=M1hsSiMhCVZstKOeKMCG549LLX0j89scs0JoVERwLWx09SiNxRv4spj3h48FQcFz55QRdJSttMJwq+vK2gP7IAMczhz4+8WbrEJDktTzzc7YClb3cA4X+W0YySwIy5+NiKaUDu0AhPckomtx4pMl7zv7ABjVnlg7Efth0CJeC8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993534; c=relaxed/simple;
	bh=j6V2HcuiL53ufe9Ik9lAsG6DbJ62YWJVOIZEzLNXRwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gm7v4VJeAcf62YDmR98bjTTVARbpCurhxqeiG2t9OquXdCm5bxYLPcbD1Icque/pNrXPTjQfgkXnnsCxZmCjWWXXfY+k0x6vmnj7eCiuE5CQFKQqAb4/7NXhohv1vX5kJnU5mWD0dAN2BXwNV6LwIgIWfyrVcqWHoQffIpsmSvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYV1sT21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYV1sT21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980E4C4CEC6;
	Tue, 15 Oct 2024 11:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993534;
	bh=j6V2HcuiL53ufe9Ik9lAsG6DbJ62YWJVOIZEzLNXRwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYV1sT21YkhEmsTSo8uyacJ9s0C/GsscCK3AdpKEgPkSG+IEjtFIzv4R1kuwkndVn
	 fD7bOeXqpqV6jT1C3k77mN7GBGZnfLZPd9f+lTVq5jCVjSnX4kUz2ewtZ0jxl2n7dY
	 p9eq2g9XEVq2pNl+F2aZUAw0m7j4YRrFky/y7850=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/691] tools/x86/kcpuid: Protect against faulty "max subleaf" values
Date: Tue, 15 Oct 2024 13:26:28 +0200
Message-ID: <20241015112457.809977607@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



