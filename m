Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0C41A3178;
	Thu, 17 Apr 2025 18:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913980; cv=none; b=M473/XV2CND70G6hAR58Gozs2zlzmGySWuOmujZHfdL+fXhqj77k53t4fu5QgaAyVxVbDjZ2CkY4l5ISwoplXiBMTCiEL83uGbkII9JoJTCQyI56UO+TyKni6mvKGOyWMa1+19v+9dNkEOdcHrVU7orWwAs3Mr3aNFzbTO4vOvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913980; c=relaxed/simple;
	bh=Po0mfIRAxXiGDZoNJjrolylDXK/vZy49GJnyDhcXLp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dN5+SnRt798AsDJR8OrNA6CkRNOkLKA7RKgUwb9VzD5B5OAezMbW1QnFkEEpyb9JH4zPuPdYfu3Ft/Wyp6wICUrIMmLybqQJPwusRDA4J/I5w5wPQVhRnuro3Zu6f+oRDnhJgpAlHOUYGaX0tbFeb/DGG0qov31PvVYDLyHYw+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drH+zwcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drH+zwcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BE2C4CEE4;
	Thu, 17 Apr 2025 18:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913979;
	bh=Po0mfIRAxXiGDZoNJjrolylDXK/vZy49GJnyDhcXLp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drH+zwcXFP8pK0dMhAFmyfVAdbNxb4HXWfKa2gk9Cowwf6C6hPd36fURz1huLKQlB
	 HzGPoNOwQnt5rv4ul7KPEmx0/6tk8HK4yS8F7kJzGzawwfxsZvhJKvw55hlgfE4hcF
	 9w12i8hHxwEnrsxFeUMqQ+QJnmUms1VjY9nvXxug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <matt@readmodwrite.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 048/414] x86/percpu: Disable named address spaces for UBSAN_BOOL with KASAN for GCC < 14.2
Date: Thu, 17 Apr 2025 19:46:46 +0200
Message-ID: <20250417175113.348702976@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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
index 45b0a0c90b934..336b4bd2fb3cd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2446,18 +2446,20 @@ config CC_HAS_NAMED_AS
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



