Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E0B149DFA;
	Tue, 17 Dec 2024 17:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455513; cv=none; b=FqLONh5PSL+q2ZLGAo4lNg/Pn7O1TVgYcsC93QXXqK4LOX0SxFBBCFwS5Fm5Jd3CnJ7QjqTp4okN+ZWR4M0vW6ZojUdZ9gU6LZtWc2H2iilmBIx7AbwC17rzIde3T0yVKLMyBwPivHgFUUYo44RHsu8oYEI5qLUpltNJWEH6Pf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455513; c=relaxed/simple;
	bh=6tPE9WjwPKot8zTtAVed5a8br6mdcpSCL6EE9Qo11sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsnIHpUT7W1trM3adyTy8hvnXbkckbpTzXmRA6sQfzkX7ux9+/2wdduOGCSWZZCwTlBJwlNJaZsHVBZeEi6XZ+1fZ4yktdeH3dhtJv7picEHiRzGiU3/+BlOu2usoPv/J4zDYajVRSKRiWgvzp9LEyJi3B18Klh1LGlTxRfK2fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmsY1xXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmsY1xXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16730C4CED3;
	Tue, 17 Dec 2024 17:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455513;
	bh=6tPE9WjwPKot8zTtAVed5a8br6mdcpSCL6EE9Qo11sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmsY1xXFIqeF7u1Un6U/fkBPbi7zPHelp+RHJu2cjgd5Dih+nnZ9SQIbqVo4qKdDN
	 YRmCSe0ynT22HIG9MIgXJM27eNHlk7s2CQawEdvFrND7nDWb1aL6+JRmhhMLc09f+1
	 f/oAt1cpXQDJtStTpwW+usrjyFtneS3YC1UVUKD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 08/43] xfs: fix scrub tracepoints when inode-rooted btrees are involved
Date: Tue, 17 Dec 2024 18:06:59 +0100
Message-ID: <20241217170520.796148961@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit ffc3ea4f3c1cc83a86b7497b0c4b0aee7de5480d upstream.

Fix a minor mistakes in the scrub tracepoints that can manifest when
inode-rooted btrees are enabled.  The existing code worked fine for bmap
btrees, but we should tighten the code up to be less sloppy.

Cc: <stable@vger.kernel.org> # v5.7
Fixes: 92219c292af8dd ("xfs: convert btree cursor inode-private member names")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -458,7 +458,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = cur->bc_ino.ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;


