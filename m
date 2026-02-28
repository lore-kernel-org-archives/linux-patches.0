Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9424ADDAA;
	Sat, 28 Feb 2026 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301314; cv=none; b=ISm3+70NrrMRXQTm2NW5BUflofih9G9vDpPP6P/ohnbdeeS3nFwu669vBFTWeaimj/+skvna6yW8HgZUN0dzabS6/QfaudBjhgerI632PXA6zCrmpYytYEK7UCULvNG4g+rhrlmbmUpusrTsKPUV0Ys/eHSLjq49WN9wXDR01/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301314; c=relaxed/simple;
	bh=NIe5ewymfBNyGwxS6oPATd5QwlJVEWcZ8T7S1YXObKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY+NBnd1ZvnfZMJ3MyWoHonLoJmym0lbSpy0+0ia/OgK/HqbclaF9CjuhAMTq/PRrACb7mfpAcuMdqqFjSTTYNNDPYFvbdfImvPU6rzrGQAilr2epFUaQ2GchbQ7cTPotTCAKXG6AuAt4W3l+O6+DpGh6k8xdVah+zjSaE7n4KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ac9vTvmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ac9vTvmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D0EC19423;
	Sat, 28 Feb 2026 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301313;
	bh=NIe5ewymfBNyGwxS6oPATd5QwlJVEWcZ8T7S1YXObKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ac9vTvmCDi6VT338MkrwnKpZrejh9qFyBCvQrVSaUnRaKexwLYBb+3HkgYJgT7Xa8
	 pc3jAHlU/ES7afu9Q3bEknMUd5yQWK4PqacVHJE7nuRxaQL/FczJ9NWq3GCFmjgbOu
	 yvY3NE+IGoLzDj25ZbBhxRNstLK1MZIoHsSZp3HkKDqkghZcyFYoB8p6xFSFcWwjsQ
	 qf1XC+BYudvp6Pt83mCBMQepo088Ps1/bTQvUUSGzF8RPt2X/cQuRImmZfmdylSryR
	 dqzP5sx514PVxWTdsloOXyYoQJBIk9SbkisacmOIte4/+3OcWp20soZuP3Se+omekx
	 hcbY7UtP0Ub7A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Breno Leitao <leitao@debian.org>,
	stable@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 499/752] arm64: Disable branch profiling for all arm64 code
Date: Sat, 28 Feb 2026 12:43:30 -0500
Message-ID: <20260228174750.1542406-499-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f22c81bebf8bda6e54dc132df0ed54f6bf8756f9 ]

The arm64 kernel doesn't boot with annotated branches
(PROFILE_ANNOTATED_BRANCHES) enabled and CONFIG_DEBUG_VIRTUAL together.

Bisecting it, I found that disabling branch profiling in arch/arm64/mm
solved the problem. Narrowing down a bit further, I found that
physaddr.c is the file that needs to have branch profiling disabled to
get the machine to boot.

I suspect that it might invoke some ftrace helper very early in the boot
process and ftrace is still not enabled(!?).

Rather than playing whack-a-mole with individual files, disable branch
profiling for the entire arch/arm64 tree, similar to what x86 already
does in arch/x86/Kbuild.

Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kbuild | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Kbuild b/arch/arm64/Kbuild
index 5bfbf7d79c99b..d876bc0e54211 100644
--- a/arch/arm64/Kbuild
+++ b/arch/arm64/Kbuild
@@ -1,4 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+# Branch profiling isn't noinstr-safe
+subdir-ccflags-$(CONFIG_TRACE_BRANCH_PROFILING) += -DDISABLE_BRANCH_PROFILING
+
 obj-y			+= kernel/ mm/ net/
 obj-$(CONFIG_KVM)	+= kvm/
 obj-$(CONFIG_XEN)	+= xen/
-- 
2.51.0

