Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1FA256C7B;
	Thu, 17 Apr 2025 17:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912575; cv=none; b=NuAB3Ci0ocgef2TJTi/EF/gn8BEBsiaf2t8DzrXwsLPAuZAgXVpuyV18Y4UWSiCs1J7YkSCYLflPdy7U8Jk3Vhd7RHENOdPtawAdJJzjwIOtD1nl9H4aRdZ+fRyXXdW93UqWsVmHzJ4WfJaKm9mC4hk2V3w+9/D/R0UzT+f9Iww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912575; c=relaxed/simple;
	bh=YIyIoSmexwXL7LE146awMF7bwJtCJXTzkALaDKHthlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlM7flTrckd1LTP1t0GRSj5hHKRimc+KxQ41G2F4Pefb5TAYLGx6GjdHPo//873X9ZuOYB4fkEhr7NIHdxB9lQSsDzE9+YG6LreDnPmCO79aXbqJqHJWNNsi3EUXZnZG8PnKX3IPVXCQMjviywsvUE3YoASdLtkrpJsVy4296MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwT2rDC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwT2rDC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E082C4CEE4;
	Thu, 17 Apr 2025 17:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912575;
	bh=YIyIoSmexwXL7LE146awMF7bwJtCJXTzkALaDKHthlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwT2rDC4IhZf4eaXsQ7+EyE3abqETQdEQRE6GMV5rL2TEJHB1ucPGEkl2/7MKtZRz
	 Z3ZTDJx//YtzI0W4t+6Yyfg++uwc/cSgfAa1zGde4pERM8ROdiMjuTrHmwjvIFpIOQ
	 qFcfpQ34uzHAblxbLed4CD5MKHRKwvAEYIafafi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <matt@readmodwrite.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 055/449] x86/percpu: Disable named address spaces for UBSAN_BOOL with KASAN for GCC < 14.2
Date: Thu, 17 Apr 2025 19:45:43 +0200
Message-ID: <20250417175120.212357712@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit b6762467a09ba8838c499e4f36561e82fc608ed1 ]

GCC < 14.2 does not correctly propagate address space qualifiers
with -fsanitize=bool,enum. Together with address sanitizer then
causes that load to be sanitized.

Disable named address spaces for GCC < 14.2 when both, UBSAN_BOOL
and KASAN are enabled.

Reported-by: Matt Fleming <matt@readmodwrite.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250227140715.2276353-1-ubizjak@gmail.com
Closes: https://lore.kernel.org/lkml/20241213190119.3449103-1-matt@readmodwrite.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index aaec6ebd6c4e0..aeb95b6e55369 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2452,18 +2452,20 @@ config CC_HAS_NAMED_AS
 	def_bool $(success,echo 'int __seg_fs fs; int __seg_gs gs;' | $(CC) -x c - -S -o /dev/null)
 	depends on CC_IS_GCC
 
+#
+# -fsanitize=kernel-address (KASAN) and -fsanitize=thread (KCSAN)
+# are incompatible with named address spaces with GCC < 13.3
+# (see GCC PR sanitizer/111736 and also PR sanitizer/115172).
+#
+
 config CC_HAS_NAMED_AS_FIXED_SANITIZERS
-	def_bool CC_IS_GCC && GCC_VERSION >= 130300
+	def_bool y
+	depends on !(KASAN || KCSAN) || GCC_VERSION >= 130300
+	depends on !(UBSAN_BOOL && KASAN) || GCC_VERSION >= 140200
 
 config USE_X86_SEG_SUPPORT
-	def_bool y
-	depends on CC_HAS_NAMED_AS
-	#
-	# -fsanitize=kernel-address (KASAN) and -fsanitize=thread
-	# (KCSAN) are incompatible with named address spaces with
-	# GCC < 13.3 - see GCC PR sanitizer/111736.
-	#
-	depends on !(KASAN || KCSAN) || CC_HAS_NAMED_AS_FIXED_SANITIZERS
+	def_bool CC_HAS_NAMED_AS
+	depends on CC_HAS_NAMED_AS_FIXED_SANITIZERS
 
 config CC_HAS_SLS
 	def_bool $(cc-option,-mharden-sls=all)
-- 
2.39.5



