Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DD93C465;
	Tue, 30 Sep 2025 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243837; cv=none; b=CA0O3LeeHx4mbrmk5NZ50LacAEdMkVnn7S+7zX/N9Kkpl2vQFxSD0N9nc9ED/f4DZElB8CD3rG/MS/qKEnAgzTnVjPSx3KTuLOo0rXZpPwOIlz4QDIdT8kQa7CwbBXxXQ9LyCg7ErjCFOYxnLMrVLocWWF/wtEojuPP/V4PuUfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243837; c=relaxed/simple;
	bh=0ZYbf/fvePnYKGKewrruYxvbQk+LtybnH6DssbYoPQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCOA9Ob5/YJGEAJveDGSFyOFpxbWGypoJEWzgtFBK3vqhjy7i0GBkov4fAiFlszoJ6zffRUzk6m6nFIZQ3GTRiYwapGb34+floyeugz8LPsRNGYIksY4JrvNyru/a2B0N+O8nY/vetdtoemmI6dwzjjnZxYoLqFFw38QT9OMmAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHFDy6tQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHFDy6tQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159A6C4CEF0;
	Tue, 30 Sep 2025 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243836;
	bh=0ZYbf/fvePnYKGKewrruYxvbQk+LtybnH6DssbYoPQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHFDy6tQjp9Cne6mhVqYBC9M6HCRszyG8+25o0xgCENhpRv7MqxcCYO7HgKYniyXW
	 WEXsvcV0hHgw5Q6/8aAJXwbp9q5N1AjHfBAOZJIyMqGc2TDcmLKo9+OC7a3GvpEw5m
	 18sYONWmrjMzCgQ+lPMavg2d84x+JdQZYh5NejIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Weimer <fweimer@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 09/81] fuse: prevent overflow in copy_file_range return value
Date: Tue, 30 Sep 2025 16:46:11 +0200
Message-ID: <20250930143820.056086307@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3299,7 +3299,7 @@ static ssize_t __fuse_copy_file_range(st
 		.nodeid_out = ff_out->nodeid,
 		.fh_out = ff_out->fh,
 		.off_out = pos_out,
-		.len = len,
+		.len = min_t(size_t, len, UINT_MAX & PAGE_MASK),
 		.flags = flags
 	};
 	struct fuse_write_out outarg;


