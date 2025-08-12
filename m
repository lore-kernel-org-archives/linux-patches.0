Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5508A2DE1E2;
	Tue, 12 Aug 2025 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021244; cv=none; b=p+IV8SD4ypW8SV5tKYXFDIZQXbw2F7CvoYiUBFMctsoHGQMQgjmGL6DrQ8NeYUGHMuJqjjpI/+t3AZg90n5g3yXIe+Dlxljrg6s86bM+8jEGnSz7pYOpYoHzLUXf1pyGm1T52fvfRifkXPpaSphKuZ8jrx2gSsgIQFCJClS8mAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021244; c=relaxed/simple;
	bh=Q4iNIx5fO3wqdTP/N7ky7yQ7fgqefLAb/iFipwSUUx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4x08EsTNdZ8wIcsRODZQs/6uGX4V9si4cPLIWBoly0uJHh4zGkyPQP/7Ak5VZNNfQPDtyvi82BuaQhqpbmx8oODeiW/7LRzHwzmWha4I01WS8P9fUrbyMWDTFGDgu3/nQxeeT/5ONFaz1S/oDgTGgBuGU78bUlfzvWDH6/Spwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2LVkEj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2LVkEj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A7AC4CEF0;
	Tue, 12 Aug 2025 17:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021244;
	bh=Q4iNIx5fO3wqdTP/N7ky7yQ7fgqefLAb/iFipwSUUx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2LVkEj7iQ5Mo0LlVnt8fwDiv7fRIRep3VSfMDOEByudRoHs9c0PLzlrX4FejQhlZ
	 JOYz6OgQMzvgPBkWN8M8AOwoSxOLx5hSoKcgRRVAqP79L4Qio/eJq5SeHRs/Iz1UVY
	 NLsx7HlxWJdvw1gVI4NGfLdhsYQBLQteM23P1dMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.1 234/253] perf/core: Exit early on perf_mmap() fail
Date: Tue, 12 Aug 2025 19:30:22 +0200
Message-ID: <20250812172958.786080936@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/events/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6504,6 +6504,9 @@ aux_unlock:
 		mutex_unlock(aux_mutex);
 	mutex_unlock(&event->mmap_mutex);
 
+	if (ret)
+		return ret;
+
 	/*
 	 * Since pinned accounting is per vm we cannot allow fork() to copy our
 	 * vma.


