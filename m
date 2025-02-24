Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B13024EF62;
	Mon, 24 Feb 2025 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407837; cv=none; b=a85ifs4eELWbvEGpqQUveLOvZnJsR7W3dCZlI2vAobSkGwtKol2z/vybQhVpOpmZ7JJCfOKXmqL/dpAV5dF4syMxMkIZcix5oqxBgCZ5j9zJ1p9J9mtfhEzYcpogFix3+5MLabIhziWqYySNwYYOiC849HjcBdk+Qut6Vc103Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407837; c=relaxed/simple;
	bh=YOsYKYfq7vvrxxmx2aZJAiuhkOD9UWrsYTxxrwJCFb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AySVIim3RZHwulXOB2yCUZsP5UE7blam4arYI1i3Q6bZ5bVSqRYONO2lTibwHNU1f8WsXzTTam/kFHOUDfrWWM3YmSOm/eIkyECICcwtjYHh0HFXpuHKNDIMS5xvCEfMq0W3g2nzx9fCWKE7ZEYN+kbIgDX/yHA37bXuCyDjpLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/stzz7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/stzz7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642CAC4CED6;
	Mon, 24 Feb 2025 14:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407837;
	bh=YOsYKYfq7vvrxxmx2aZJAiuhkOD9UWrsYTxxrwJCFb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/stzz7p6Rz7f/asSjdiWw2L3cdiGMU0oJgOCSxJ7mCbZvSRXWTFBqGgab+I1V6tY
	 YIjjcbOelbNxscr06LzCaznLLQU1UZ4RZROd0Dz5lrfRTrlow35OkuBsqXHs+u7QMn
	 VJzRKrPY8j0E3wYnwD95aS80uwPrvgoLM92aIcnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Dave Chinner <dchinner@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 6.6 023/140] xfs: Reduce unnecessary searches when searching for the best extents
Date: Mon, 24 Feb 2025 15:33:42 +0100
Message-ID: <20250224142603.915250638@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

commit 3ef22684038aa577c10972ee9c6a2455f5fac941 upstream.

Recently, we found that the CPU spent a lot of time in
xfs_alloc_ag_vextent_size when the filesystem has millions of fragmented
spaces.

The reason is that we conducted much extra searching for extents that
could not yield a better result, and these searches would cost a lot of
time when there were millions of extents to search through. Even if we
get the same result length, we don't switch our choice to the new one,
so we can definitely terminate the search early.

Since the result length cannot exceed the found length, when the found
length equals the best result length we already have, we can conclude
the search.

We did a test in that filesystem:
[root@localhost ~]# xfs_db -c freesp /dev/vdb
   from      to extents  blocks    pct
      1       1     215     215   0.01
      2       3  994476 1988952  99.99

Before this patch:
 0)               |  xfs_alloc_ag_vextent_size [xfs]() {
 0) * 15597.94 us |  }

After this patch:
 0)               |  xfs_alloc_ag_vextent_size [xfs]() {
 0)   19.176 us    |  }

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1783,7 +1783,7 @@ restart:
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
-			if (flen < bestrlen)
+			if (flen <= bestrlen)
 				break;
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
 					&rbno, &rlen, &busy_gen);


