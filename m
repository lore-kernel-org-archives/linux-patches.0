Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EDB16EB4B;
	Sun,  1 Sep 2024 16:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207675; cv=none; b=L9Ls+GpXPd/Bcib5qhBAzd7+wmO6uRg/jPyUNhBDFyYDWkZy1Ik+p9gkqWM713N/b+GpwXSaU7yyCHjIX9jGxnoxSIqikVkJIy+BHnNgGNlVcswcchGaQ4xM7yYQv65alVhHRmIoxIJokeuiTpPKp+PejGEA3zETEtFdjz+wcOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207675; c=relaxed/simple;
	bh=shXGe0sxiUgBw0WuoEvS7wAlXI0jyKkVtSyan+KPcEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0gW7Z9DwqOT3yjPO55D7dOvGPpV/D1akOxj3Ez8kdaj6gDHfyFuvEHs6XubYgdCqaYLdzCx3MrGh6lA9UD06yppR1cqUMxk+6qQJhJX6KE+BLfNwdw0zXfuIlABhcUs501eVC7Qo74//Bb1ivzahn/m7Sq98k5iqdDOHn7/0fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=md4Opwe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="md4Opwe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DA1C4CEC3;
	Sun,  1 Sep 2024 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207675;
	bh=shXGe0sxiUgBw0WuoEvS7wAlXI0jyKkVtSyan+KPcEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=md4Opwe6oqUzfAQXs1L/miVFJKICttZn1n/+L5rL7mmxMTpbCibERVEP7VtmzfDik
	 fXspKtIxEMDyl1IZ1OoUMbO4hrdWyFXHmUxYGvlH1fp6ww4E1pn3SkPeJGkiKDo+B9
	 AKBjaeinOx8FwJAs4jeBjtANVThl8/HnaFoGnuGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/98] NFS: avoid infinite loop in pnfs_update_layout.
Date: Sun,  1 Sep 2024 18:16:13 +0200
Message-ID: <20240901160805.324169944@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index cfb1fe5dfb1e1..7a0d9a1e6d134 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1889,6 +1889,14 @@ pnfs_update_layout(struct inode *ino,
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



