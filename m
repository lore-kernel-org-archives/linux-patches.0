Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D62734AAE3;
	Tue, 26 Aug 2025 14:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217548; cv=none; b=oe+UB3boa/ckBA7HrjxMMCuZuDH/WbQbKISLkBVKztoqX9L2NC4gqiqKz3nnENsKt3lMfv7DNjLY6uYIE6MJeG2w2XSquXvNu57O0hfUEYYvt2vfEA2Raa5Hsd8TeyDCqYmScRnw2ACYdt2SqLfF/Op9YUi2g+LrXXAxDOsb5ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217548; c=relaxed/simple;
	bh=CwxPJd+DgroMQ+PKEDlTjbWUh0wg+zamjc8XZINDII8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axV93QU/q8Wl3Uwhjnes1gSMs86xmgJAWT+K61r0eN0LgF+hqiCeNJo5AJrGgA8a9nKvNlZQQEUQF/XSZBSseFqkQh8DblKaWR3kgakMEPHoTG/Zxal2MNM/nuiuQcQZfGOfNLxMlTF7/ANT9PLha0RKn0xzLZ0t6DLHvkBpBJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9auE1g7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9auE1g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7422C4CEF1;
	Tue, 26 Aug 2025 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217548;
	bh=CwxPJd+DgroMQ+PKEDlTjbWUh0wg+zamjc8XZINDII8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9auE1g7fWkoTDFNL/Gq/af9wGU3xavCQKsJSRdf/nmB3PER8bF2Bjzt4k6uLGdBL
	 upLaKO4h6Ps4mhTZA4Hsv1RrzfEkRN73tB9P8Hm/ZPKG0XUegKKqlxBQACyhURtV4Y
	 eiuNcB0sSydy8nG9mmLh1Ah93ebHMuTucoBFpgIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.10 185/523] perf/core: Prevent VMA split of buffer mappings
Date: Tue, 26 Aug 2025 13:06:35 +0200
Message-ID: <20250826110929.016964765@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit b024d7b56c77191cde544f838debb7f8451cd0d6 upstream.

The perf mmap code is careful about mmap()'ing the user page with the
ringbuffer and additionally the auxiliary buffer, when the event supports
it. Once the first mapping is established, subsequent mapping have to use
the same offset and the same size in both cases. The reference counting for
the ringbuffer and the auxiliary buffer depends on this being correct.

Though perf does not prevent that a related mapping is split via mmap(2),
munmap(2) or mremap(2). A split of a VMA results in perf_mmap_open() calls,
which take reference counts, but then the subsequent perf_mmap_close()
calls are not longer fulfilling the offset and size checks. This leads to
reference count leaks.

As perf already has the requirement for subsequent mappings to match the
initial mapping, the obvious consequence is that VMA splits, caused by
resizing of a mapping or partial unmapping, have to be prevented.

Implement the vm_operations_struct::may_split() callback and return
unconditionally -EINVAL.

That ensures that the mapping offsets and sizes cannot be changed after the
fact. Remapping to a different fixed address with the same size is still
possible as it takes the references for the new mapping and drops those of
the old mapping.

Fixes: 45bfb2e50471 ("perf/core: Add AUX area to ring buffer for raw data streams")
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-27504
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6194,11 +6194,21 @@ out_put:
 	ring_buffer_put(rb); /* could be last */
 }
 
+static int perf_mmap_may_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	/*
+	 * Forbid splitting perf mappings to prevent refcount leaks due to
+	 * the resulting non-matching offsets and sizes. See open()/close().
+	 */
+	return -EINVAL;
+}
+
 static const struct vm_operations_struct perf_mmap_vmops = {
 	.open		= perf_mmap_open,
 	.close		= perf_mmap_close, /* non mergeable */
 	.fault		= perf_mmap_fault,
 	.page_mkwrite	= perf_mmap_fault,
+	.split		= perf_mmap_may_split,
 };
 
 static int perf_mmap(struct file *file, struct vm_area_struct *vma)


