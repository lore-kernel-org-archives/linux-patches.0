Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0857119F411;
	Wed,  2 Oct 2024 14:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879627; cv=none; b=CqfCHDeq59uhbdefE/mDm99ytb4/8g2AlM+oi+EVG62K9l3CeMYg+UBGZogogQvhy9OVCRRhz1z+lh4VzQ0hY6BGLVVtBN0OpePuSIBtZXxDFio8MTbjXCwdFpFrPvXj8sRnS267oLweT6IP1EM54hkpCjj73wBOPWAprD3JSak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879627; c=relaxed/simple;
	bh=2axs1V5N+/h/11dhneskzEjIOQhoxfSPDn+ioJXLHiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9xc1E1mSxj2269mgXHUUnUeD3ecJR/nuVzS8sL4z7vOR2LTcpsQWVOYjBJxy/Cv3TXp+66EfZmvMUuQ4Jz5JgrsyBFY/g+e5U0s0V06fM0F3nQaKfPWUfOq/AgWd/Z1xTFjybqjc/i9s7LORgEErCU63pfzbOhnCOYJjMNcQtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYAwrjna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYAwrjna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDBDC4CEC2;
	Wed,  2 Oct 2024 14:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879625;
	bh=2axs1V5N+/h/11dhneskzEjIOQhoxfSPDn+ioJXLHiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYAwrjna+3Fo3tyJoA+WXgpswLVvFOxB8w4peIIqCdzuBAa3AiR8LA1Hb4jbp05mB
	 QgNCWPOvSbHaPtSFX7827+7UICsAauKqVt2v8LiT48wZQLwcD+3jJYYxbHazbfQfLV
	 AEKFeLaLnY+bz/BHW3QOKZhN3KxSmr6am23fdexs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/538] bpf: Disable some `attribute ignored warnings in GCC
Date: Wed,  2 Oct 2024 14:57:02 +0200
Message-ID: <20241002125759.483618929@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose E. Marchesi <jose.marchesi@oracle.com>

[ Upstream commit b0fbdf759da05a35b67fd27b8859738b79af25d6 ]

This patch modifies selftests/bpf/Makefile to pass -Wno-attributes to
GCC.  This is because of the following attributes which are ignored:

- btf_decl_tag
- btf_type_tag

  There are many of these.  At the moment none of these are
  recognized/handled by gcc-bpf.

  We are aware that btf_decl_tag is necessary for some of the
  selftest harness to communicate test failure/success.  Support for
  it is in progress in GCC upstream:

  https://gcc.gnu.org/pipermail/gcc-patches/2024-May/650482.html

  However, the GCC master branch is not yet open, so the series
  above (currently under review upstream) wont be able to make it
  there until 14.1 gets released, probably mid next week.

  As for btf_type_tag, more extensive work will be needed in GCC
  upstream to support it in both BTF and DWARF.  We have a WIP big
  patch for that, but that is not needed to compile/build the
  selftests.

- used

  There are SEC macros defined in the selftests as:

  #define SEC(N) __attribute__((section(N),used))

  The SEC macro is used for both functions and global variables.
  According to the GCC documentation `used' attribute is really only
  meaningful for functions, and it warns when the attribute is used
  for other global objects, like for example ctl_array in
  test_xdp_noinline.c.

  Ignoring this is benign.

- align_value

  In progs/test_cls_redirect.c:127 there is:

  typedef uint8_t *net_ptr __attribute__((align_value(8)));

  GCC warns that it is ignoring this attribute, because it is not
  implemented by GCC.

  I think ignoring this attribute in GCC is benign, because according
  to the clang documentation [1] its purpose seems to be merely
  declarative and doesn't seem to translate into extra checks at
  run-time, only to perhaps better optimized code ("runtime behavior
  is undefined if the pointed memory object is not aligned to the
  specified alignment").

  [1] https://clang.llvm.org/docs/AttributeReference.html#align-value

Tested in bpf-next master.

Signed-off-by: Jose E. Marchesi <jose.marchesi@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20240507074227.4523-3-jose.marchesi@oracle.com
Stable-dep-of: 3ece93a4087b ("selftests/bpf: Fix wrong binary in Makefile log output")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 397306f5cf911..e0f499794f162 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -412,7 +412,7 @@ endef
 # Build BPF object using GCC
 define GCC_BPF_BUILD_RULE
 	$(call msg,GCC-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(BPF_GCC) $3 -O2 -c $1 -o $2
+	$(Q)$(BPF_GCC) $3 -Wno-attributes -O2 -c $1 -o $2
 endef
 
 SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
-- 
2.43.0



