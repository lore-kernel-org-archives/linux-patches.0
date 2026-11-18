Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047556;
	b=CFnoLxd9db8jrQBowGumKdz288IXqw69pUko0ME2oZjQhbTSJ+LkidzJR+DhmdkXhOXk
	 VWHd8As8nJjaSrgbjiVkxOItW2or8NQpbeFPO0dsnJX4YtDxEGImpLMXmr/PjOr3HM0+P
	 vZqM2Fi3JairnpVM71IJGHEXEyGMZtpQvRYFFZJfoXyhgdonR6zEXdV0wycGEq263mAr4
	 aHnpL/+GBuTgyjU2Y5J3d9mXTzyn4W9eDTooF6M7WwM6f8q+gVrp8QzgigweXZjhHeEPr
	 4t9c5JKIYtpldCcDzWl91WSeRdZKSjmPslJuWA7MmfsGHeKzpdEMcz4gJIa2wQj5wXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EOw4gjDaVLxN9+P6QWvTCCbkvvFGwcTCATHdwson/x4=;
	b=3G+rmxiLxZLqbUeg/S/CO46TnZrtfuYil0VirVlGz5cXqQACLlFizqNNGXMKAxAVJblF
	 H6HgGTFy1wTA3EvetRXbJBYt1HcjKFro1JSIxaGpssPV0qcxEb/a0E4FzG/wx1ZtzBCLC
	 oRcnDx44DTKqzxH3SBpyjSHbeFqRgn6HXs67mOf8HjVARoMu25If0hhmudvX5vsCSpgjV
	 2+KV+t5LmxwIxcvwCITtwyLkCGdLFHwQzmpZAbXHLPuup4ZzIyaqUmqPrGdSK2/PcWSWb
	 zt419GBKk1AGZ0hBXUX1xWTYDFG/+qNsDnbdK1d9Tteyi0AeL27BuSfH45pqEHkvUiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gImfOkh4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8FD606A320;
	Thu, 19 Nov 2026 00:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gImfOkh4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82111F000C4;
	Thu, 19 Nov 2026 00:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047556;
	bh=EOw4gjDaVLxN9+P6QWvTCCbkvvFGwcTCATHdwson/x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gImfOkh4W0Q8lnxa5O2k3mha5mMgEF7gDdG96v6lZzZxJN6qsHH5YfjB4TeGreWNs
	 OL42UGnSzw7+NaGTdFIQDKUn/tDFSFRuATwJwOkQ8bJgxASMA+OBETcMXDW8gJpyMQ
	 hIbsaJ2AEt6AJgwaHw526YV/dO7tiu8Q6C+ym0mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1679/2857] mm/userfaultfd: compare exact registration modes before skipping
Date: Wed, 18 Nov 2026 15:45:13 +0100
Message-ID: <20261118150301.785070785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 05f64f211a25f7d9771d4fde109aad97174a1cf3 ]

Changing registration from MISSING|WP to WP returns success but leaves
MISSING enabled. The no-op check sees that WP is already set and skips
the update, so later accesses to missing pages still wait for userspace.

Skip the update only when the current and requested UFFD modes match
exactly.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: apply fixup from Lorenzo ]
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-26-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: replaced VMA flag helpers with a direct vm_flags bitmask comparison ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 7a23fa700ffd1..00690ada9c7b0 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1464,7 +1464,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    (vma->vm_flags & vm_flags) == vm_flags)
+		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
 			goto skip;
 
 		if (vma->vm_start > start)
-- 
2.53.0



