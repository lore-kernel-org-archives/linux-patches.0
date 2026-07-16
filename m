Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B901442903B;
	Thu, 16 Jul 2026 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211339; cv=none; b=GWNkQv0M5t0ABx766UyZQ50EhH5cfAM/fM5QoRkHHd7aopmeuey2qMIHsw4C/RZQmXCqgdRv+OBJJkmDkJiSSRQ5gSxMcUEQrxhm6X3UQVTE8nN9RNZ0QTPNyqMxwKyE9v04olKv8DB9/cVrXktTjFKliwrCCwptEaF08MKvQyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211339; c=relaxed/simple;
	bh=0gZ+LHBZ/V8gwtIp3pwMuaNBIdaI/K3vW8gQk8X9dE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBh6ZsbNNCrkMXB6sv3g1hvOcWXo4fcoTB01jcnep+rARr3gfdbCtB1JTHwC2gy1fmLXjNbMdgEvmnXI2KjUkDwjsUpKPup7B4LT6R8emJcgeeZcUGbe2JlMgztoqa+33DJV65VOTNhm1fW5F+vE087SKoWc6YFU9kzIKlmGQxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmqlrDem; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmqlrDem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BB91F000E9;
	Thu, 16 Jul 2026 14:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211338;
	bh=kToMn4EQq0b39Wn1884w9LhnEtWO0UBxEe+A24iHmu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pmqlrDemoNRgaMZsy2NzTNkAT3XryJciYe5kQaq7ow6Tb39lhxGC5B4TufyoX+7UX
	 WOsDceFmYgdSpPKl5PjgumsSQP8Co0Qm3mgZzzufLBGTZiLJqcjJf3AwC12fFridla
	 k0nryEapxOqb0Et1+BbVk0wjUrTKHbPJ9rS2yG+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jia Jie <jiajie.lee@starlabs.sg>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.18 390/480] perf/aux: Fix page UAF in map_range()
Date: Thu, 16 Jul 2026 15:32:17 +0200
Message-ID: <20260716133053.236847920@linuxfoundation.org>
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

From: Lee Jia Jie <jiajie.lee@starlabs.sg>

commit 5948aaf64f81f217a25dcc2bf6c0779bca19566c upstream.

map_range() reads rb->aux_pages[], rb->aux_nr_pages and rb->aux_pgoff via
perf_mmap_to_page() while holding only event->mmap_mutex. Those fields are
serialized by rb->aux_mutex, and mmap_mutex is per event.

Thus, two events sharing one rb via PERF_EVENT_IOC_SET_OUTPUT can race
rb_alloc_aux() with map_range(), leading to a page-UAF scenario as follows:

  CPU 0                           CPU 1
  =====                           =====
  rb_alloc_aux()                  map_range()
  [1]: allocate rb->aux_pages[0]
  [2]: rb->aux_nr_pages++
                                  [3]: perf_mmap_to_page()
                                         returns rb->aux_pages[0]
                                  [4]: map it as VM_PFNMAP
  [5]: rb->aux_pgoff = 1

  munmap the page
  [6]: free rb->aux_pages[0]

Pages mapped as VM_PFNMAP have no refcount protection, so CPU 1 holds a
mapping to a freed physical frame.

Fix this by taking rb->aux_mutex across the page walk in map_range().

Fixes: b709eb872e19 ("perf: map pages in advance")
Signed-off-by: Lee Jia Jie <jiajie.lee@starlabs.sg>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6879,6 +6879,8 @@ static int map_range(struct perf_buffer
 	int err = 0;
 	unsigned long pagenum;
 
+	guard(mutex)(&rb->aux_mutex);
+
 	/*
 	 * We map this as a VM_PFNMAP VMA.
 	 *


