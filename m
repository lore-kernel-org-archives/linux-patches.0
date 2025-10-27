Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC976328627;
	Mon, 27 Oct 2025 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591548; cv=none; b=jxtEPK5sMdDhMG88so8NhCH4O68uXi1pW2pY+4vM4NddFzmdVMci/a8Ovlhyir6GYb11FVCue21XKtapwoVdbxmCMxGe1zQVDWhVGCyTMcjFxfiB3FwuK5M8mt+5R1IDilH85vOzYuiRVfmClQKyf3U9+2rnW8NykCOLfNIF1JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591548; c=relaxed/simple;
	bh=CTHG3zaZBAohLBBfHt36CXMhWK/Lq2FNj/RyJP6aJGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpL5Kh20PtLHKIkk+MDIKY5uojhWrTKqDvrmsj9c8z2XnLtgnQgGh4G0MfXoI0ZF5ttZstUIQXZmMfelutwnhWPfdglVdjq8efmh1vOWHXd8dFgo+vn2MPmRBWkXaWp0gs+r0UeDYlDGrJGCYqCRI9+x1VamVyAhuaQC9gPNjhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHgj/hqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHgj/hqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6329CC4CEF1;
	Mon, 27 Oct 2025 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591548;
	bh=CTHG3zaZBAohLBBfHt36CXMhWK/Lq2FNj/RyJP6aJGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHgj/hqFewqlg3O0ASniifII3IFC+AXJ5V6Lgj+RzrQSn3uuwsce5AF5N29Nn9T+S
	 pOkZBS8mIPQ2v1qaSP5wFThzdq6+4C9G161lGMUbn5MJxfHAuiG9HchmzUc2KUPKYM
	 hnjh1STASEFEe1PGUlKUwSw39W7msrnieGaQm6o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Friendy Su <friendy.su@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/332] dax: skip read lock assertion for read-only filesystems
Date: Mon, 27 Oct 2025 19:34:53 +0100
Message-ID: <20251027183531.167578086@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 154d1e7ad9e5ce4b2aaefd3862b3dba545ad978d ]

The commit 168316db3583("dax: assert that i_rwsem is held
exclusive for writes") added lock assertions to ensure proper
locking in DAX operations. However, these assertions trigger
false-positive lockdep warnings since read lock is unnecessary
on read-only filesystems(e.g., erofs).

This patch skips the read lock assertion for read-only filesystems,
eliminating the spurious warnings while maintaining the integrity
checks for writable filesystems.

Fixes: 168316db3583 ("dax: assert that i_rwsem is held exclusive for writes")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6619a71b57bbe..a6f481f1517dd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1222,7 +1222,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
-	} else {
+	} else if (!sb_rdonly(iomi.inode->i_sb)) {
 		lockdep_assert_held(&iomi.inode->i_rwsem);
 	}
 
-- 
2.51.0



