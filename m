Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E7141D625;
	Thu, 30 Jul 2026 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422996; cv=none; b=WwQlGIZ0wnzeDvRYcvzqTAa1y9x9I6h276aXfb7XLH2Oz/KZYp//guQ9Z3PgD5WM0TJiORFFIyYBgF3DcvWNhllEr8wyKySX8jsD9SnTta0LGuih2gQo+UiyRDGOg/TnGx9bEM6PqzKGYta31LncZ0FXvmhOH8DLs/0udG+nAhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422996; c=relaxed/simple;
	bh=9KGP+uRuHXf0PoeF5nOu8GOuIt2SyzRE5GGtcFFfFCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5WFyhqLlqMtwIW3KkpRS6DkaUzE8AI6WRUamklxB8rX9hnSA+ueSpMS+hMkrz09pIO7auAVia6iQxDQaDwxFTfGcmZmaJHB3ozUnnBC9EuBn4X7t4fhvZet8hD5egJeJpyXEdNrrKUiCJ9mc46BLmXdG56ucorbRVug+uiUPDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaqKx5c0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaqKx5c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B0E1F000E9;
	Thu, 30 Jul 2026 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422994;
	bh=FHsvjG7TTb9Pwu5ct/ae4gcDBL7F0rjFL+xt/r2uIrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaqKx5c0BtykD4JI8Ct/JTP2Y11h+ZdHHk1QQtSlnhHBqy5SIbTOQOPa+bJjL9OMw
	 L9tSSPwyWfo7VeVsEXOXGEolsTFx72ApE2LkaVGwna26D05RNWxJuqbrnnXrXehjdX
	 d4ccwhe7nPbfMG3QApeZutbz1qkqvS/KaU9I5YmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 602/744] tracing/remotes: Fix page_va[] access before counter update in trace_remote_alloc_buffer()
Date: Thu, 30 Jul 2026 16:14:35 +0200
Message-ID: <20260730141457.073615175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

commit 94b83ff0c0a69e42f403b59918529fbca2a89daf upstream.

page_va[] is annotated __counted_by(nr_page_va), so nr_page_va must
cover an index before that element is accessed. The allocation loop
writes page_va[id] while nr_page_va is still id and increments it only
afterwards, so every write is one element past the declared count.

The store is out of bounds with respect to the annotation: a build with
CONFIG_UBSAN_BOUNDS on a toolchain that honours __counted_by
(clang >= 20.1, gcc >= 15.1) flags it as an array-index overflow.

Increment nr_page_va before writing the element it now covers. A failed
allocation then leaves the slot counted but NULL; the error path frees
it with free_page(0), which is a no-op.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260713072823.2668323-1-fuad.tabba@linux.dev
Fixes: 96e43537af546 ("tracing: Introduce trace remotes")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_remote.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -1004,11 +1004,10 @@ int trace_remote_alloc_buffer(struct tra
 		desc->nr_cpus++;
 
 		for (id = 0; id < nr_pages; id++) {
+			rb_desc->nr_page_va++;
 			rb_desc->page_va[id] = (unsigned long)__get_free_page(GFP_KERNEL);
 			if (!rb_desc->page_va[id])
 				goto err;
-
-			rb_desc->nr_page_va++;
 		}
 		rb_desc = __next_ring_buffer_desc(rb_desc);
 	}


