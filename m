Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9712FE598;
	Tue, 12 Aug 2025 18:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025128; cv=none; b=WPjAOvuV88WFJIJzj/nkO06PVeT56OP8k7qzwGvdrmkYGBupCCYjSJrgneOvazIgj2d/Uid/c+BhlA8aFf3XAQnrQXyjqZrSVAWhQtzEajSAcoWghlTeRBb6SDs1YkgoLiC1oHmboOiyeWVwtuHaZjxxgluKj5FYbZQyDiG99OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025128; c=relaxed/simple;
	bh=zZs6KSygbrSLJOCjpWTWVfKDqI1Be/5V8hh4yy/XwnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8IVdqa4bZ/8veBztO0LWKX7tzVWcj6hC+n2eKfrAXJOR+jIfZnCyyKMlnkOf6ZjjLyTPhlde5KbFxxfJ6fsH4L/7UAXtTazckNnekn6Ms3SNyvfJPURiBnQHuET4EuC1vhfCErW387Mq11APXPQ1tca1txZ+anVaN4E+zpxi7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KihPzZ3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KihPzZ3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACEEC4CEF0;
	Tue, 12 Aug 2025 18:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025128;
	bh=zZs6KSygbrSLJOCjpWTWVfKDqI1Be/5V8hh4yy/XwnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KihPzZ3QpclcjALx6+vkphLhmkqETWul5KPnKJIlLkQBLTmmy335c1cxzqNqv4sS9
	 uT0Mk8IHDnzP0W3llQgSPyQVYA8ZoL2PYl9Lb3zxjH82xla1DQjrjvy5MHkQbmqoMn
	 OT/iojrMSOqsdhY92mJC6osV9j3shMeJ69Mngx/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.16 578/627] perf/core: Exit early on perf_mmap() fail
Date: Tue, 12 Aug 2025 19:34:33 +0200
Message-ID: <20250812173453.859645553@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7138,6 +7138,9 @@ aux_unlock:
 		mutex_unlock(aux_mutex);
 	mutex_unlock(&event->mmap_mutex);
 
+	if (ret)
+		return ret;
+
 	/*
 	 * Since pinned accounting is per vm we cannot allow fork() to copy our
 	 * vma.
@@ -7145,8 +7148,7 @@ aux_unlock:
 	vm_flags_set(vma, VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &perf_mmap_vmops;
 
-	if (!ret)
-		ret = map_range(rb, vma);
+	ret = map_range(rb, vma);
 
 	mapped = get_mapped(event, event_mapped);
 	if (mapped)


