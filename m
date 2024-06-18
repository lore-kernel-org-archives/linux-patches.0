Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBC21ABCB9;
	Tue, 18 Jun 2024 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716640; cv=none; b=n6klhJL4ZDEUM8s3vCx1Q/9UgEvbgH1AF0HDTuKWNOX9S3PoHggi0s4dEIS4k3QJE7zZ5oYwPMKKh5Xj3QalEXT9gqs9/G63x9tQzb/3qv7INWWOzdj3VrhbjRE3K14Z9uR3Y020MzWhLeeyMaJXh5bXxtSoooyvjuvovwZJvFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716640; c=relaxed/simple;
	bh=HkogThUcW6QCXjjrypmN5jH+QjucuIwnZH5/XATwbSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4m+oaw9Lx15NNSe+yvgrNWuFblgTzYphu8bqSk4jCjyC3wP4R7wNn/1PMkBbI7NGXOKl7CqgKCgDbtV0nKay391MINivUzV8UrKqR9rzlWH5DE5Qk0OBxXhSvM1OkS8sc0gN9ctGMMPSY5dgrrQQv28bnNWSGA/MmaEtPqzDyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYz7Km3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYz7Km3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105BCC3277B;
	Tue, 18 Jun 2024 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716640;
	bh=HkogThUcW6QCXjjrypmN5jH+QjucuIwnZH5/XATwbSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYz7Km3uR6mUJh/gqJfQMVe2sSqJDG5taWzFLf0zTVWNvBiLqu6z8fcUI+cyPRJib
	 6pFpPqzEQvKbOUJSGjq4DkF6ZdDcvTOid0S3ji6BoiUo0/oM8Mm1jag7x2xh4MNSh+
	 eELpxFLO42V4fcKJaKsgCOPx31yyzlUsGo/czju8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 686/770] nfsd: ignore requests to disable unsupported versions
Date: Tue, 18 Jun 2024 14:38:59 +0200
Message-ID: <20240618123433.758402123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8e823bafff2308753d430566256c83d8085952da ]

The kernel currently errors out if you attempt to enable or disable a
version that it doesn't recognize. Change it to ignore attempts to
disable an unrecognized version. If we don't support it, then there is
no harm in doing so.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index dc74a947a440c..68ed42fd29fc8 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -601,7 +601,9 @@ static ssize_t __write_versions(struct file *file, char *buf, size_t size)
 				}
 				break;
 			default:
-				return -EINVAL;
+				/* Ignore requests to disable non-existent versions */
+				if (cmd == NFSD_SET)
+					return -EINVAL;
 			}
 			vers += len + 1;
 		} while ((len = qword_get(&mesg, vers, size)) > 0);
-- 
2.43.0



