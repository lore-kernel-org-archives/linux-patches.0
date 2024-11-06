Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08B71E6DC1;
	Wed,  6 Nov 2024 12:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897010; cv=none; b=BDVdXWY6+ZhNJxQ6mec9TLL5wzvNjvvDfCDJ8AQ9hvnLP/lcB9qwi3zj8kn/9B7ZcKnW1V+rW5ugjCQnrp8rwfvU2sI3rbqabGi279YtiF51Rdy/RdnTnCWUk7Y/Mepp834tN7y6BzGuuwGPhebU9nDPWH1lF/ovTX08OAxgAow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897010; c=relaxed/simple;
	bh=zSYQNoqzLwxyjUE1DGxOubRCKyV4+IrIRcqfqUX/o4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcBQGOfIfx+yUG6s+Qj5ml1B1BskCe63AoHnXQeHIq0oee282ZVsHASTNS4397Vnh55dlOAeCZv10xtt1DIMbL2sNQE0UV3o3VBDqz3nKwbjC+rJnQz4ib8vGutDHo4gxp4KSRI7obNl4ndQUjyzVmBXN13b1KWx1S6h/fqVj8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCbiJ9zV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCbiJ9zV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ECFC4CECD;
	Wed,  6 Nov 2024 12:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897010;
	bh=zSYQNoqzLwxyjUE1DGxOubRCKyV4+IrIRcqfqUX/o4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCbiJ9zVUPiSh4gL1SoRw70kPNchZscdC9XltZ0VVzU9ntmowG5IuSYOiEm8B4DkD
	 WC3Ne75i/CirlZuaYAY/GArU8VtzsGCNmENdSt/PHmVbCnmrpyMcRnlaph8y8JN1mf
	 yqE3/61FGfXmL9U+Gr1uikkmuJPzeAoUBnd7CVUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Jiri Olsa <olsajiri@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ard Biesheuvel <ardb@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Matthew Wilcox <willy@infradead.org>,
	Mike Galbraith <efault@gmx.de>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/126] fs/proc/kcore: reinstate bounce buffer for KCORE_TEXT regions
Date: Wed,  6 Nov 2024 13:03:28 +0100
Message-ID: <20241106120306.265569468@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 17457784004c84178798432a029ab20e14f728b1 ]

Some architectures do not populate the entire range categorised by
KCORE_TEXT, so we must ensure that the kernel address we read from is
valid.

Unfortunately there is no solution currently available to do so with a
purely iterator solution so reinstate the bounce buffer in this instance
so we can use copy_from_kernel_nofault() in order to avoid page faults
when regions are unmapped.

This change partly reverts commit 2e1c0170771e ("fs/proc/kcore: avoid
bounce buffer for ktext data"), reinstating the bounce buffer, but adapts
the code to continue to use an iterator.

[lstoakes@gmail.com: correct comment to be strictly correct about reasoning]
  Link: https://lkml.kernel.org/r/525a3f14-74fa-4c22-9fca-9dab4de8a0c3@lucifer.local
Link: https://lkml.kernel.org/r/20230731215021.70911-1-lstoakes@gmail.com
Fixes: 2e1c0170771e ("fs/proc/kcore: avoid bounce buffer for ktext data")
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reported-by: Jiri Olsa <olsajiri@gmail.com>
Closes: https://lore.kernel.org/all/ZHc2fm+9daF6cgCE@krava
Tested-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Will Deacon <will@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3d5854d75e31 ("fs/proc/kcore.c: allow translation of physical memory addresses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/kcore.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 2aff567abe1e3..87a46f2d84195 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -543,10 +543,21 @@ read_kcore_iter(struct kiocb *iocb, struct iov_iter *iter)
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
 			/*
-			 * We use _copy_to_iter() to bypass usermode hardening
-			 * which would otherwise prevent this operation.
+			 * Sadly we must use a bounce buffer here to be able to
+			 * make use of copy_from_kernel_nofault(), as these
+			 * memory regions might not always be mapped on all
+			 * architectures.
 			 */
-			if (_copy_to_iter((char *)start, tsz, iter) != tsz) {
+			if (copy_from_kernel_nofault(buf, (void *)start, tsz)) {
+				if (iov_iter_zero(tsz, iter) != tsz) {
+					ret = -EFAULT;
+					goto out;
+				}
+			/*
+			 * We know the bounce buffer is safe to copy from, so
+			 * use _copy_to_iter() directly.
+			 */
+			} else if (_copy_to_iter(buf, tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
-- 
2.43.0



