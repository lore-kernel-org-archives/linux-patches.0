Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC3133C75C;
	Wed, 17 Sep 2025 13:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114204; cv=none; b=tTFaQTRy/lxcvdt8OEf6IGJc6gC35g60+lxmAU5xgX1lbyQQqOC6TsuKIidg48FqpXR2fjLN6DDYGp59ckWlA9c4GKDJRVPkJxzOHDX0ZIShyXJv/C9liEI/mD5CAmi3ZtjeZCXTLTVffsOhFkkCwKmfYHgCKe8B0E5mCI2ptoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114204; c=relaxed/simple;
	bh=X3f9ruGyPDpU55htK2x8aLLhyfjh4wCDthEB1bHOzA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igm2KdKWLXg9idYsIMGWsWXJpsbbbEDfLlFZl/SY8CzrfMLF6j5Cg2O3WQk3+SZuxmVnDMij0BlnL7P0O5psaY85DbBqXzEMaCBc/Ht7GQiQojZkin8WQe6DTD9PaoPug6lG2tDn3ZwJBuwNiiy4vAX/5TGl6pRCOLVqrJhDOUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATMFdKRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATMFdKRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B57BC4CEF5;
	Wed, 17 Sep 2025 13:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114202;
	bh=X3f9ruGyPDpU55htK2x8aLLhyfjh4wCDthEB1bHOzA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATMFdKRUPX48B+6pYnMpfrwh2ztXXZ/qzhhiZDOr1zHIig97mBQzi84+GQLhslEjt
	 WGcXuJ13yJ0xumVMa6x+qquzIrocouMXAa2990JpMhZpGD/i7vJjzRhyxNSWUAvCEv
	 C8ZaSUH4NAo60KuY04py8B+ia3Xv48k/xHj+2NY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Weimer <fweimer@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 32/78] fuse: prevent overflow in copy_file_range return value
Date: Wed, 17 Sep 2025 14:34:53 +0200
Message-ID: <20250917123330.347159821@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit 1e08938c3694f707bb165535df352ac97a8c75c9 upstream.

The FUSE protocol uses struct fuse_write_out to convey the return value of
copy_file_range, which is restricted to uint32_t.  But the COPY_FILE_RANGE
interface supports a 64-bit size copies.

Currently the number of bytes copied is silently truncated to 32-bit, which
may result in poor performance or even failure to copy in case of
truncation to zero.

Reported-by: Florian Weimer <fweimer@redhat.com>
Closes: https://lore.kernel.org/all/lhuh5ynl8z5.fsf@oldenburg.str.redhat.com/
Fixes: 88bc7d5097a1 ("fuse: add support for copy_file_range()")
Cc: <stable@vger.kernel.org> # v4.20
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3103,7 +3103,7 @@ static ssize_t __fuse_copy_file_range(st
 		.nodeid_out = ff_out->nodeid,
 		.fh_out = ff_out->fh,
 		.off_out = pos_out,
-		.len = len,
+		.len = min_t(size_t, len, UINT_MAX & PAGE_MASK),
 		.flags = flags
 	};
 	struct fuse_write_out outarg;


