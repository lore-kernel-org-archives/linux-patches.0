Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD16D143C6B;
	Tue, 23 Apr 2024 21:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908651; cv=none; b=YCXFt1OATy7LYOjPsBPlC0lCOGw0HZtIKTA4kH4+nwSUs2t033Gl5wjknuLb+qjJCIffpx6anLtKe9FUaW7shuhIEkeX3Af+3MeSDbBS7R/7j3Ymo/gAhFuneLAvsUAHpTov3N4n+C/isuTZthToPpITvAzGHoPOz1s56CQRv44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908651; c=relaxed/simple;
	bh=it3ytTe7aRU1UvssAj7N70lvDZkOz3f/hCh75jThKWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGZ2PjARn09PUmLPsGWefMjV/Buymhuhey+bFK5cZkAKDN+u7nIuG4J9dzWKhpZodieTmZ/Z6SanCKpwgvHuHEnvYeDsGAoytffp7vdK71pyynvJQYCPqZoCvecGWPIFJG0yg+ZHaoZgotzAnEfitBA6luJTw9vnJ6SoKCVOos8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3ASc+zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3ASc+zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81226C116B1;
	Tue, 23 Apr 2024 21:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908651;
	bh=it3ytTe7aRU1UvssAj7N70lvDZkOz3f/hCh75jThKWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3ASc+zkpqXxjYq/6WbOqJim143bSAsJVF7CGKjO4QuKKUvmRP3ErIm6y/qPjCJV6
	 fkW6x8jw9GdqtkhicHf03xYrhs++OvcIqakOVpVPfOi8pY7LIVvcjmC/jM4M9KG4ov
	 8cEb/LLW9Ih+G66bTW9q45VcOP3ct2EQ1TVzFiNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Lin <danny@orbstack.dev>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 140/158] fuse: fix leaked ENOSYS error on first statx call
Date: Tue, 23 Apr 2024 14:39:37 -0700
Message-ID: <20240423213900.248253964@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Lin <danny@orbstack.dev>

commit eb4b691b9115fae4c844f5941418335575cf667f upstream.

FUSE attempts to detect server support for statx by trying it once and
setting no_statx=1 if it fails with ENOSYS, but consider the following
scenario:

- Userspace (e.g. sh) calls stat() on a file
  * succeeds
- Userspace (e.g. lsd) calls statx(BTIME) on the same file
  - request_mask = STATX_BASIC_STATS | STATX_BTIME
  - first pass: sync=true due to differing cache_mask
  - statx fails and returns ENOSYS
  - set no_statx and retry
  - retry sets mask = STATX_BASIC_STATS
  - now mask == cache_mask; sync=false (time_before: still valid)
  - so we take the "else if (stat)" path
  - "err" is still ENOSYS from the failed statx call

Fix this by zeroing "err" before retrying the failed call.

Fixes: d3045530bdd2 ("fuse: implement statx")
Cc: stable@vger.kernel.org # v6.6
Signed-off-by: Danny Lin <danny@orbstack.dev>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1317,6 +1317,7 @@ retry:
 			err = fuse_do_statx(inode, file, stat);
 			if (err == -ENOSYS) {
 				fc->no_statx = 1;
+				err = 0;
 				goto retry;
 			}
 		} else {


