Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33FF28033D;
	Tue, 27 May 2025 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368608; cv=none; b=QzSEescG1Z/MdBWslNdIEhH0gGu2OzuRCxvyVvIZ+pkAxcOjY7/NVGWlXjXLnXhQOPt9Wxe6VImklsSQ+hRxVPdZgwHv/bZ8nx9sHXPbLuLmkZG4GWxPxU0g1NEzMywzAY5MH0Pz/UPgIasTXsXOQACV0M+5QG8oW8PMSGphE5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368608; c=relaxed/simple;
	bh=WuasC5RPEZ2Ve4q8TtNXp/YeS9LcXS9gUh8b/VwAmm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV5CFLuSOYb4CMGmSYytbbeCIWL4J/AgCAfb9SIHAmdwbdncLX/K8QBX9eShlmQJcLHA1IV1EpNvWBLWHmNpJDLADtb+dYSb4ef43ay17LCh7Ryuh7AkcSBScCMcNthxuxdCVuY4h6avfYkiuAYzfmYlT0j/5bVeVV0Hh/DgpJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7z3S/XX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7z3S/XX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B96C4CEE9;
	Tue, 27 May 2025 17:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368607;
	bh=WuasC5RPEZ2Ve4q8TtNXp/YeS9LcXS9gUh8b/VwAmm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7z3S/XXCs7DIkqdMrg8F4sAnl3VidkESZ4iUNr3ScoeK6F82soWJpjAl+47VjRGj
	 3zHRQ9uFnXzQQYbY2GgbG43m9mFYWg/esTRTB1T6kHxz9bNZ312xUX6lik37obA9SH
	 v8p6dYbrJTbgIc7i73YpqsZW/jTYN7pbWm+m4gxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"Erhard F." <erhard_f@mailbox.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 761/783] mm: vmalloc: actually use the in-place vrealloc region
Date: Tue, 27 May 2025 18:29:18 +0200
Message-ID: <20250527162544.112266103@linuxfoundation.org>
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

commit f7a35a3c36d1e36059c5654737d9bee3454f01a3 upstream.

Patch series "mm: vmalloc: Actually use the in-place vrealloc region".

This fixes a performance regression[1] with vrealloc()[1].


The refactoring to not build a new vmalloc region only actually worked
when shrinking.  Actually return the resized area when it grows.  Ugh.

Link: https://lkml.kernel.org/r/20250515214217.619685-1-kees@kernel.org
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Kees Cook <kees@kernel.org>
Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Closes: https://lore.kernel.org/all/20250515-bpf-verifier-slowdown-vwo2meju4cgp2su5ckj@6gi6ssxbnfqg [1]
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Tested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Cc: "Erhard F." <erhard_f@mailbox.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4115,6 +4115,7 @@ void *vrealloc_noprof(const void *p, siz
 		if (want_init_on_alloc(flags))
 			memset((void *)p + old_size, 0, size - old_size);
 		vm->requested_size = size;
+		return (void *)p;
 	}
 
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */


