Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0F61E3DE4;
	Wed, 19 Feb 2025 08:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954703; cv=none; b=NbjVfmlp1toSqDrNHN4vlm+iOhSf8wPuuALvR+XpUrZw54sbAC9j7kmEVEL//UvpVCCWcnEcVWuAC4pi2vzKkj5bv4JonQB9DDePXEJzjl/BZ/ME+4LAtVBTwRbWulAMzHgBS+Jlf4WRXGr4fdJQXiXLfxLKE2lKsfFUemrCiN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954703; c=relaxed/simple;
	bh=q1EgEgIelniAp8Ha+RkC5zUjHa9CO63xrniw2x9UTQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWBmdQAjNnBnaMDO5P978OD+1yD7nFt8nyvFJ23UzLGEYQL4mL+O7sdV3wxIWkTSh5w2rxBkSs+ipCuJwXJkRJGtsOmtYTBr7bul4HaBs0GZrhr1O6i1yUyzGAAChBGZWM/sm1Te2JrtG78xMykkO4yJh0Jyd94pn4DvblAsgSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3fSXflz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3fSXflz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEDAC4CEE6;
	Wed, 19 Feb 2025 08:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954702;
	bh=q1EgEgIelniAp8Ha+RkC5zUjHa9CO63xrniw2x9UTQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3fSXflzVu8M0sg1voWzILerKs7b05hYNTdPt/6Kdhkg/aQph2qF+UAqGyNwDrkh9
	 qeVsnj3+ZRtlZRWGW0Y2lfCKeGdXjZSsszxZ/Pnf4WZuSGK11YPEWat+Y42SFgat5m
	 fc2SmMdyRHMJiK+u6dxXxDlvf8o/X9CF0Cym3EJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/230] scripts/Makefile.extrawarn: Do not show clangs non-kprintf warnings at W=1
Date: Wed, 19 Feb 2025 09:25:28 +0100
Message-ID: <20250219082602.142535412@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 738fc998b639407346a9e026514f0562301462cd ]

Clang's -Wformat-overflow and -Wformat-truncation have chosen to check
'%p' unlike GCC but it does not know about the kernel's pointer
extensions in lib/vsprintf.c, so the developers split that part of the
warning out for the kernel to disable because there will always be false
positives.

Commit 908dd508276d ("kbuild: enable -Wformat-truncation on clang") did
disabled these warnings but only in a block that would be called when
W=1 was not passed, so they would appear with W=1. Move the disabling of
the non-kprintf warnings to a block that always runs so that they are
never seen, regardless of warning level.

Fixes: 908dd508276d ("kbuild: enable -Wformat-truncation on clang")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501291646.VtwF98qd-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.extrawarn | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 04faf15ed316a..d75897559d184 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -31,6 +31,11 @@ KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
 ifdef CONFIG_CC_IS_CLANG
 # The kernel builds with '-std=gnu11' so use of GNU extensions is acceptable.
 KBUILD_CFLAGS += -Wno-gnu
+
+# Clang checks for overflow/truncation with '%p', while GCC does not:
+# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111219
+KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow-non-kprintf)
+KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation-non-kprintf)
 else
 
 # gcc inanely warns about local variables called 'main'
@@ -102,11 +107,6 @@ KBUILD_CFLAGS += $(call cc-disable-warning, packed-not-aligned)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow)
 ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation)
-else
-# Clang checks for overflow/truncation with '%p', while GCC does not:
-# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111219
-KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow-non-kprintf)
-KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation-non-kprintf)
 endif
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
-- 
2.39.5



