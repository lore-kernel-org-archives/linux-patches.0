Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9BC5187C6;
	Wed, 30 Sep 2026 17:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789773; cv=none; b=OhZ7piR8shyF7S45WimyOLvhyN3Yz22fpM0GWeCZBAIwZ7X3Da262aseRAnNUtkCUECVFIhG1GCxmunMXBKmNDDHuwU0HYv7iRvvkT+Tz72fQLyxi2zmqnWZ1dYhdggD3jICj/oQh5HReT/L78JNfh4VXTW3tEzBbZAxMVKrANw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789773; c=relaxed/simple;
	bh=Jp3a7LriCte+pR8N+7iYVuT4hX+WT5YyCTZv+csZNik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7QjTNm6T0cyKeZ0QdNoxwXRwGIyhQfuz6QM8QD359gT2/cNCThVq6lULsQ/gGB9EDygY4nJSp8fXvDeDo5Vh0gQytEIxSk6WFWX7lxQFg2/fLLylzt87VgjjE9K/MukPd91MmwULAnNgDApiRVeywARfQ1llDrqbNPsH69dX4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiUpPWhu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiUpPWhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F751F000FF;
	Wed, 30 Sep 2026 17:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789772;
	bh=bxFaXFXztQp5C3Ee+j0FWuPXyrWKWyWGzNyq77JwSqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GiUpPWhuHiVx5KVzOWPbDiIwPeS2gUV8QhDWUHvEKJhTd+gKv4QypEVwZjbdbi2UU
	 CmiV+9biSDwBUBsaBnoQghfIMPjFAWELlgV6Qbu3/Yd4Bx9oAAvFhb2ho63LiNRqyc
	 KLrYWF++szkvp89XvyRnERbjcG+anP/RMaNwDjcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 550/877] xfs: use correct jiffies comparison function in xchk_maybe_relax
Date: Wed, 30 Sep 2026 17:24:21 +0200
Message-ID: <20260930152426.509345164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Darrick J. Wong <djwong@kernel.org>

commit 984aab2d905a8557fafb27cd9e8713d6d12b3437 upstream.

LOLLM points out that we're supposed to use time_after_eq, not a raw >=
operation here, or else jiffies wraps can go unnoticed.  Fix this.

Cc: stable@vger.kernel.org # v6.10
Fixes: 271557de7cbfde ("xfs: reduce the rate of cond_resched calls inside scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/scrub.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 737a5d6db15f..b093945f3631 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -40,7 +40,7 @@ static inline int xchk_maybe_relax(struct xchk_relax *widget)
 		return 0;
 	widget->resched_nr = 0;
 
-	if (unlikely(widget->next_resched <= jiffies)) {
+	if (unlikely(time_after_eq(jiffies, widget->next_resched))) {
 		cond_resched();
 		widget->next_resched = XCHK_RELAX_NEXT;
 	}
-- 
2.55.0



