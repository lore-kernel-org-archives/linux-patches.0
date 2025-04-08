Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A7526AA99;
	Tue,  8 Apr 2025 12:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114853; cv=none; b=kn6Yrn2Fqem0rQObRCgnYo7Px68ctemk8iSZCyRWSiVOZ4W+7usIRXZ1ehXKw5/Rsiy+4Vw+fn6OitYEqVKzcGYbMxlE8/NFv3kdKuZgDVY/ad15Rw/kHjEd8pXOQX0LjjD3JBA/nd0qYhC41Zzuyem/Gk6tdOmx7RJutosbi+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114853; c=relaxed/simple;
	bh=8sbn9Yld6rBy07iUYyOHmjIAF1YzbEr8SOpcJsPF3G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kypqmEEvBaIOC6k+SNUFFmW1VzjpKo6lNY+PrTA3DSmDO7rNvwoNUAhq+uiPmLk9S0MeMcNt5vF2Cix8cYfTCcdb8XRLIcPDBngeHCyxyYFVWkbfb1TEKm/E9EoJ2vw1QWKkzqxDXCL68KJkOW0AXaACuNkrfiD/YfDjuhas41Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRqiGdkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRqiGdkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01642C4CEE5;
	Tue,  8 Apr 2025 12:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114853;
	bh=8sbn9Yld6rBy07iUYyOHmjIAF1YzbEr8SOpcJsPF3G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRqiGdkE52p4WxShOGCxQhcirKAW4h3VWEfYHUoSi8M4/hgZwa18vv3Jrdph0lhsd
	 7w/5zU1PUPb5xCfN3Xa6KByWzOMUpFb3FlLk1Ri233cE+D75jIg4mBjAE6wRBlbO4s
	 ss6A/+hHVsgkDV+qbiMTLbA8TGg4o3ewDtG+c+ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 252/499] um: Pass the correct Rust target and options with gcc
Date: Tue,  8 Apr 2025 12:47:44 +0200
Message-ID: <20250408104857.501363211@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: David Gow <davidgow@google.com>

[ Upstream commit 5550187c4c21740942c32a9ae56f9f472a104cb4 ]

In order to work around some issues with disabling SSE on older versions
of gcc (compilation would fail upon seeing a function declaration
containing a float, even if it was never called or defined), the
corresponding CFLAGS and RUSTFLAGS were only set when using clang.

However, this led to two problems:
- Newer gcc versions also wouldn't get the correct flags, despite not
  having the bug.
- The RUSTFLAGS for setting the rust target definition were not set,
  despite being unrelated. This works by chance for x86_64, as the
  built-in default target is close enough, but not for 32-bit x86.

Move the target definition outside the conditional block, and update the
condition to take into account the gcc version.

Fixes: a3046a618a28 ("um: Only disable SSE on clang to work around old GCC bugs")
Signed-off-by: David Gow <davidgow@google.com>
Link: https://patch.msgid.link/20250210105353.2238769-2-davidgow@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile.um | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Makefile.um b/arch/x86/Makefile.um
index a46b1397ad01c..c86cbd9cbba38 100644
--- a/arch/x86/Makefile.um
+++ b/arch/x86/Makefile.um
@@ -7,12 +7,13 @@ core-y += arch/x86/crypto/
 # GCC versions < 11. See:
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99652
 #
-ifeq ($(CONFIG_CC_IS_CLANG),y)
-KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
-KBUILD_RUSTFLAGS += --target=$(objtree)/scripts/target.json
+ifeq ($(call gcc-min-version, 110000)$(CONFIG_CC_IS_CLANG),y)
+KBUILD_CFLAGS +=  -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
 KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
 endif
 
+KBUILD_RUSTFLAGS += --target=$(objtree)/scripts/target.json
+
 ifeq ($(CONFIG_X86_32),y)
 START := 0x8048000
 
-- 
2.39.5



