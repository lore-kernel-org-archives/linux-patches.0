Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBC128033D;
	Tue, 27 May 2025 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368610; cv=none; b=fhlD3rglR7qeEtMUZrYk3Fu97cr5ir+cGVVN/ldOjSsjBwe7ZWyD2EKKv4tzl/q/CBhe6Jb6e5p6Ekqq1tO1wMrexy6AV/inW3oCcBEiIY9NlqPruoUh9ptWKb5aPF8gUSp7x6+lgG7onsjPt3TcVou0EK2jIeRN/F3nGpj5l4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368610; c=relaxed/simple;
	bh=rO2Dn1eR8SVsU4ZHoXlQ8bMfrbL7JguQgc+iU+x+eJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZI7EzZ8tVybRzFhTXv8ayy9G40YIdGtQAtZcm+LkRzj6zZCD/eSvBa+tW5yt5rsl136Vxw7BJ39rviZyyvRTS2KVM1LVwSdQKgzqFVYiXFUZQZi2t7vpTeDtDGPwwPHkRYYHTXwaOgXbhzIGw5vnd8sZP1gQ+pQXknBQcwFu0f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZHZgZIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZHZgZIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC74C4CEE9;
	Tue, 27 May 2025 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368610;
	bh=rO2Dn1eR8SVsU4ZHoXlQ8bMfrbL7JguQgc+iU+x+eJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZHZgZIKf6KVF2J/x8O2Zjce+AS1bGISI9qu08gddv9mhaLS7VQ7wx0RaaHxcjBnA
	 EIWMbnZS2gBYi/SwQrR7prp8KJ7mr9xsykll5vMDJHN8oxZbKYUmRKs2DVJQy6jNeC
	 HK8s8XyKy1bizeWF02xmgVbwZhM+eh2uTYm9KZFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	"Erhard F." <erhard_f@mailbox.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 762/783] mm: vmalloc: only zero-init on vrealloc shrink
Date: Tue, 27 May 2025 18:29:19 +0200
Message-ID: <20250527162544.154284633@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit 70d1eb031a68cbde4eed8099674be21778441c94 upstream.

The common case is to grow reallocations, and since init_on_alloc will
have already zeroed the whole allocation, we only need to zero when
shrinking the allocation.

Link: https://lkml.kernel.org/r/20250515214217.619685-2-kees@kernel.org
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Kees Cook <kees@kernel.org>
Tested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: "Erhard F." <erhard_f@mailbox.org>
Cc: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4097,8 +4097,8 @@ void *vrealloc_noprof(const void *p, siz
 	 * would be a good heuristic for when to shrink the vm_area?
 	 */
 	if (size <= old_size) {
-		/* Zero out "freed" memory. */
-		if (want_init_on_free())
+		/* Zero out "freed" memory, potentially for future realloc. */
+		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
 		vm->requested_size = size;
 		kasan_poison_vmalloc(p + size, old_size - size);
@@ -4111,9 +4111,11 @@ void *vrealloc_noprof(const void *p, siz
 	if (size <= alloced_size) {
 		kasan_unpoison_vmalloc(p + old_size, size - old_size,
 				       KASAN_VMALLOC_PROT_NORMAL);
-		/* Zero out "alloced" memory. */
-		if (want_init_on_alloc(flags))
-			memset((void *)p + old_size, 0, size - old_size);
+		/*
+		 * No need to zero memory here, as unused memory will have
+		 * already been zeroed at initial allocation time or during
+		 * realloc shrink time.
+		 */
 		vm->requested_size = size;
 		return (void *)p;
 	}


