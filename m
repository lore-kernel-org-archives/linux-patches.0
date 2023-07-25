Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF99F14270
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E8CC433C8;
	Tue, 25 Jul 2023 10:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282376;
	bh=PR80scmzQp4U0vGt2Ne4nKASw/hrc6FoWE374ZYdT9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T13oD6CdmGnPmrr/7xDqd91yEUBpsgN8G+ifGpztMhjmrbHx0m8GqN++Be8a0YFTP
	 JRSY7iWtv8zXoCl9VIHo18bbMGPR3LgbCEtswsPbxCWDAnXwCNP/Ud2tS+G545oKnz
	 NBHYWPmCiJCVQ8TwZnYoDHrRJVX+V3tet4j0Zqv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 108/227] tools/nolibc: ensure stack protector guard is never zero
Date: Tue, 25 Jul 2023 12:44:35 +0200
Message-ID: <20230725104519.241763797@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 88fc7eb54ecc6db8b773341ce39ad201066fa7da ]

The all-zero pattern is one of the more probable out-of-bound writes so
add a special case to not accidentally accept it.

Also it enables the reliable detection of stack protector initialization
during testing.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stackprotector.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/include/nolibc/stackprotector.h b/tools/include/nolibc/stackprotector.h
index d119cbbbc256f..9890e86c26172 100644
--- a/tools/include/nolibc/stackprotector.h
+++ b/tools/include/nolibc/stackprotector.h
@@ -45,8 +45,9 @@ __attribute__((weak,no_stack_protector,section(".text.nolibc_stack_chk")))
 void __stack_chk_init(void)
 {
 	my_syscall3(__NR_getrandom, &__stack_chk_guard, sizeof(__stack_chk_guard), 0);
-	/* a bit more randomness in case getrandom() fails */
-	__stack_chk_guard ^= (uintptr_t) &__stack_chk_guard;
+	/* a bit more randomness in case getrandom() fails, ensure the guard is never 0 */
+	if (__stack_chk_guard != (uintptr_t) &__stack_chk_guard)
+		__stack_chk_guard ^= (uintptr_t) &__stack_chk_guard;
 }
 #endif // defined(NOLIBC_STACKPROTECTOR)
 
-- 
2.39.2



