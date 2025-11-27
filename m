Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9542F32B988;
	Thu, 27 Nov 2025 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255326; cv=none; b=nd2UGqqivfRNhFlvwH4f3KoluB7s65eIwNLZwsrW0BfHkLkE9mAAjNB/xwB2u97WdTy7q8e8szVupUTYdoWDv65lUEW2/0WHaw5sWoEDxJD0Hc7x7tMtU/Fe6VA0MM1t5TuaY8/3ajdyApJ7mI84MVa/MjqOty8idvsknokJQFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255326; c=relaxed/simple;
	bh=Mmz2kVz3FxrieoubLRBFALJ5iUQrlDko86ujDMcDJzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6OQnUVSxuvoa4ghAVqr0fqzd8KYwfDi9Eq3SqoEZ3FnPETcX/+yUH/1vVvz4R5W5H3GLQn4EZfP8wyczr81u2MlCHtXgOGWd66HoknasC1YMQOpWKpR4QFxqRk6wChIKYTZKC++X+IFM1T/NetTIJqAoTjiIsebPOa0pXSvNUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPEUFY16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPEUFY16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA77C116D0;
	Thu, 27 Nov 2025 14:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255326;
	bh=Mmz2kVz3FxrieoubLRBFALJ5iUQrlDko86ujDMcDJzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPEUFY16p0ABKVnNPpHMCC19cDz00GcqnAVUbK60292Mn0SAQpu9VMzrdjyQpQgXE
	 Mgvq1fwT4SPy0H6h0EyKP4UZMjGrP8A25RjCBVC4aO2+AFYOW/xhT/p0nCyVGaLkhR
	 ussfTy6i5J/XHGtgq2kNxI06HqXLAY7/aoB5m9cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/112] x86/microcode/AMD: Limit Entrysign signature checking to known generations
Date: Thu, 27 Nov 2025 15:46:28 +0100
Message-ID: <20251127144035.990488670@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 8a9fb5129e8e64d24543ebc70de941a2d77a9e77 ]

Limit Entrysign sha256 signature checking to CPUs in the range Zen1-Zen5.

X86_BUG cannot be used here because the loading on the BSP happens way
too early, before the cpufeatures machinery has been set up.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/all/20251023124629.5385-1-bp@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/amd.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 93cbf05b83a56..7e997360223b2 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -224,6 +224,24 @@ static bool need_sha_check(u32 cur_rev)
 	return true;
 }
 
+static bool cpu_has_entrysign(void)
+{
+	unsigned int fam   = x86_family(bsp_cpuid_1_eax);
+	unsigned int model = x86_model(bsp_cpuid_1_eax);
+
+	if (fam == 0x17 || fam == 0x19)
+		return true;
+
+	if (fam == 0x1a) {
+		if (model <= 0x2f ||
+		    (0x40 <= model && model <= 0x4f) ||
+		    (0x60 <= model && model <= 0x6f))
+			return true;
+	}
+
+	return false;
+}
+
 static bool verify_sha256_digest(u32 patch_id, u32 cur_rev, const u8 *data, unsigned int len)
 {
 	struct patch_digest *pd = NULL;
@@ -231,7 +249,7 @@ static bool verify_sha256_digest(u32 patch_id, u32 cur_rev, const u8 *data, unsi
 	struct sha256_state s;
 	int i;
 
-	if (x86_family(bsp_cpuid_1_eax) < 0x17)
+	if (!cpu_has_entrysign())
 		return true;
 
 	if (!need_sha_check(cur_rev))
-- 
2.51.0



