Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB264189B84;
	Wed, 17 Sep 2025 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112782; cv=none; b=NDgQ6FhB8mVsi7lZA2vkXEstzaOb79Us7UgyHFSgTe5gC6EFMc/wc8AOtNkfg1DgVSfq5eXsIWKth1I7fm20zMp41bRxi8p767g2FCzJuZTkZwwbjIiXO6pN59gaA4UGICRSYJo3kdSP3P34p2bRjS5gazwXpkWMnYMejDhAbkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112782; c=relaxed/simple;
	bh=ls2qqCKcD8OQuAK5mEUDWGksOtpYg5qsqn1A0WCl7Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4zVk0uvArK2j2+sUlOoeMtwmPbuO1EoxkqaniwmZWYD/37Q9pkq+kxkm7n5X+n2JZiLV0NwRlt5gjjKAuYwx5jl98WJ/fhhMYXZLmEOUSw7wsqlj/FlU46YwI+uPQ0ghsIzL8lY13DGv30wTSGrLES0mq14oav0EObHQJksJeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUNFAAI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUNFAAI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6D6C4CEF0;
	Wed, 17 Sep 2025 12:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112782;
	bh=ls2qqCKcD8OQuAK5mEUDWGksOtpYg5qsqn1A0WCl7Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUNFAAI9OXxpDjApnZu/E0proxFT7o+jCQ8P/0DLJERuo3fIyVugIM+qv3EYWMc8T
	 AfiX1aXgZkSrGSJBnVuLtStBxhNY/2RhdfM1EZPAKO30I0RxqbDdk3c/abfv7WQ8GF
	 cDF9K1inISxEeG6DxaQqjHRuQ/VbpSjjEPXCCkaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Weimer <fweimer@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.16 075/189] fuse: prevent overflow in copy_file_range return value
Date: Wed, 17 Sep 2025 14:33:05 +0200
Message-ID: <20250917123353.700372460@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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
@@ -3013,7 +3013,7 @@ static ssize_t __fuse_copy_file_range(st
 		.nodeid_out = ff_out->nodeid,
 		.fh_out = ff_out->fh,
 		.off_out = pos_out,
-		.len = len,
+		.len = min_t(size_t, len, UINT_MAX & PAGE_MASK),
 		.flags = flags
 	};
 	struct fuse_write_out outarg;


