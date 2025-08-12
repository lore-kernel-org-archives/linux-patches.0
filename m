Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2B51E47AD;
	Tue, 12 Aug 2025 19:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026899; cv=none; b=ZLUl+XqfAYTtsEXDrt6gX7oJtTxN1XTOwhmrK1mVoFIp91LVVzpFVXehySTGYIYLL3HgpxGG2B8BnARfK7tbAaWxkcIA4n5eIw1+DsfIbWlSlA+uQ76faj+/k8bSVtiFHQwXyfm+1+fmlwBiCkBI/2aq9WclFF9OCzgptBzfmGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026899; c=relaxed/simple;
	bh=mpP7QSOLpvIjsPJjM0XYkH8FrikNGFYYHrseO8CEPy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noxsli4NSLa4bM3E0ZXZ3z4oyGQDNRoZyKyAybgn1nZYVpK/wW7Y6zUoJHVc/u520sssv4yVCt/kBzgeAN35ZoJYsoXZ6UjWU6ICMx6muVrWUQZ/Yx//4qPbYvMtSoz6oStcGP1PHOgdDibj2kSltaL+Hz8/t88u/CmJ8I6rLrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcmg+0JG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcmg+0JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AE8C4CEF0;
	Tue, 12 Aug 2025 19:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026899;
	bh=mpP7QSOLpvIjsPJjM0XYkH8FrikNGFYYHrseO8CEPy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcmg+0JGdb66FK5+S3LB/9ZX/ODrPLG+V/q5/CnK5RBB1OnyeqjLby/pTFHZD30S4
	 QYjCjiOnIVQbaW/j0oiwg2cMViP8ETd4nsskG4uSXG+4X6vjmVYUhL/Ca2SNd1koZe
	 l3nacMN0sFxw865qElxYJi4/0OwUdvE6aBsVXSeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.15 439/480] perf/core: Handle buffer mapping fail correctly in perf_mmap()
Date: Tue, 12 Aug 2025 19:50:47 +0200
Message-ID: <20250812174415.505289531@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit f74b9f4ba63ffdf597aaaa6cad7e284cb8e04820 upstream.

After successful allocation of a buffer or a successful attachment to an
existing buffer perf_mmap() tries to map the buffer read only into the page
table. If that fails, the already set up page table entries are zapped, but
the other perf specific side effects of that failure are not handled.  The
calling code just cleans up the VMA and does not invoke perf_mmap_close().

This leaks reference counts, corrupts user->vm accounting and also results
in an unbalanced invocation of event::event_mapped().

Cure this by moving the event::event_mapped() invocation before the
map_range() call so that on map_range() failure perf_mmap_close() can be
invoked without causing an unbalanced event::event_unmapped() call.

perf_mmap_close() undoes the reference counts and eventually frees buffers.

Fixes: b709eb872e19 ("perf/core: map pages in advance")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7085,11 +7085,19 @@ aux_unlock:
 	vm_flags_set(vma, VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &perf_mmap_vmops;
 
-	ret = map_range(rb, vma);
-
-	if (!ret && event->pmu->event_mapped)
+	if (event->pmu->event_mapped)
 		event->pmu->event_mapped(event, vma->vm_mm);
 
+	/*
+	 * Try to map it into the page table. On fail, invoke
+	 * perf_mmap_close() to undo the above, as the callsite expects
+	 * full cleanup in this case and therefore does not invoke
+	 * vmops::close().
+	 */
+	ret = map_range(rb, vma);
+	if (ret)
+		perf_mmap_close(vma);
+
 	return ret;
 }
 


