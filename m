Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175361C6899;
	Tue, 27 Aug 2024 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770346; cv=none; b=VMe9qW1GSos8E8P/no1E5PSgjI+OWiplilJgdS55RfUNf+EJmFBMbcblCgjVr/1MHLd1PEXNxBQt81g0Gpq1nMvop3PokrRedbV6UKwsZyJ5Q1xLwAyXKa5g9JQG6lpiol26aG/jljur+Znsqp2ZKL17gcy+CD8YAZbaGx6o61U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770346; c=relaxed/simple;
	bh=8W/kaJoVZRWC7NbckAyZhBn89s6lA4iQGWm5vdDcKqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjkXzenwQU75c/75ine6RYmqw63IbnpHXzd9BrXCr7ryxIyUXY4uzys7U7rddZ7GwmPZrjeNcVydOV+7+fWNlCzkMjmBTrrlcWcgoxsbRwWV8aeQZBQX5tsXCAdKtau9F6UFJCBNQ7FN3mYED2uFjSMpCpNNdplXKJA/3wuxJnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUJfgMVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUJfgMVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7CFC61049;
	Tue, 27 Aug 2024 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770346;
	bh=8W/kaJoVZRWC7NbckAyZhBn89s6lA4iQGWm5vdDcKqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUJfgMVm8yIU8DyTO9hyMxR6W/lYjGgixIJ3YCfkTGnLxH1lMAn3WxZ3Mq3g780cS
	 YZlkdMmS0hGIcvEjW0gNoJKFHTEqjMBsNYbJ4F/u+1SFd9rNf2yU+5Te/UJHxtIBJv
	 XW8LMdNBBBw9JVPzAO1xd3qyv55XnV67yXVGh4e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/341] NFS: avoid infinite loop in pnfs_update_layout.
Date: Tue, 27 Aug 2024 16:37:13 +0200
Message-ID: <20240827143851.102444199@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 2fdbc20036acda9e5694db74a032d3c605323005 ]

If pnfsd_update_layout() is called on a file for which recovery has
failed it will enter a tight infinite loop.

NFS_LAYOUT_INVALID_STID will be set, nfs4_select_rw_stateid() will
return -EIO, and nfs4_schedule_stateid_recovery() will do nothing, so
nfs4_client_recover_expired_lease() will not wait.  So the code will
loop indefinitely.

Break the loop by testing the validity of the open stateid at the top of
the loop.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 9084f156d67bf..664d3128e730c 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1997,6 +1997,14 @@ pnfs_update_layout(struct inode *ino,
 	}
 
 lookup_again:
+	if (!nfs4_valid_open_stateid(ctx->state)) {
+		trace_pnfs_update_layout(ino, pos, count,
+					 iomode, lo, lseg,
+					 PNFS_UPDATE_LAYOUT_INVALID_OPEN);
+		lseg = ERR_PTR(-EIO);
+		goto out;
+	}
+
 	lseg = ERR_PTR(nfs4_client_recover_expired_lease(clp));
 	if (IS_ERR(lseg))
 		goto out;
-- 
2.43.0



