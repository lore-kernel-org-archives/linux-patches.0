Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9252F12CE;
	Thu, 16 Jul 2026 14:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211369; cv=none; b=DbOEUkwfvR3jh200Kt+vrVvEFMfQXJUD9m0zoK4cFv38AtaOG09+ssXuqHZ7i/ueQZhHO2OVnaKBSDz7rl2s++GL3h/1MKKRYbgsq0nkfVsBcsuLPqeHdAc55lgCQXlIhvEJbetCU1QuF1y8zcCQq+i6cKHUvt0OYoEI+DlGHJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211369; c=relaxed/simple;
	bh=PHbh8g8YNq5iHOf0pmWxmEUfHWFeb7j+UU8+bZlzXm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2NPdsyONbMePOz0Ikc2jzXYHSbA7++NxtjLa+UfcX6l5YtePxbSxkvFmY6guJaQ2Y6Ka5U3Uv3xDYexJfVJqFfwydm3jI/JTpqTjsSOUoOCipcOjhcYxQpKtNCKBXLt0E/bqnXvOPvdl6WzPQyZ1D29hyvSR2zwtLyzycs6Yv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeUxpGZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeUxpGZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB30D1F000E9;
	Thu, 16 Jul 2026 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211367;
	bh=y8E2ear7j6tUwFxrvI+1A5bBoh9LCV55xxLTISmsSmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UeUxpGZZHV3xhvtJAc4aIL6y6PZDVL4MGPrcHdHBE+GrJPddz7jxJuUtQuFfG0MkU
	 vS8Kzc2TzqB2td4zreBAWsyUdhgJKuQ3o3Ml0JnRW5rSYPHhzVzQT836cLdr8I6PFB
	 jJCo4Mna43NyvltGgxCnh0U0LB6zUmtmAnpqL2qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Jason A. Donenfeld" <jason@zx2c4.com>,
	Liam Howlett <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 400/480] mm: fix mmap errno value when MAP_DROPPABLE is not supported
Date: Thu, 16 Jul 2026 15:32:27 +0200
Message-ID: <20260716133053.459079642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Yznaga <anthony.yznaga@oracle.com>

commit d86c9e971af2315119a78c564a802fafcebf1b6b upstream.

Patch series "fix MAP_DROPPABLE not supported errno", v4.

Mark Brown reported seeing a regression in -next on 32 bit arm with the
mlock selftests.  Before exiting and marking the tests failed, the
following message was logged after an attempt to create a MAP_DROPPABLE
mapping:

Bail out! mmap error: Unknown error 524

It turns out error 524 is ENOTSUPP which is an error that userspace is not
supposed to see, but it indicates in this instance that MAP_DROPPABLE is
not supported.

The first patch changes the errno returned to EOPNOTSUPP.  The second
patch is a second version of a prior patch to introduce selftests to
verify locking behavior with droppable mappings with the additional change
to skip the tests when MAP_DROPPABLE is not supported.  The third patch
fixes the MAP_DROPPABLE selftest so that it is run by the framework and
skips if MAP_DROPPABLE is not supported.


This patch (of 3):

On configs where MAP_DROPPABLE is not supported (currently any 32-bit
config except for PPC32), mmap fails with errno set to ENOTSUPP.  However,
ENOTSUPP is not a standard error value that userspace knows about.  The
acceptable userspace-visible errno to use is EOPNOTSUPP.  checkpatch.pl
has a warning to this effect.

Link: https://lore.kernel.org/20260416033939.49981-1-anthony.yznaga@oracle.com
Link: https://lore.kernel.org/20260416033939.49981-2-anthony.yznaga@oracle.com
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reported-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -502,7 +502,7 @@ unsigned long do_mmap(struct file *file,
 			break;
 		case MAP_DROPPABLE:
 			if (VM_DROPPABLE == VM_NONE)
-				return -ENOTSUPP;
+				return -EOPNOTSUPP;
 			/*
 			 * A locked or stack area makes no sense to be droppable.
 			 *


