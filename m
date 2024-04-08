Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B5C6EB72;
	Mon,  8 Apr 2024 13:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584542; cv=none; b=gmh5h4/GM3B3fbT6AhQ3Cvc3smE1oWeOz16kspBZ3d/5oPx+DfpgDmOhz9E1s0Q3uxQCJo7gjAq8SBgI17pMOo2YLhFvVC9YpOWbIehz9wjpqRKSi3tT+pDLRkx824VZqBg8l7JNrueWnF3c6dtYunA0Wtt+ut1n1YXoZgEFly0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584542; c=relaxed/simple;
	bh=LQ4sXvMpyILRMdXVrvljBdKHiF0jHsfzWUV90pUWfEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWayr74Rzl9uMX2UeHyZKuJnzFnkKBbb2+F/btU5sbnU9kZ4hSa8t9AYRb6zkMFRPwRq8jdeKMNlFRsW50NxLin0TrL6rtGNWNHvDxryE4MOM9IV0mHzogSpnjGITv8M4EvI71TZhRPK0ESQ4DSgnKOboTyvpQaKSS62ERC7TBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nfQiGGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nfQiGGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D2DC433F1;
	Mon,  8 Apr 2024 13:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584541;
	bh=LQ4sXvMpyILRMdXVrvljBdKHiF0jHsfzWUV90pUWfEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nfQiGGteCEz5OM8rCQCEuPzYwPJ2hXi4PRCGOm8YdBiM9v/ysO19QxhiXQFujC2g
	 agyWav+XeQ8pi9BfX9OvsIhFVXnNbqQTSUpJOFH7EzBKnqy7KOMqhKOGFeDKUZX/fw
	 JhF17erHey2AF0q3VKXqgXD8q6XDotIj/DuxzeUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 473/690] nfsd: ignore requests to disable unsupported versions
Date: Mon,  8 Apr 2024 14:55:39 +0200
Message-ID: <20240408125416.733711443@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



