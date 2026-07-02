Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04504318EC5;
	Thu,  2 Jul 2026 17:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011726; cv=none; b=qm1gedTh0GctuUD1gYLy1BfF2ZYN3i0bf5fZnIvDk3nMgO12hMtonqOmO+oJhnOhRqO8/vCqRO2Dqk0M23YBstr3nuUoN3UXvIqnWO7uNC6uM+jGwuG5Xv5cHBmNPt87aLhpNXMEhIjA6twuwF/Tvdx3KJiDxHkKb3jZIWszOL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011726; c=relaxed/simple;
	bh=nNPszoEWSkiAxgPP0S2kPEdvsx8GJHiv6lFOoKEOfK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kx8PshovXY7F5jGMukc7df+XSCvlwjr8W95oZAb5Egj9l19uqakVA8rPc2dGGrDJBI5hjOBDAOOMFvRy3t09thycihQBQTXjMh91OKLyY6SEknWEK1wjY9UYnTh3OUXO5zEQBApwJk3AeEubWOZN5ezR7e8dV+W6RwYmFDHPzfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLmXfJSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLmXfJSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9671F000E9;
	Thu,  2 Jul 2026 17:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011724;
	bh=/tZsUyQdBJoS23F4w+9Rh3CkLDOlvC84RJLzSGvqnbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLmXfJSjwLGbIyejUkRkTVCaecFiTCHgYuQ5UYWRVVBugrlaTHpaOu+JXtfKzO0v3
	 jVo7xU9qQoyWku+tVulKsRJVXL0Vxjpw29d+RGbQlQlGInU8QtsB3da5qEOuBNiC+n
	 j2TY9UgMkHCZY30VMNcRLmLBKDc8Z9fN2bx0B9iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dominik=20Wo=C5=BAniak?= <stalion@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.1 110/120] nfsd: check get_user() return when reading princhashlen
Date: Thu,  2 Jul 2026 18:21:46 +0200
Message-ID: <20260702155115.235981921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -718,7 +718,8 @@ __cld_pipe_inprogress_downcall(const str
 				return PTR_ERR(namecopy);
 			name.data = namecopy;
 			name.len = namelen;
-			get_user(princhashlen, &ci->cc_princhash.cp_len);
+			if (get_user(princhashlen, &ci->cc_princhash.cp_len))
+				return -EFAULT;
 			if (princhashlen > 0) {
 				princhashcopy = memdup_user(
 					&ci->cc_princhash.cp_data,


