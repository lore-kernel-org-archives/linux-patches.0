Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CE53195F3;
	Wed, 17 Sep 2025 12:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113889; cv=none; b=G31cFnojTugevCgJ0sXqGyZCWcDOuG9GjSJR79F3p7OzIYC2S3FRxiwaZ7CPdmmtZ7lNXmoU0K4VrPzMwLL54ObakdzBa5rxysE8CKQTsOIY8zYcmFWwgUlEhQWPm3x2RM/4Xp0zZA7vnt0eX3kOmmKK30d9Qjn+Y3KX5h7O2j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113889; c=relaxed/simple;
	bh=g8Gk9/xWfvrRTa5uiv03Hk+8o4eKF/lzWYPyoOnjNIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0PBfQXftDpSXj76FzJXWCeZ6GRX09PxBXQNT66n6gkMYJbuPyVxlFw2ELbnQKM6BogRX+cq6tKGIX5JDC406OKqQHZS28JtVahF7eHWcO3hOCr4scZUz3MG18j16+EvLY+DB7b3ismfQJY0RZDJkfodToMOWGjH29alRP8XM4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzuUpnqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzuUpnqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5509C4CEF7;
	Wed, 17 Sep 2025 12:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113889;
	bh=g8Gk9/xWfvrRTa5uiv03Hk+8o4eKF/lzWYPyoOnjNIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzuUpnqMyecYFRD5L4NPgmEwNdltvmMjnByDeMnyyaEohJUy6bEfZkMujYajr8ZG5
	 Rr6n2xfFUCPfO/byQC+NZ2eUy7Zq9du8NBGIQK78j/vRP03aJA9/XK+1T32Rx9SEWw
	 kM7RLrZ1cvxIplzM2Aej7pZB1el9++lFcXKcRzVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Tometzki <damian@riscv-rocks.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/101] Disable SLUB_TINY for build testing
Date: Wed, 17 Sep 2025 14:34:50 +0200
Message-ID: <20250917123338.460501630@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 6f110a5e4f9977c31ce76fefbfef6fd4eab6bfb7 ]

... and don't error out so hard on missing module descriptions.

Before commit 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
we used to warn about missing module descriptions, but only when
building with extra warnigns (ie 'W=1').

After that commit the warning became an unconditional hard error.

And it turns out not all modules have been converted despite the claims
to the contrary.  As reported by Damian Tometzki, the slub KUnit test
didn't have a module description, and apparently nobody ever really
noticed.

The reason nobody noticed seems to be that the slub KUnit tests get
disabled by SLUB_TINY, which also ends up disabling a lot of other code,
both in tests and in slub itself.  And so anybody doing full build tests
didn't actually see this failre.

So let's disable SLUB_TINY for build-only tests, since it clearly ends
up limiting build coverage.  Also turn the missing module descriptions
error back into a warning, but let's keep it around for non-'W=1'
builds.

Reported-by: Damian Tometzki <damian@riscv-rocks.de>
Link: https://lore.kernel.org/all/01070196099fd059-e8463438-7b1b-4ec8-816d-173874be9966-000000@eu-central-1.amazonses.com/
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index c11cd01169e8d..046c32686fc4d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -280,7 +280,7 @@ config SLAB
 
 config SLUB_TINY
 	bool "Configure SLUB for minimal memory footprint"
-	depends on SLUB && EXPERT
+	depends on SLUB && EXPERT && !COMPILE_TEST
 	select SLAB_MERGE_DEFAULT
 	help
 	   Configures the SLUB allocator in a way to achieve minimal memory
-- 
2.51.0



