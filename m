Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BAA3370EC;
	Thu, 17 Sep 2026 15:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660625; cv=none; b=NBC3fq0RqnedQNf/3YF9Lqd50gY9/fXicqRonU2JP109SWJsprlhb5kin6FeEZr7/38ZLV20o4PtYRLi97izrX4JWQCSggaSGaUmeHV7TadZ4qPl2NByMgFaqUzwNa9wP5CN9nXimbyeqPFVTBUroDa3D6v7+sMadu1VeFi+W0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660625; c=relaxed/simple;
	bh=NpuEetm6/w/uefQAKbOVCTh2UV7H3vQ+oDWD5zm2WsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ox80bo5LnKkAEMgZUnQt4RtIgQSZaL4rnNDAaTA+Q1iBihLE5x2ojfDB1m9sKWVAVUuwk4UNl4lpDb5Xfkwh/d+nqI6c7hwt6cwNjJ7NT+DBgitrB/brVknTlKeHuUFmA7FbdAKlO522OuxRX5fmx3SWFWj2atseOBJsPRODeCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtmB2/hG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtmB2/hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D151F00893;
	Thu, 17 Sep 2026 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660623;
	bh=Xp27P+yai94Zenx1KCWC43o1gZ7gWqd/71L1A8uYlmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtmB2/hG35ugMBfRUnj5m7aFgup8dLKx6RygGhcjdsBPKKDPYj+nBeHrvOcbeehYk
	 0X4i/2nv5sXVLuFKXZVtbQz/4nyN2VrfxARtTSByEdQ8EKjUi1vAkr3BohMVv5mNeX
	 DK8OsKBoqHYAOSUIB+RBJGvDT1YF87+t8uUgz0xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 653/733] xfs: log the tempip after we convert it to extents format
Date: Thu, 17 Sep 2026 16:16:01 +0100
Message-ID: <20260917151408.910176991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit ed799148e0d63ef41ab60ce98963a1dc423090d3 upstream.

LOLLM points out that xrep_symlink_swap_prep converts sc->tempip to an
extents format file prior to the atomic swap, but incorrectly logs
sc->ip immediately afterwards.  Fix that, and the other problem that
we're supposed to tell xfs_trans_log_inode what to log and don't.

Cc: stable@vger.kernel.org # v6.10
Fixes: 2651923d8d8db0 ("xfs: online repair of symbolic links")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/symlink_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -291,7 +291,7 @@ xrep_symlink_swap_prep(
 		if (error)
 			return error;
 
-		xfs_trans_log_inode(sc->tp, sc->ip, 0);
+		xfs_trans_log_inode(sc->tp, sc->tempip, logflags);
 
 		error = xfs_defer_finish(&sc->tp);
 		if (error)


