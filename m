Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCB83D953E;
	Thu, 16 Jul 2026 13:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210021; cv=none; b=ZvCP+BDVx/4dUxwn9p0ERt9L7bFjnVHx4UUBL5KPOneqmj8nTaRTx/cNH13zJjWwfJ5lcOZPc2xUDUCuZlW78v15D7w8XijycQvdeNlf2ff5pIShF/SXjMK1sae2EBGmmR2ZjYQlNtwZP1Cvr5sfD7y0grtHIgD4GL1tjUBQnOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210021; c=relaxed/simple;
	bh=pMrNaJqsgfgQie9a9xRsgnbWHQ/tHfGWybdB0uNssGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2RYq3uFuE5QRCAmjc00RGg6v1rMPoU4b5qrWhOB9FWz/Kr60YRDmo9EHOWDttq439o/+OKx9CtZJLacJvpo0k0vouev+WvP1bz2uQ5Rz3WrrNhBlWje+zGRunPcsEQRMOebN8weufCA+icd1g4+BfpPar09JqbMQXniy2SfsRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFcSgaIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFcSgaIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7271B1F000E9;
	Thu, 16 Jul 2026 13:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210019;
	bh=U+WRszF+BYH+tPCtxojp/tJs3LhPPFYn+/rWbaJcsFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFcSgaIz8yQSihTpvqW0IqvznvgUWbePLpKUUMZHZJuCLvA6LK4V1fMDpD9HMwWtG
	 pIeDX1jA7iNrV3jLZwil2FnkzkixN2os9+4Qw0kYl61FqMGwmBWwlivrVoaVX5Cyvu
	 E3qykkKaaOeTfEFKfFTJQdYWt1Cr2HuyxYzd/wyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jia Jie <jiajie.lee@starlabs.sg>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 7.1 408/518] perf/aux: Fix page UAF in map_range()
Date: Thu, 16 Jul 2026 15:31:16 +0200
Message-ID: <20260716133056.761777785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7150,6 +7150,8 @@ static int map_range(struct perf_buffer
 	int err = 0;
 	unsigned long pagenum;
 
+	guard(mutex)(&rb->aux_mutex);
+
 	/*
 	 * We map this as a VM_PFNMAP VMA.
 	 *


