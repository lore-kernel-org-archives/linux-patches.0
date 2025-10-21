Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF0624A047;
	Tue, 21 Oct 2025 20:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077284; cv=none; b=IXEmdEY0+xSJRso9xVv4inzu5qBiooyZWIHribl8SbVEtA+EVEhRtDvWgLIRwgr3axJ9CCOae+WxjPPo4DJo82nDXcg6nB9Sf/K1ycemeEoTy0pOiBzS/7DF7Oh6bOrL0MV0Yn1CHx2pvxYEOYcDWoiSaEx2esjLs5WeruIM5E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077284; c=relaxed/simple;
	bh=jnzs1dq1Gd6UI6RgYc9YElBgUizkQprFYB5SHU59QtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6n7J6RsyKKFgoZKbx4aMglWFKsRZDgaR0lu50/PB0DxHHM8A5A38bM78jrdoux2le3RbNwEs0esqV3PkL7SOQ84Lh/IhBOmzOXNi2mj3VVkk20xCm78O5AaO2o1O5wNDmIkvcf8KTqvXBS+sjxFiKERfLEHGLD/q4FfdohEwlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArlUU4SI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArlUU4SI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599CEC4CEF1;
	Tue, 21 Oct 2025 20:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077284;
	bh=jnzs1dq1Gd6UI6RgYc9YElBgUizkQprFYB5SHU59QtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArlUU4SI98/TZW4uDi0m6QLeZ1EagDv5VAqBFLyp/e/Wv68c8B87GK5hxg8WUkptQ
	 UpYYHK97Qd9i0/cwE9KfxkrokRM+NM1KCOE4KLC+Vi6camXQ4IBqo9ArORCTjLNEqZ
	 sVP/jVEL5sXarzHKWPrvtOnPWMV3cMHLm9QbJR5Y=
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
Subject: [PATCH 6.17 058/159] dax: skip read lock assertion for read-only filesystems
Date: Tue, 21 Oct 2025 21:50:35 +0200
Message-ID: <20251021195044.611207738@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 20ecf652c129d..260e063e3bc2d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1752,7 +1752,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
-	} else {
+	} else if (!sb_rdonly(iomi.inode->i_sb)) {
 		lockdep_assert_held(&iomi.inode->i_rwsem);
 	}
 
-- 
2.51.0



