Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE131D54D1;
	Tue,  8 Oct 2024 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391744; cv=none; b=TMjor/0JiUYXaRSaHb9g1nPITWkvQCGjrxAKKdWHAorkgeiywS5BcpqD4QmyIgAgqIwFOUkm5USxhZI2M7NI2LvEfw5okWt+exbdOpBpUXS0rNrEVHHcQ6xks8pfJpG8Rz+2MaMIXzDfAUlA3Ps6Lnh0STNOzYHwwEXVW+uq29M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391744; c=relaxed/simple;
	bh=kFfEXY1levU07tKNkh1OaelPD0GMzBSO9JZMgrpfSTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=er4OxZie1/drGEAtYe0YTV2SqMh4hANvloh6rLMdmgAE5GQeRLMfBo4juf/afzv8V9TiwU8MHPFvPQ4KsGkR7W65IiFZ7zIshBnUIHpb85xTZbPkj9B0lz2fdliMVClwPpuq9tfpOsc/garIDcdrsgCHBQaC+fbi6Wg4WW8f2Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xh9peum+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xh9peum+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA32C4CEC7;
	Tue,  8 Oct 2024 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391743;
	bh=kFfEXY1levU07tKNkh1OaelPD0GMzBSO9JZMgrpfSTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xh9peum+F1aCrXzg2fYf26izFmTiVhEBwxjN3ppVxpDGKEQPx9u4Zz8AdZC57TXOD
	 V61o4SoCbvJ0f8vygPKWg5GMF7mmHDkawyqKm1hzdrUImLPV06cQVYFqOfNml1jTsW
	 /b5T0nqbSGiS1GMrnokS3++O5wDYogTy6prQKwbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 177/558] tools/x86/kcpuid: Protect against faulty "max subleaf" values
Date: Tue,  8 Oct 2024 14:03:27 +0200
Message-ID: <20241008115709.320024118@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 24b7d017ec2c1..b7965dfff33a9 100644
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
@@ -207,12 +208,9 @@ static void raw_dump_range(struct cpuid_range *range)
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
@@ -258,7 +256,7 @@ struct cpuid_range *setup_cpuid_range(u32 input_eax)
 		 * others have to be tried (0xf)
 		 */
 		if (f == 0x7 || f == 0x14 || f == 0x17 || f == 0x18)
-			max_subleaf = (eax & 0xff) + 1;
+			max_subleaf = min((eax & 0xff) + 1, max_subleaf);
 
 		if (f == 0xb)
 			max_subleaf = 2;
-- 
2.43.0



