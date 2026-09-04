Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2D03815E1;
	Fri,  4 Sep 2026 05:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500664; cv=none; b=lTjAEPZ2WZLM/svsOPsK9t2Ea8JtYkOAnnUijvbk1lnCV323S0/iZmsPjlLi9Da7CYXBTNejiavQo5KDnsU2cEhYWGsC3b5lWJWihwCUsClKnYY+ty+cGEu72spetTA/AxwDyb/arE+AnoklxlHbI6GiuQAmsYRWG8QNvn/9SDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500664; c=relaxed/simple;
	bh=Ay1jub2BD11RmLjHjZjFRoKhCt+lSzdRWskm2ysXWgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxV/CDxtvOfSJYpBjF8hSELXtjl4YaxQXJ2dqjBea+uRe6vHLAH8hpdUcLMzkEfB01ON0/qvYV9/I3pclNu2q3z/g25e1Qs+hH28Jsym88IFkkah8z8BsGMZLcvgNeb0Rk5njSYb+n1o5ERk4lL1LXCQeuNlAPsrrLgo1fklvSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqyZ3ift; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqyZ3ift"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E3D1F00A3E;
	Fri,  4 Sep 2026 05:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500662;
	bh=d7ix/ihT5lsRw+XeZ4hfBTOv3JD8rJgRnFZYmLYIMi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqyZ3ift7ffrxq5a94je5xokHZ8dCYlay/BpLVewbLOxIYGzEIilQMPp7s8i8ujc1
	 rxHUSpT6VjbC3zyY/Vk+1qBZ88KtY0S4vk212gCVLpm+8k6d9ES9smTJvWHAzzTQ+n
	 xfnwkrUPAovmvFllCqldFOP/5cRvkwFpJxML81hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 136/552] nfsd: fix reply size estimate for GET_DIR_DELEGATION
Date: Fri,  4 Sep 2026 06:54:53 +0200
Message-ID: <20260904045751.512593837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 46f929b907b3bc488593c006f0c97e35baba9ea4 upstream.

nfsd4_get_dir_delegation_rsize() returns its estimate in XDR words, but
the COMPOUND reply-size machinery works in bytes: every other op's
_rsize helper multiplies its word count by sizeof(__be32). Since
GET_DIR_DELEGATION is OP_MODIFIES_SOMETHING, this estimate is consulted
before the op executes to ensure the reply will fit. The ~4x too-small
estimate lets a compound near the session/reply limit pass the check,
grant a directory delegation, and then fail to encode the reply with
NFS4ERR_RESOURCE/REP_TOO_BIG, leaving the client without the returned
stateid.

Multiply the estimate by sizeof(__be32) like the other _rsize helpers.

Fixes: 33a1e6ea73e5 ("nfsd: trivial GET_DIR_DELEGATION support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260616-dir-deleg-v7-17-6cbc7eac0ade@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -3330,7 +3330,7 @@ static u32 nfsd4_get_dir_delegation_rsiz
 		op_encode_stateid_maxsz +
 		2 /* gddr_notification */ +
 		2 /* gddr_child_attributes */ +
-		2 /* gddr_dir_attributes */);
+		2 /* gddr_dir_attributes */) * sizeof(__be32);
 }
 
 #ifdef CONFIG_NFSD_PNFS


