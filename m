Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585857;
	b=Yq++Kki3UK5PFYcpQ26RpdeJvM9kvy0kStuwT/q0PeitX9XCAB5kY5b90GID+EK9u/KW
	 6QhhJLvCldKQYkncU3oWkIjJWp6rhlpxUuPzfylhPNFc59vvS4KvR/fY1XkucEEEHjV73
	 v1Dc+bhi7x5v5PoB0zLg5GZ9bh11I004j9p+xQr+dRaPValD2trhUldOnDgk76FcqKFao
	 EJFuiS7+hsp9uv5Xi10D69PhVHu9+fhbqduF+JHPRYzVXR2EdAE2oFXGT/VlCFITltIbK
	 9rZTP7EkB7dJAfgmid7qnFAVr+9NCmqyistc4ueIg/tV7l9cRkg/7qp6FqYv51zg/0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xKsNHSdYfIu+ASw1nd223rw0v2Mqd9QyIZoY541N/GA=;
	b=O1vd/aus0geoUxbvYM7FZqUNciA11ihqOIEOQUHq+1gLjVOdbntYG6hVyIt4reD3+rnj
	 ixAAZ3ioo/Y9PY1OWxL9bQSwqw9Q0gRjT5VbRtQrKQEw+FKsgnPIdAxE5qSvSF2NPRfMv
	 sjuEZb1aao6AawvH0G4mrpfI6GQ5E0Y2iDbKBITX2j93SgK9k9dxUyl1nZI0aA3SJPoLY
	 vicrDbpxOpwIYQa3llQdLmW+78WZHvetG+g2mb40XHN/0CPpy9pdyk/vLQSaw32WAOg4K
	 oc9MtP6vR7KL/0j+lUDQrjHZLrR6oBzEBbe7ZbUuAtdwEhh3x0qkywdktfavBVwzbDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bQCsqCDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DE6606BAB8;
	Fri, 13 Nov 2026 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bQCsqCDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D4F1F000C4;
	Fri, 13 Nov 2026 16:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585857;
	bh=xKsNHSdYfIu+ASw1nd223rw0v2Mqd9QyIZoY541N/GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQCsqCDUSMr+ME9GM73lbOSvcDqQ3Ps/pW7nCbqDskiFVX/fq+y5WSUTXpBKHsCCE
	 PY0AcHEBt8GcLT4mDwjqAUPCIczPa3OypGpm6JkokyAuGO67jRgHt+43c1UH8vz42I
	 fIez0Bp4iaC1SHYm7evENKXHXcwrJcMwikQ6G7zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 432/507] x86/mm: Fix global ASID handed out to two processes
Date: Fri, 13 Nov 2026 10:52:16 -0500
Message-ID: <20261113153811.383741402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 5cdc3746fa163fb4e8d05fa3cabf46bc6aa7df75 ]

On AMD CPUs with INVLPGB, two live processes can get the same MAX_ASID_AVAILABLE
global ASID value. The two then hit each other's TLB entries, so each can read
or corrupt the other's memory.

The global ASID space is managed lazily. When a global ASID is freed, its bit is
set in the global_asid_freed bitmap. Once the free ASID search reaches the end
of the global_asid_used bitmap, a global flush is done to really reclaim the
lazily freed global ASIDs.

However, the current code can assign the same global ASID to two different
processes, if one process is assigned MAX_ASID_AVAILABLE - 1, another process
MAX_ASID_AVAILABLE, and both stick around (keeping their global ASID numbers in
use) until the search wraps around again.  At that point a third process could
also get assigned MAX_ASID_AVAILABLE.

    the highest ASID stays in use, so it is not handed out again
      last_global_asid stays below it, so no reset
        the clear bits run out
          find_next_zero_bit() returns MAX_ASID_AVAILABLE
            global_asid_available > 0, so the failure is not caught
              MAX_ASID_AVAILABLE is handed out as an ASID

A search only looks at the bits below MAX_ASID_AVAILABLE, so it cannot see that
this value is in use. The next failed search hands it out again, even if the
first process still holds it.

The fix used here is to reset the global ASID space after a failed search, and
to search again. If that search fails too, no global ASID is handed out.

The test for !global_asid_available is removed, because use_global_asid() only
calls allocate_global_asid() if global_asid_available > 0. The remaining test is
for a condition that should be impossible.

  [ riel: simplify code, massage changelog and comment ]

Fixes: d504d1247e36 ("x86/mm: Add global ASID allocation helper functions")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/tlb.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 0c4da320831cb..53dcab39566f2 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -320,13 +320,19 @@ static u16 allocate_global_asid(void)
 
 	lockdep_assert_held(&global_asid_lock);
 
-	/* The previous allocation hit the edge of available address space */
-	if (last_global_asid >= MAX_ASID_AVAILABLE - 1)
-		reset_global_asid_space();
-
 	asid = find_next_zero_bit(global_asid_used, MAX_ASID_AVAILABLE, last_global_asid);
 
-	if (asid >= MAX_ASID_AVAILABLE && !global_asid_available) {
+	/*
+	 * Nothing is free between last_global_asid and MAX_ASID_AVAILABLE.
+	 * Flush lazy-freed ASIDs and reset the search space.
+	 */
+	if (asid >= MAX_ASID_AVAILABLE) {
+		reset_global_asid_space();
+		asid = find_next_zero_bit(global_asid_used, MAX_ASID_AVAILABLE,
+					  last_global_asid);
+	}
+
+	if (asid >= MAX_ASID_AVAILABLE) {
 		/* This should never happen. */
 		VM_WARN_ONCE(1, "Unable to allocate global ASID despite %d available\n",
 				global_asid_available);
-- 
2.53.0



