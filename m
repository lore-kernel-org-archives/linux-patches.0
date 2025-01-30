Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D876C13D;
	Thu, 30 Jan 2025 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245662; cv=none; b=JfSYO7jH1oyAvUtInLtQrRhZq5BJPUcTF4zDZ6w5lnrDGaKt2d+zY8uahPysUrFCQMH7zJPjACCUiGovio+A+zHTEWJJxiyVI/1IACeCKtjlnPOuY0lUQakUO+3LPHuJyIMqYV+h3wHAcpRJLOKf+R1OQ40CqnfixOcwUMlevYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245662; c=relaxed/simple;
	bh=EIZqEJvoFsQfwDCXFB3Y0IsyT5M+KqI1YFO18rS7ERg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHDslFDVMZVb50HmNyS90j7KW5sVLQ0bpHyH0z3IRCJklWXzETJu/tITw3rdQgPhpbC3SKnqv4s00F5hx7O5AH74+PFhTrIl7bVEwWWl8Vi/Dfur7J+lYH2gtlLL/xGJLfbObw8V99QxJJSJTN5UsAt9wCpen1oJ6nmCqIqrjlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2l42Knz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2l42Knz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9C6C4CED2;
	Thu, 30 Jan 2025 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245662;
	bh=EIZqEJvoFsQfwDCXFB3Y0IsyT5M+KqI1YFO18rS7ERg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2l42KnzkJ4GvlSkE6WKYnOg7JqKXTNeLNdldqCRAH4tznThqrdD512wTeHaD0luZ
	 yk/nswtPYPsozVVimDirYKZjjY8DWS/M1ASLMg1W1I+jpgXbiyhbtfeyf9wHxl1DOx
	 n+UX6gzt9c78ULeCks+BG45WpD+y2Rk4/GUlyfAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Yang Erkun <yangerkun@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 18/40] libfs: Return ENOSPC when the directory offset range is exhausted
Date: Thu, 30 Jan 2025 14:59:18 +0100
Message-ID: <20250130133500.441969579@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit 903dc9c43a155e0893280c7472d4a9a3a83d75a6 upstream.

Testing shows that the EBUSY error return from mtree_alloc_cyclic()
leaks into user space. The ERRORS section of "man creat(2)" says:

>	EBUSY	O_EXCL was specified in flags and pathname refers
>		to a block device that is in use by the system
>		(e.g., it is mounted).

ENOSPC is closer to what applications expect in this situation.

Note that the normal range of simple directory offset values is
2..2^63, so hitting this error is going to be rare to impossible.

Fixes: 6faddda69f62 ("libfs: Add directory operations for stable offsets")
Cc: stable@vger.kernel.org # v6.9+
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20241228175522.1854234-2-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -288,8 +288,8 @@ int simple_offset_add(struct offset_ctx
 
 	ret = mtree_alloc_cyclic(&octx->mt, &offset, dentry, DIR_OFFSET_MIN,
 				 LONG_MAX, &octx->next_offset, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
+	if (unlikely(ret < 0))
+		return ret == -EBUSY ? -ENOSPC : ret;
 
 	offset_set(dentry, offset);
 	return 0;


