Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAB42D979F;
	Sat, 14 Feb 2026 21:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104372; cv=none; b=kBCMFnIrbzh059ldHyhH4bvymeyezmfKp3+IRFk2kTffJWuE5vwR8YTapFRVS+PbdtdxVT5Ups22ZJOCSlLQOutpqJSfks2e/CYVxfQmCfNwsIiue7RWqNFkBWR8mrnDc9PlvaHZFQFLguGO1jUEJdbVKe6lxbBcY9WcY5aFows=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104372; c=relaxed/simple;
	bh=CXvypTIeB7bqrpF4E6BA7S6xZwcRORKDoYScrPumZ/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=moceIzbVgSh5HGWtKjyTUfXgU88Zn3n+ZorGXNJ5uYm0Jk6U+UZmhr1gfJqxwEl3An6xzQF0ZYGoafZBn1+3WlrQU76Kl6pgxq53jNZkUl8aFiM03Uq4kBrU1Leevcp3PeSDWq2MDJNRfgEOAWoh3osj3pLhda/EzBv44wQ5mhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l877/3MD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l877/3MD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23864C2BC86;
	Sat, 14 Feb 2026 21:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104372;
	bh=CXvypTIeB7bqrpF4E6BA7S6xZwcRORKDoYScrPumZ/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l877/3MDoFO7OLo5HKiA+sEvvLapOziVDBJop/1aa0hGx1SskHE4P/1E1LnZH9ak2
	 s9yubiX6U2v61Vc5YP4Tbr9d/JBXifVAMYN727H86qo/cNd5x4gBK3jRT5VlUbCJ3R
	 WCX/Iyn37yRurOgbMGBpOxFZEivj3JOW8rK7CFOJsYjJZuHvVFn0t0ypbz3rptmZm2
	 6GC33xJ7iCKDX96jNRqpRoynTDf/YWqztaZ9h+gBu3P4IqdeiLKRXcD6mfQkKoRyy8
	 sZxTo1Zw28ZOjHBQfCoRHQ0HDMr6USXXgRWWO0a6Lgm4hY29Iyo+BRmSR1QcozSvnX
	 dJEODxQuJs4vg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	vishnu.dasa@broadcom.com,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] vmw_vsock: bypass false-positive Wnonnull warning with gcc-16
Date: Sat, 14 Feb 2026 16:23:13 -0500
Message-ID: <20260214212452.782265-48-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e25dbf561e03c0c5e36228e3b8b784392819ce85 ]

The gcc-16.0.1 snapshot produces a false-positive warning that turns
into a build failure with CONFIG_WERROR:

In file included from arch/x86/include/asm/string.h:6,
                 from net/vmw_vsock/vmci_transport.c:10:
In function 'vmci_transport_packet_init',
    inlined from '__vmci_transport_send_control_pkt.constprop' at net/vmw_vsock/vmci_transport.c:198:2:
arch/x86/include/asm/string_32.h:150:25: error: argument 2 null where non-null expected because argument 3 is nonzero [-Werror=nonnull]
  150 | #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
net/vmw_vsock/vmci_transport.c:164:17: note: in expansion of macro 'memcpy'
  164 |                 memcpy(&pkt->u.wait, wait, sizeof(pkt->u.wait));
      |                 ^~~~~~
arch/x86/include/asm/string_32.h:150:25: note: in a call to built-in function '__builtin_memcpy'
net/vmw_vsock/vmci_transport.c:164:17: note: in expansion of macro 'memcpy'
  164 |                 memcpy(&pkt->u.wait, wait, sizeof(pkt->u.wait));
      |                 ^~~~~~

This seems relatively harmless, and it so far the only instance of this
warning I have found. The __vmci_transport_send_control_pkt function
is called either with wait=NULL or with one of the type values that
pass 'wait' into memcpy() here, but not from the same caller.

Replacing the memcpy with a struct assignment is otherwise the same
but avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Bryan Tan <bryan-bt.tan@broadcom.com>
Link: https://patch.msgid.link/20260203163406.2636463-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

This commit addresses a **false-positive compiler warning** with
gcc-16.0.1 that becomes a **build failure** when `CONFIG_WERROR` is
enabled. The fix replaces a `memcpy()` call with a direct struct
assignment, which is semantically equivalent but avoids triggering the
`-Wnonnull` warning.

### Code Change Analysis

The change is extremely minimal — a single line change:
```c
- memcpy(&pkt->u.wait, wait, sizeof(pkt->u.wait));
+ pkt->u.wait = *wait;
```

This is a purely mechanical transformation. A struct assignment and a
`memcpy` of the same struct size produce identical behavior. The
compiler generates equivalent code. The only difference is that the
struct assignment form doesn't trigger gcc-16's `-Wnonnull` analysis,
which was producing a false positive by analyzing the `memcpy` call
without considering that the `wait` parameter is only NULL for packet
types that don't reach this code path.

### Classification: Build Fix

This is a **build fix** — one of the explicitly allowed categories for
stable backports. With `CONFIG_WERROR` enabled (which is the default in
many distribution kernel configs and increasingly common), this warning
becomes a hard build error. Users building with gcc-16 and
`CONFIG_WERROR` would be unable to compile the kernel.

### Risk Assessment

- **Risk: Extremely low.** The change is a 1:1 semantic equivalent.
  `pkt->u.wait = *wait` does exactly what `memcpy(&pkt->u.wait, wait,
  sizeof(pkt->u.wait))` does — it copies the struct contents. There is
  zero behavioral change.
- **Scope: One line in one file.** Maximally contained.
- **Testing: Well-reviewed.** Has three `Reviewed-by` tags from relevant
  maintainers (Bobby Eshleman, Stefano Garzarella, Bryan Tan).

### Dependency Check

This commit has no dependencies on other patches. The code being
modified (`vmci_transport_packet_init`) has existed for a long time in
the stable trees.

### User Impact

- Users building the kernel with gcc-16 and `CONFIG_WERROR` will hit a
  build failure without this fix.
- gcc-16 is a snapshot/development compiler now, but will become the
  standard gcc version in distributions. As distributions adopt gcc-16,
  this will become a real issue for stable kernel users.
- Build fixes are critical for the usability of stable kernels.

### Stability Assessment

- The change is trivially correct — struct assignment and memcpy of a
  struct are equivalent.
- Multiple experienced reviewers have confirmed correctness.
- Zero risk of runtime regression.

### Conclusion

This is a textbook stable backport candidate: a minimal, zero-risk build
fix that prevents compilation failure with newer compiler versions. It
falls squarely into the "build fixes that prevent compilation" exception
category. The change is semantically identical to the original code and
has been well-reviewed.

**YES**

 net/vmw_vsock/vmci_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 7eccd6708d664..aca3132689cf1 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -161,7 +161,7 @@ vmci_transport_packet_init(struct vmci_transport_packet *pkt,
 
 	case VMCI_TRANSPORT_PACKET_TYPE_WAITING_READ:
 	case VMCI_TRANSPORT_PACKET_TYPE_WAITING_WRITE:
-		memcpy(&pkt->u.wait, wait, sizeof(pkt->u.wait));
+		pkt->u.wait = *wait;
 		break;
 
 	case VMCI_TRANSPORT_PACKET_TYPE_REQUEST2:
-- 
2.51.0

