Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950171E47AD;
	Tue, 12 Aug 2025 19:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026871; cv=none; b=JJfzCD2T7hIs9lE2UHhBRGddsiNkdiLHq06mLQ5fLcUkgDbO1YfH/MySplyoXNniJCYWpXHmmiMEu0Al7I9WikfiImcfpsexSGjE8AZKgG+3YGarq94lfPxIfVP828jCfXIACrKEEdu6F52CM44NkMXWXur4KPPfFTJVYyzh+G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026871; c=relaxed/simple;
	bh=PdwI4e6wfnxq+AVIEZ/GeBo1lLdYrW0d0uwoUANNnSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muLbaohaj8RR/Fc0mr0p5kQObF+6m3dmTrennP4bjRzyK1ar4GQcSsZH6mQK2dFNjbDQvfbIZyXBMXccKItzbqWYCTUtcr8kukB5mJ+R9o4jWJL8kZNRxqNYh+GVi+M/ZXxdAyIjKppJJw3q+AXQEZ5p326AytdHQZdjD+d6zzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCc7rhgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCc7rhgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F48C4CEF0;
	Tue, 12 Aug 2025 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026871;
	bh=PdwI4e6wfnxq+AVIEZ/GeBo1lLdYrW0d0uwoUANNnSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCc7rhgr6fihKCDygOANCCYb86QLBmWLk0Df5YQcOgJSpeUr8GnAcKXzV0Djj1WQJ
	 KBDwdz992cKglfftG6DnEgb6qX6ueQ2Pwqu1cj5qHc1OMNaLPZffE4ajiWHVvWK/R3
	 UA6AUsmBqUf67/mtG/Php1jYXxMsHnXWKSkBoWPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.15 438/480] perf/core: Exit early on perf_mmap() fail
Date: Tue, 12 Aug 2025 19:50:46 +0200
Message-ID: <20250812174415.463811203@linuxfoundation.org>
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

commit 07091aade394f690e7b655578140ef84d0e8d7b0 upstream.

When perf_mmap() fails to allocate a buffer, it still invokes the
event_mapped() callback of the related event. On X86 this might increase
the perf_rdpmc_allowed reference counter. But nothing undoes this as
perf_mmap_close() is never called in this case, which causes another
reference count leak.

Return early on failure to prevent that.

Fixes: 1e0fb9ec679c ("perf/core: Add pmu callbacks to track event mapping and unmapping")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7075,6 +7075,9 @@ aux_unlock:
 		mutex_unlock(aux_mutex);
 	mutex_unlock(&event->mmap_mutex);
 
+	if (ret)
+		return ret;
+
 	/*
 	 * Since pinned accounting is per vm we cannot allow fork() to copy our
 	 * vma.
@@ -7082,8 +7085,7 @@ aux_unlock:
 	vm_flags_set(vma, VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &perf_mmap_vmops;
 
-	if (!ret)
-		ret = map_range(rb, vma);
+	ret = map_range(rb, vma);
 
 	if (!ret && event->pmu->event_mapped)
 		event->pmu->event_mapped(event, vma->vm_mm);


