Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101486136;
	Mon, 23 Jun 2025 22:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716022; cv=none; b=ctZZYInmMxnNLxA9aSfkUP3nQYuuP0LtV2vPLqSZ3E1ZHISz3G0GKzcOmZR4UF6zavyI/30Hhn1S8gnPzBlQcwCNu/52bQXx4nMpG9ClfScRMj/FFXMv9phEFyXUtnMSZiZSgztMdUB2U/OXyr4VLha0ddpbH2qfnF08TP6poAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716022; c=relaxed/simple;
	bh=ZiBURmDAdIvI9ImGBQhhk3U4J/gfaFI20z5jU34vRGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwaeX7t6r9vjvmxSlWgB/WmH/vHa+kOUdPtzcYm4/Ob5NttLf2X4knL0xh8h0E6y0UWFyuacmfPDrmnVodJtMU7dLObCFglRlYEiqa6UWIJOZgCVVtdjRgJbwIRLqi+fUen8UxRtp9FngYZMcMCcEScTuFEQAmUjSdLYpjmx08k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNgT2/xA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNgT2/xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB18C4CEEA;
	Mon, 23 Jun 2025 22:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716021;
	bh=ZiBURmDAdIvI9ImGBQhhk3U4J/gfaFI20z5jU34vRGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNgT2/xAjWrKlH15ANjouzcCuUomAHR8FAnq3hsKArERe2/zZy3CZkAAJywAfXJIo
	 us2whHPoqpqfAMEbcK3uK2iqH3OD+SR1oVOVcqI0UnLldJXt18TAT4XznCk3YqYxpo
	 cVDahBQT5BN6bYn5PvsvqcnNggKjYeAck+6DEYdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Barry Song <21cnbao@gmail.com>,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 497/592] mm/madvise: handle madvise_lock() failure during race unwinding
Date: Mon, 23 Jun 2025 15:07:35 +0200
Message-ID: <20250623130712.254231443@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 9c49e5d09f076001e05537734d7df002162eb2b5 upstream.

When unwinding race on -ERESTARTNOINTR handling of process_madvise(),
madvise_lock() failure is ignored.  Check the failure and abort remaining
works in the case.

Link: https://lkml.kernel.org/r/20250602174926.1074-1-sj@kernel.org
Fixes: 4000e3d0a367 ("mm/madvise: remove redundant mmap_lock operations from process_madvise()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Barry Song <21cnbao@gmail.com>
Closes: https://lore.kernel.org/CAGsJ_4xJXXO0G+4BizhohSZ4yDteziPw43_uF8nPXPWxUVChzw@mail.gmail.com
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1832,7 +1832,9 @@ static ssize_t vector_madvise(struct mm_
 
 			/* Drop and reacquire lock to unwind race. */
 			madvise_unlock(mm, behavior);
-			madvise_lock(mm, behavior);
+			ret = madvise_lock(mm, behavior);
+			if (ret)
+				goto out;
 			continue;
 		}
 		if (ret < 0)
@@ -1841,6 +1843,7 @@ static ssize_t vector_madvise(struct mm_
 	}
 	madvise_unlock(mm, behavior);
 
+out:
 	ret = (total_len - iov_iter_count(iter)) ? : ret;
 
 	return ret;


