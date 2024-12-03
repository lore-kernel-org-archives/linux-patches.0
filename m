Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EB71DA3D;
	Tue,  3 Dec 2024 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239123; cv=none; b=aHA5zNyJR2qbNqBjpPRa9CgBymOMjEZ4ZXmD9ECDXroipk0Cz9OLoqJSc7hOf+puhtqBpPrUNH9OyS4UEfUaDA7sI6YzC2qb6/OsW4HG0RBy7uz5LojXIcOaC88MVMccm14dr1+qJbfOEJQwIyHvxcdUmnY88Zydjo+UiqRj1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239123; c=relaxed/simple;
	bh=+in8l7teeCs+1YZbnT0/HxwOyK5f1zVRtN/ohigswck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqLTa+97wyYuZICErirHe+Rw0kx4U52bkDiauAB4yYrf1ZO6Ufd8Pp+Bzmh95fXUtEeQeoQNeGKG0LXinab9i9nBl0ANvf2e7EWU5TDeVaENHaggWdgtPjTnjdSO6oU8/tGN66Sf4QI4JyFDD0VEFh0d+EHGvFMmrW05BjdJatQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Im9JsHSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Im9JsHSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCC8C4CECF;
	Tue,  3 Dec 2024 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239123;
	bh=+in8l7teeCs+1YZbnT0/HxwOyK5f1zVRtN/ohigswck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Im9JsHSUnxHMkzwQR3PJCs0QLVyIplClMYzJrNV3arJnWCcECwcyK5aA6hMOnrPVC
	 TsGJcl49dFErDZP/f0Z7hbZi00yrsKUNpfgTtHYQ2zk001m2AzL9cqS5C0w83E0HHr
	 6Mu0JW0DV5N/EHSFPKzClSMCve3h2EFsX2WQHW3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 480/817] x86: fix off-by-one in access_ok()
Date: Tue,  3 Dec 2024 15:40:52 +0100
Message-ID: <20241203144014.608019904@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 573f45a9f9a47fed4c7957609689b772121b33d7 ]

When the size isn't a small constant, __access_ok() will call
valid_user_address() with the address after the last byte of the user
buffer.

It is valid for a buffer to end with the last valid user address so
valid_user_address() must allow accesses to the base of the guard page.

[ This introduces an off-by-one in the other direction for the plain
  non-sized accesses, but since we have that guard region that is a
  whole page, those checks "allowing" accesses to that guard region
  don't really matter. The access will fault anyway, whether to the
  guard page or if the address has been masked to all ones - Linus ]

Fixes: 86e6b1547b3d0 ("x86: fix user address masking non-canonical speculation issue")
Signed-off-by: David Laight <david.laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c472282ab40fd..fd89f1c65c947 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2374,12 +2374,12 @@ void __init arch_cpu_finalize_init(void)
 	alternative_instructions();
 
 	if (IS_ENABLED(CONFIG_X86_64)) {
-		unsigned long USER_PTR_MAX = TASK_SIZE_MAX-1;
+		unsigned long USER_PTR_MAX = TASK_SIZE_MAX;
 
 		/*
 		 * Enable this when LAM is gated on LASS support
 		if (cpu_feature_enabled(X86_FEATURE_LAM))
-			USER_PTR_MAX = (1ul << 63) - PAGE_SIZE - 1;
+			USER_PTR_MAX = (1ul << 63) - PAGE_SIZE;
 		 */
 		runtime_const_init(ptr, USER_PTR_MAX);
 
-- 
2.43.0



