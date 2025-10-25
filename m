Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B420304BA2;
	Sat, 25 Oct 2025 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409610; cv=none; b=t6rjF0Fc8YX193+S/BPsaaPIOpqx+jKgt892KFQYkNGZjK/LexQfMqW/0GcOq6WOV788IBL5LCJUMvL89retMrX+2Zdb+Vn8VYekQ9wNVGpD3kz69/wJx/dufV63O2//ZVEedIXBLC15qsrmqgj5wApPoR/2QT4yU0gb1bt0NQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409610; c=relaxed/simple;
	bh=UjTGxiJEJeD8fa9drxq5g7FHOznUXWyZ95IXYz3Xj5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GHZL26723YkeWVy4cUbprxUV3nmOw+ZuMyWdlmO7JNeP3kp0cwgTPZPIccAcJ8TttwSTbW9myXAIkgdh+F0ncmD7ii8s0l/JUrcb57K/eq6o3srU5wL/czdA85Rzy54JzoObPpfyYt7C/XtizS895A2nVnmy6oFPPjwASanJerU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tgndU+3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tgndU+3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37B5C4CEF5;
	Sat, 25 Oct 2025 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409610;
	bh=UjTGxiJEJeD8fa9drxq5g7FHOznUXWyZ95IXYz3Xj5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgndU+3ud9TqH3H+B57HoXLAdd/NIraLQ/t5D9EZMlaRKLpVjRvyYyLjC13TeHZt5
	 VzgUfnQwstRCpZozJzMBHGUZAHELecvrEFp1JpkoE3zZvBl7YAmzxjgEH5yzyzzY9N
	 UP8joECDDjl+DUBgOw4c+Qp0S2i62APpfdxUrWqYpjLmZo/QN5xvUdZnc4nZObpZke
	 hVRXO3YtBps1+rK3jGfLkFogcWXKKiVZLVvD7QaC4DLQKIybXp31F+HfkmOa4L0oNz
	 WD2VScoasVB84+qje9xOMv5BQzTGtCSAob23+Y0sjUW+S1cKLVp3cf93LFuWw+nX7i
	 wQgDJAZxQXTKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ncardwell@google.com,
	davem@davemloft.net,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] net: devmem: expose tcp_recvmsg_locked errors
Date: Sat, 25 Oct 2025 12:00:22 -0400
Message-ID: <20251025160905.3857885-391-sashal@kernel.org>
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

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 18282100d7040614b553f1cad737cb689c04e2b9 ]

tcp_recvmsg_dmabuf can export the following errors:
- EFAULT when linear copy fails
- ETOOSMALL when cmsg put fails
- ENODEV if one of the frags is readable
- ENOMEM on xarray failures

But they are all ignored and replaced by EFAULT in the caller
(tcp_recvmsg_locked). Expose real error to the userspace to
add more transparency on what specifically fails.

In non-devmem case (skb_copy_datagram_msg) doing `if (!copied)
copied=-EFAULT` is ok because skb_copy_datagram_msg can return only EFAULT.

Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250910162429.4127997-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

This is a small, contained bugfix that improves error reporting for the
new MSG_SOCK_DEVMEM TCP receive path without changing normal TCP
behavior. It should be backported to stable trees which already include
the devmem TCP feature.

- Fix scope and change details
  - In the devmem path of `tcp_recvmsg_locked`, errors returned by
    `tcp_recvmsg_dmabuf()` were previously collapsed to `-EFAULT`. The
    patch changes this to expose the original error to userspace and
    only treat strictly negative returns as errors:
    - Change: `if (err < 0) { if (!copied) copied = err; break; }` and
      keep positive `err` as the actual bytes consumed via `used = err`
      (net/ipv4/tcp.c:2839–2847).
    - This replaces the old behavior which treated `err <= 0` as error
      and always returned `-EFAULT` if nothing was copied.
  - The non-devmem (normal) path remains unchanged and keeps mapping
    failures of `skb_copy_datagram_msg()` to `-EFAULT` when no data has
    been copied (net/ipv4/tcp.c:2819–2827). This is correct because
    `skb_copy_datagram_msg` can only fail with `-EFAULT`.

- Error contract and correctness
  - `tcp_recvmsg_dmabuf()` already distinguishes several error cases:
    - `-ENODEV` when a supposed devmem skb has readable frags
      (misconfiguration/unsupported) (net/ipv4/tcp.c:2490–2492).
    - `-ETOOSMALL` when control buffer is too small for CMSG via
      `put_cmsg_notrunc()` (net/ipv4/tcp.c:2515–2520,
      net/core/scm.c:311).
    - `-ENOMEM` on xarray allocation failures in `tcp_xa_pool_refill()`
      (net/ipv4/tcp.c:2567–2570).
    - `-EFAULT` on linear copy failures or unsatisfied `remaining_len`
      (net/ipv4/tcp.c:2500–2505, 2609–2612).
  - Return semantics ensure safety of the `< 0` check: on success, it
    returns the number of bytes “sent” to userspace; on error with no
    progress, it returns a negative errno (net/ipv4/tcp.c:2615–2619).
    Given the caller’s `used > 0`, a zero return from
    `tcp_recvmsg_dmabuf()` is not expected; switching from `<= 0` to `<
    0` avoids misclassifying a non-existent zero as an error and
    prevents false error handling.

- Impact and risk
  - Behavior change is limited to sockets using `MSG_SOCK_DEVMEM`;
    normal TCP receive paths are unaffected.
  - Users now receive accurate errno values (`-ENODEV`, `-ENOMEM`,
    `-ETOOSMALL`, `-EFAULT`) instead of a blanket `-EFAULT`. This
    improves diagnosability and allows appropriate user-space handling
    (e.g., resizing control buffer on `-ETOOSMALL`, backing off on
    `-ENOMEM`, detecting misconfiguration via `-ENODEV`).
  - No ABI or data structure changes; no architectural alterations; code
    change is localized to `net/ipv4/tcp.c`.
  - Selftests for devmem do not assume `-EFAULT` specifically (they only
    treat `-EFAULT` as unrecoverable and otherwise continue), so the
    change does not regress the existing test expectations
    (tools/testing/selftests/drivers/net/hw/ncdevmem.c:940–973).

- Stable suitability
  - Fixes an actual bug (incorrect, lossy error propagation) that
    affects users of a new feature introduced recently (“tcp: RX path
    for devmem TCP”, commit 8f0b3cc9a4c1).
  - Minimal, well-scoped diff; low regression risk; no dependency churn.
  - Backport only to stable series that already contain the devmem TCP
    feature and `tcp_recvmsg_dmabuf()`; it is not applicable to older
    series that predate this feature.

Code references
- Devmem receive error propagation fix: net/ipv4/tcp.c:2839–2847
- Non-devmem path (unchanged, still maps to -EFAULT only):
  net/ipv4/tcp.c:2819–2827
- `tcp_recvmsg_dmabuf()` error sources and contract:
  - `-ENODEV`: net/ipv4/tcp.c:2490–2492
  - `-EFAULT` (linear copy): net/ipv4/tcp.c:2500–2505
  - `-ETOOSMALL` via `put_cmsg_notrunc`: net/ipv4/tcp.c:2515–2520;
    definition returns `-ETOOSMALL`/`-EFAULT`: net/core/scm.c:311
  - `-ENOMEM` via xarray: net/ipv4/tcp.c:2567–2570
  - Return negative only if no bytes sent: net/ipv4/tcp.c:2615–2619

 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ba36f558f144c..f421cad69d8c9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2821,9 +2821,9 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 
 				err = tcp_recvmsg_dmabuf(sk, skb, offset, msg,
 							 used);
-				if (err <= 0) {
+				if (err < 0) {
 					if (!copied)
-						copied = -EFAULT;
+						copied = err;
 
 					break;
 				}
-- 
2.51.0

