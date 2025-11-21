Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711F125DAEA;
	Fri, 21 Nov 2025 13:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730945; cv=none; b=oApIhNvAPfth8M6ft1cHB6/PqucJRoGZzT3V+ycWmZIJanbUa9fwgHI8CnLP8kTyW+8oZ9qtYYKWDrHgkNnfuXmnfwfNVzLIez3NBmllOJGedZFm92sOXMlaS2ximDebVMwUQZV1Z3+KlDkPhGM0Qw/I0CzBYNvEZcni9Rc106U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730945; c=relaxed/simple;
	bh=RYJCali2wYr36JGR9Wvv9a0jhjG6tjlWn+RcWOUgiGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CH9CR8rNGTxdjUbpVSpjv8ow0TZqBex5j8zYqm7jDTwXN+5vlYU2xprSFp6UffuXB9+RTq6mJ+nXjoWfdSCy/zsZBWBcx2nMNSYgr2exWX1CV7Ac0CSI2JgEVdWr+k8GNog22zt6/ecSBa09OVYEJkQGVLnJu8wRkDo8zm7Bdds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exQcdUP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exQcdUP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3F6C4CEF1;
	Fri, 21 Nov 2025 13:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730944;
	bh=RYJCali2wYr36JGR9Wvv9a0jhjG6tjlWn+RcWOUgiGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exQcdUP0/y7stBwhX9umJ7etzo6KEY1ub0HXrL+Dfjjke+P/BGvQaRCFIE08lq0CP
	 UyywqEcjqCXH5+oKc387GM2t7CnJmlg/C+pwflIkTy0J/WiHe8NWdZbusFW3vbj3Xn
	 SAqQ87V2D54T8UJo68gjhQZuA3qNP1vLl9XlkDk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 036/247] NFS: check if suid/sgid was cleared after a write as needed
Date: Fri, 21 Nov 2025 14:09:43 +0100
Message-ID: <20251121130155.900301047@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 9ff022f3820a31507cb93be6661bf5f3ca0609a4 ]

I noticed xfstests generic/193 and generic/355 started failing against
knfsd after commit e7a8ebc305f2 ("NFSD: Offer write delegation for OPEN
with OPEN4_SHARE_ACCESS_WRITE").

I ran those same tests against ONTAP (which has had write delegation
support for a lot longer than knfsd) and they fail there too... so
while it's a new failure against knfsd, it isn't an entirely new
failure.

Add the NFS_INO_REVAL_FORCED flag so that the presence of a delegation
doesn't keep the inode from being revalidated to fetch the updated mode.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 647c53d1418ae..d9edcc36b0b44 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1521,7 +1521,8 @@ static int nfs_writeback_done(struct rpc_task *task,
 	/* Deal with the suid/sgid bit corner case */
 	if (nfs_should_remove_suid(inode)) {
 		spin_lock(&inode->i_lock);
-		nfs_set_cache_invalid(inode, NFS_INO_INVALID_MODE);
+		nfs_set_cache_invalid(inode, NFS_INO_INVALID_MODE
+				| NFS_INO_REVAL_FORCED);
 		spin_unlock(&inode->i_lock);
 	}
 	return 0;
-- 
2.51.0



