Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527B02459F7;
	Tue, 20 May 2025 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749924; cv=none; b=F+dmPzzOraqblEa9XZad+X8EQhqzaaVR03E809zgvFB3hDxxOYB4UzbmcOsw6Z5X6knrYSDL34CucDGUwtwGBe+u3dTSmmG1ReiBUg6m9BIQQ3Ie8Wk1vYy+XWjfdc4Hw+PzcptiZNQKHJjPJyds7cA93i9buHuJV1zppT7JLnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749924; c=relaxed/simple;
	bh=ZoAb6DyRLBpOnhTr/uFMD1cNrXeQXksSg03FzuXdqv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwrB1xn1UfSSI/YI4ewaCYnrvpIajUtbnCWXVI9j/3mvBZNsh8ryJcfATfodtDt6znqtZrGzksDISeQ6f810UNe3wYPRaVqd6bIWqs20O2ivnZCdJoFoW4VzgRutk4xi72DkgK4Lk/cxDYiX9v6peN9qIUvwhEozhWuYuWy1JLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZxMQmK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZxMQmK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B5AC4CEE9;
	Tue, 20 May 2025 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749924;
	bh=ZoAb6DyRLBpOnhTr/uFMD1cNrXeQXksSg03FzuXdqv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZxMQmK7Gn6BGAJ3H2pr1DMQlO4s2OxNcctkxsA0JpNnRY85evAdGPUUr0b60VhKS
	 +L5nRKSQChxPnYOwNgOJwTjHZ3hME9vHhKPUC8JdOyXCV2P6NPaJDCHGs7phHvqGLh
	 xwrGL9YUBBA5FJN7utWgVPwltYISGw//9p6ZZJHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natanael Copa <ncopa@alpinelinux.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.6 103/117] x86/its: Fix build error for its_static_thunk()
Date: Tue, 20 May 2025 15:51:08 +0200
Message-ID: <20250520125808.085675857@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Due to a likely merge resolution error of backport commit 772934d9062a
("x86/its: FineIBT-paranoid vs ITS"), the function its_static_thunk() was
placed in the wrong ifdef block, causing a build error when
CONFIG_MITIGATION_ITS and CONFIG_FINEIBT are both disabled:

  /linux-6.6/arch/x86/kernel/alternative.c:1452:5: error: redefinition of 'its_static_thunk'
   1452 | u8 *its_static_thunk(int reg)
        |     ^~~~~~~~~~~~~~~~

Fix it by moving its_static_thunk() under CONFIG_MITIGATION_ITS.

Fixes: e52c1dc7455d ("x86/its: FineIBT-paranoid vs ITS")
Reported-by: Natanael Copa <ncopa@alpinelinux.org>
Link: https://lore.kernel.org/all/20250519164717.18738b4e@ncopa-desktop/
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -730,7 +730,15 @@ static bool cpu_wants_indirect_its_thunk
 	/* Lower-half of the cacheline? */
 	return !(addr & 0x20);
 }
-#endif
+
+u8 *its_static_thunk(int reg)
+{
+	u8 *thunk = __x86_indirect_its_thunk_array[reg];
+
+	return thunk;
+}
+
+#endif /* CONFIG_MITIGATION_ITS */
 
 /*
  * Rewrite the compiler generated retpoline thunk calls.
@@ -1449,13 +1457,6 @@ static void __apply_fineibt(s32 *start_r
 static void poison_cfi(void *addr) { }
 #endif
 
-u8 *its_static_thunk(int reg)
-{
-	u8 *thunk = __x86_indirect_its_thunk_array[reg];
-
-	return thunk;
-}
-
 #endif
 
 void apply_fineibt(s32 *start_retpoline, s32 *end_retpoline,


