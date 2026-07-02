Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78862348C46;
	Thu,  2 Jul 2026 16:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010646; cv=none; b=AG7XrFdqgaEXS1I0hWDpN0d9iZo6IbrMkIZ/1hHV76PUtddoF5Yb3+lLLfquGT0oiKsMxbBejgaKcoinE3F5qRQzWbXt8Bqase2DScn3sE+5TJVd6kr/YMvbsB05eB8EGpxVBe0iRH/PJKq2YLf3VgmfmrA929Fr3DLffB1aixc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010646; c=relaxed/simple;
	bh=vX8IpTAUjdE6XsqOa4YKyh48xoFq5GSPCGIYQOLsRlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWa+3qtugDZBWwcXHnHiQf2ldagj3f4hmr0WonIbhj1AsjzCJ19rNgx9qyloI2u4Vf0sVlbut/PLAThwnDCVjxOzjIUtPlsmX8jwJMNSy83dNF8oYsS7mF9I1ckinRHU7fH3v32yET2Ij5Lgdgw3FaYpeIc78VjbVyS8GxC6tYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IX2rV4mr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IX2rV4mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF02D1F000E9;
	Thu,  2 Jul 2026 16:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010645;
	bh=pkisK//LZeQzeXLmPKyOIW2MLxaGViwEaYzEloEgm7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IX2rV4mriFucL1W3c6Mbcuv+cfQbNLB4djt93yCL/wP+QaA24mB66vgzGJZjkUhna
	 SUNBVoY4QvC1sy8eI7SYihABedJ646t7m5RuxwjT0PpCfa4EtQ5VKVzRBjxXa5uPr1
	 6I2Xh4279YYd3lr1lzrUzXmn5b26yL7+cWbh19RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dominik=20Wo=C5=BAniak?= <stalion@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 187/204] nfsd: check get_user() return when reading princhashlen
Date: Thu,  2 Jul 2026 18:20:44 +0200
Message-ID: <20260702155122.580017616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Woźniak <stalion@gmail.com>

commit e186fa1c057f5eccb22afb1e83e34c0627085868 upstream.

In __cld_pipe_inprogress_downcall(), the get_user() that reads
princhashlen from the userspace cld_msg_v2 buffer does not check its
return value. A failing copy leaves princhashlen with uninitialised
stack contents, which are then used to drive memdup_user() and stored
as princhash.len on the resulting reclaim record. The other get_user()
calls in this function all check the return; only this one is missed,
which is most likely a copy-paste oversight from when v2 upcalls were
introduced.

Mirror the existing pattern used a few lines above for namelen.
namecopy is declared with __free(kfree) so the early return cleans up
the already-allocated buffer automatically.

Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
Cc: stable@vger.kernel.org
Signed-off-by: Dominik Woźniak <stalion@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -818,7 +818,8 @@ __cld_pipe_inprogress_downcall(const str
 			if (IS_ERR(name.data))
 				return PTR_ERR(name.data);
 			name.len = namelen;
-			get_user(princhashlen, &ci->cc_princhash.cp_len);
+			if (get_user(princhashlen, &ci->cc_princhash.cp_len))
+				return -EFAULT;
 			if (princhashlen > 0) {
 				princhash.data = memdup_user(
 						&ci->cc_princhash.cp_data,


