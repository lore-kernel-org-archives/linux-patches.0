Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89201367;
	Sun, 15 Feb 2026 15:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167830; cv=none; b=phaTtK0NS+q6h0mXfpgfYpUR2DpJQvozmH9w/Y/w3M7PVWwwCCUKJNjYwaQlPbMqeYvegIOAMRxhgWToNmeunZG73nd7sBQWQf0bQgYR51rdToDmKiOIfOvPNE1AGUVUSdzGgXrHoMSk+xnbj/LQF4hTg/dyf7qeNH2bC8oqo3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167830; c=relaxed/simple;
	bh=MSRHxs9tlBSugeSwyEqSvKzxDRILbqyLuHzoMk75zc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DzGFKnMomwchaB3w3Pq7boXZlv9rVvKBjcGih71pEQfccGkyrjqNwmENe5lMcTROaMwk920b1O34qPon+uxWizAx8ZnVXni/MALNONXzNxU5A7CSK++Du3otRA7RPbao0F84N8gyScH62KwzPZxMZOygcj3iquxrVSJwBw/HO4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePjnnSGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePjnnSGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B8BC4CEF7;
	Sun, 15 Feb 2026 15:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167830;
	bh=MSRHxs9tlBSugeSwyEqSvKzxDRILbqyLuHzoMk75zc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePjnnSGy50Ba2Ns+YYFIK5CF9fbJkgyS5/dGZJPcba2RtWR9KUI9fCuzWMuRg29Ve
	 q4NWoVsREG6TNpJPc9SwFd2OYY+bXeJ7HNDbceGqOwtbLHvEdxxBe7G4YVOT7QjaQz
	 ZRVkSrwo70YfZCDxL21zF+X+to+mOzsPkZ+V+dOQ/quYBg3CNlVj89FWtlXfrkwQT+
	 5lOp+SiGnMI2UEo/fhr/dPoJxOWUAOL6a98nNpCOwBzzcfyobP1DGcUw2v0AdNwX8I
	 u3qfkor4FjaINh5oeHOG6V7AFV8ZvCx5hVEmyuZYVO58CE9xQrq8py2oc/emN347Bc
	 i/pYGLokMGEEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	benjamin@sipsolutions.net,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.18] um: Preserve errno within signal handler
Date: Sun, 15 Feb 2026 10:03:28 -0500
Message-ID: <20260215150333.2150455-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215150333.2150455-1-sashal@kernel.org>
References: <20260215150333.2150455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit f68b2d5a907b53eed99cf2efcaaae116df73c298 ]

We rely on errno to determine whether a syscall has failed, so we
need to ensure that accessing errno is async-signal-safe. Currently,
we preserve the errno in sig_handler_common(), but it doesn't cover
every possible case. Let's do it in hard_handler() instead, which
is the signal handler we actually register.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20260106001228.1531146-2-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of "um: Preserve errno within signal handler"

### Commit Message Analysis

The commit message clearly describes a bug fix: errno is not being
properly preserved in all signal handler code paths. The fix moves the
errno save/restore from `sig_handler_common()` to `hard_handler()`,
which is the actual registered signal handler. This ensures errno
preservation covers all cases, not just those that go through
`sig_handler_common()`.

### Code Change Analysis

The change is very small and surgical:

1. **Removes** `int save_errno = errno;` and `errno = save_errno;` from
   `sig_handler_common()` (lines removed from inner function)
2. **Adds** `int save_errno = errno;` and `errno = save_errno;` to
   `hard_handler()` (lines added to outer function)

This is a simple relocation of the errno save/restore to a higher-level
function that covers more code paths.

### Bug Mechanism

The bug is about **async-signal-safety**. When a signal handler fires,
it can interrupt code that just set `errno` (e.g., after a failed
syscall). If the signal handler calls functions that modify `errno`
(which many do), the original `errno` value is lost. The caller then
sees a corrupted `errno` and may make incorrect decisions.

The previous code preserved errno only in `sig_handler_common()`, but
looking at the `handlers[]` array, `hard_handler()` dispatches to
multiple handlers:
- `sig_handler` (which calls `sig_handler_common`)
- `timer_alarm_handler`
- `sigusr1_handler`

The `timer_alarm_handler` and `sigusr1_handler` paths were **NOT**
covered by the errno preservation in `sig_handler_common()`. This means
those signal handlers could corrupt errno.

### Classification

This is a **real bug fix**. Corrupted errno in UML (User Mode Linux) can
lead to:
- Incorrect syscall failure detection
- Spurious error handling paths being taken
- Potentially hard-to-diagnose undefined behavior

This falls into the category of a **data corruption / correctness bug**
— the kernel relies on errno to determine syscall success/failure, and a
corrupted errno can cause incorrect control flow.

### Scope and Risk Assessment

- **Lines changed**: ~6 lines (3 removed, 3 added)
- **Files touched**: 1 file (`arch/um/os-Linux/signal.c`)
- **Complexity**: Extremely low — just moving save/restore to a higher
  scope
- **Risk of regression**: Minimal. The errno save/restore pattern is
  well-understood and the change just moves it to a more encompassing
  location. It's logically identical for the paths that already went
  through `sig_handler_common()`, and adds coverage for paths that
  didn't.

### User Impact

This affects UML (User Mode Linux) users. While UML is a niche
architecture, the bug is real — signal handlers corrupting errno can
lead to subtle, hard-to-diagnose failures. The fix is obviously correct.

### Stability Indicators

- Signed off by the UML maintainer (Johannes Berg)
- The pattern of saving/restoring errno in signal handlers is a well-
  established correctness requirement (POSIX async-signal-safety)
- The fix is trivially verifiable by inspection

### Dependency Check

This commit is self-contained. It has no dependencies on other patches.
The code it modifies (`hard_handler()` and `sig_handler_common()`) has
been present in stable kernels for a long time.

### Verdict

This is a small, obviously correct bug fix that:
- Fixes a real async-signal-safety bug (errno corruption)
- Is extremely contained (6 lines in 1 file)
- Has near-zero regression risk
- Affects a real code path (signal handling in UML)
- Meets all stable kernel criteria

**YES**

 arch/um/os-Linux/signal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 327fb3c52fc79..de372b936a804 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -36,7 +36,6 @@ void (*sig_info[NSIG])(int, struct siginfo *, struct uml_pt_regs *, void *mc) =
 static void sig_handler_common(int sig, struct siginfo *si, mcontext_t *mc)
 {
 	struct uml_pt_regs r;
-	int save_errno = errno;
 
 	r.is_user = 0;
 	if (sig == SIGSEGV) {
@@ -50,8 +49,6 @@ static void sig_handler_common(int sig, struct siginfo *si, mcontext_t *mc)
 		unblock_signals_trace();
 
 	(*sig_info[sig])(sig, si, &r, mc);
-
-	errno = save_errno;
 }
 
 /*
@@ -207,8 +204,11 @@ static void hard_handler(int sig, siginfo_t *si, void *p)
 {
 	ucontext_t *uc = p;
 	mcontext_t *mc = &uc->uc_mcontext;
+	int save_errno = errno;
 
 	(*handlers[sig])(sig, (struct siginfo *)si, mc);
+
+	errno = save_errno;
 }
 
 void set_handler(int sig)
-- 
2.51.0

