Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F662FFDD4;
	Tue, 12 Aug 2025 18:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023132; cv=none; b=UZb3MlJkxzG7HvIRNmTBx70vDr8/AaJW5T9f9IsK7N8d/XI5e4M32nVNqsmVAiyGMRbB6qR4LYvGiHhfo7mmSnK4I2qm0Hp7asSbnLsSOVK+CS/susckegbNbZ/LM19p6Zt0egMgtx0ykVSdjvtyRlyVv3b2yENJ4t5lcw4Zbq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023132; c=relaxed/simple;
	bh=pVbeLiwEFVt5F8bbXy6ZrN3Q9M2DjuRA2R5Nr56s4sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPUGW2uvF10cKAlZU2JjfomvJ4qNkD3WVZ1WgQnMAu81hHRDvqGN21qvNz4VmO4dovR93lfzAkMYaqLa2SXwFxmzr8q4fk4GaI6IM3MBEV5Bq9TD7QMs+30Diyv4wj+UJKN5JjI/6z9RWMA5FZPQ8pyphsfZPJB/okDXsZwO+WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1QGHwrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1QGHwrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DB7C4CEFC;
	Tue, 12 Aug 2025 18:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023130;
	bh=pVbeLiwEFVt5F8bbXy6ZrN3Q9M2DjuRA2R5Nr56s4sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1QGHwrLT9FavYbpznHiArFaIV3apz9yv/ysMeP8lkGwKFw5EJaVlQAvqBpfQcNxD
	 6Th9/wCFVH8G+kYyaAR4AT2O2/kuPBwOXdks1B71Jwp9bxbIXjm5MzVvQLP/PSr1CY
	 qy03pqzUPHHgOKLc/mVOdzi9Y7MWTQq2ySTaW30o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.12 325/369] perf/core: Exit early on perf_mmap() fail
Date: Tue, 12 Aug 2025 19:30:22 +0200
Message-ID: <20250812173028.942292084@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6836,6 +6836,9 @@ aux_unlock:
 		mutex_unlock(aux_mutex);
 	mutex_unlock(&event->mmap_mutex);
 
+	if (ret)
+		return ret;
+
 	/*
 	 * Since pinned accounting is per vm we cannot allow fork() to copy our
 	 * vma.


