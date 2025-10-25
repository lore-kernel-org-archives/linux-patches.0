Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856B02777FC;
	Sat, 25 Oct 2025 16:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408811; cv=none; b=Rxwu3l2s9QVMCOy/h3CkhVzlXzsl86CaHWwg61rizpPzsgNJMRKwlxZUUVf5T+Q1XO8VVOCDq6M1Yx+r5ZU+oJev0Q1gPb3DoIKbn1n5yMZdZj9Efh6AQ3uSO0aJl1mp2gRV4B3ZmuUPtNMrRh+LlmEnQn59qAGNV7tLLn7CY/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408811; c=relaxed/simple;
	bh=UVH1gtVLWpsrqgQIkk/TLC40r/51v3Q83pL2lOrp1lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ApwOrQJbuHbiQ08MRNPyCTrtH77WrhSb4nsruURdyE+DCR1scJa7l4pk7ZmzuLA56TjaJvb/xZqhRCdzxy873czbdEDTl6a6Eu0b1P+ROu90vrck3i++ZZ/BOLwB9h36mLaU2l2L+GSMGuZae9irk2KPAzrHDnt1hHYUuqY1njg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HV1WKp7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HV1WKp7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6755EC4CEFB;
	Sat, 25 Oct 2025 16:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408811;
	bh=UVH1gtVLWpsrqgQIkk/TLC40r/51v3Q83pL2lOrp1lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HV1WKp7AAqDCW+/nDqcKBEiI5IoMdv+qH6/Q0IhHPsC4WVaUbAVwYOYGYkPJf3O5M
	 l8eUSlwMXhzqcUs+dMjq0erc6Ni/Y2E6pYps8sMFjVWTtkKcF88ghS+v6r2hs2wvUU
	 2KfsVdK0RsEIzVA8ABFhqGPHrftjzz7IWs4kMTb8ieo8rz/ay58CPBWMnkblm2OfxY
	 i8eLzoPejwLqC8R5LaqmjaQwQlZF/9B7HYd6HDEy//3U0ddKXCz+t9b/DHFyjVNt94
	 ixwShvIjncahk8l8D6s76PPRZmdnglbz+wgtWK5CSdj3WhwdGqiR707oP6IOoohc7N
	 I1gpzYe0muW2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] selftests/net: Ensure assert() triggers in psock_tpacket.c
Date: Sat, 25 Oct 2025 11:55:10 -0400
Message-ID: <20251025160905.3857885-79-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wake Liu <wakel@google.com>

[ Upstream commit bc4c0a48bdad7f225740b8e750fdc1da6d85e1eb ]

The get_next_frame() function in psock_tpacket.c was missing a return
statement in its default switch case, leading to a compiler warning.

This was caused by a `bug_on(1)` call, which is defined as an
`assert()`, being compiled out because NDEBUG is defined during the
build.

Instead of adding a `return NULL;` which would silently hide the error
and could lead to crashes later, this change restores the original
author's intent. By adding `#undef NDEBUG` before including <assert.h>,
we ensure the assertion is active and will cause the test to abort if
this unreachable code is ever executed.

Signed-off-by: Wake Liu <wakel@google.com>
Link: https://patch.msgid.link/20250809062013.2407822-1-wakel@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - Adds `#undef NDEBUG` before including `assert.h` in
    tools/testing/selftests/net/psock_tpacket.c:24 so that `assert()`
    (and the local `bug_on()` wrapper) are active during kselftest
    builds.

- Why it matters
  - The function `get_next_frame()` lacks a return in the `default`
    switch case (tools/testing/selftests/net/psock_tpacket.c:365). That
    case currently only calls `bug_on(1);` which is defined as
    `assert(!(cond))`. If `NDEBUG` is defined, `assert()` compiles to a
    no-op, leaving the function without a return statement on that path,
    triggering a compiler warning (and theoretically undefined behavior
    if ever executed).
  - Other functions that use `bug_on(1)` already append a dummy `return
    0;` for the `NDEBUG` case, e.g.
    tools/testing/selftests/net/psock_tpacket.c:203 and
    tools/testing/selftests/net/psock_tpacket.c:322. `get_next_frame()`
    is the outlier.

- Correctness and intent
  - With `#undef NDEBUG`, `bug_on(1)` expands to an `assert(false)`
    which calls a `noreturn` failure path, so the compiler no longer
    warns about a missing return. More importantly, the test will abort
    if unreachable code is ever hit, matching the original author’s
    fail-fast intent rather than silently proceeding.
  - This is a common kselftest pattern; several selftests explicitly
    `#undef NDEBUG` to ensure assertions fire (for example,
    tools/testing/selftests/proc/read.c:22).

- Scope and risk
  - Selftests-only change; no in-kernel code or ABI touched.
  - Very small, localized change with no architectural implications.
  - Improves test reliability and eliminates a build warning that can be
    promoted to an error in stricter build environments.
  - No behavioral change in normal paths: `ring->version` is set to one
    of TPACKET_V1/V2/V3, so the `default` path should never be taken. If
    it is, failing loudly is desirable for a test.

- Stable backport criteria
  - Fixes a real issue for users of the stable kselftest suite
    (warning/possible -Werror build failure and loss of assert
    coverage).
  - Minimal risk and fully contained to
    `tools/testing/selftests/net/psock_tpacket.c`.
  - Does not introduce features or architectural changes; purely a test
    robustness fix.

Given the above, this is a low-risk, test-only fix that improves
correctness and build reliability, and is appropriate for stable
backporting.

 tools/testing/selftests/net/psock_tpacket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/psock_tpacket.c b/tools/testing/selftests/net/psock_tpacket.c
index 0dd909e325d93..2938045c5cf97 100644
--- a/tools/testing/selftests/net/psock_tpacket.c
+++ b/tools/testing/selftests/net/psock_tpacket.c
@@ -22,6 +22,7 @@
  *   - TPACKET_V3: RX_RING
  */
 
+#undef NDEBUG
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
-- 
2.51.0

