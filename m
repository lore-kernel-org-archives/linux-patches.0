Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF9432E733;
	Wed, 17 Sep 2025 12:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113678; cv=none; b=YBtSN+uYRxyHSdFeCb07JC5YK5Pdg+m0BWtI8V9oi+2LkZYevY+buzb8pvvjOt0bkrIY/1zNyWPcmykHM4RVQO29zRChDOtvKUfrfk6o2YHTuad57AK021FBB039GwN+GcMWfxeyYUrhqQvchitCyzP415uq98/X9fBRsl8jSk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113678; c=relaxed/simple;
	bh=Xo8CEXQPm5FU9rOiCNTsRrlLv+ATGtQOzGO+Coj5gtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6ZXkAsM6PVMPEhvdW4fN6rcdqsUVeQSdSky+71x6jRWzrKj8oCuAJOGifmiWqgrAJer+96iF8PaIrKdc0dpNDYZNI2IMSqj6Mn4sA40q4Go6RTyH1a5uo1GAIvDnE25+W2LHNrFM80eI3J3iBsRkXHR+s/Rx6e2XQV6eJGQCJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fsib1+b2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fsib1+b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D80C4CEF0;
	Wed, 17 Sep 2025 12:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113678;
	bh=Xo8CEXQPm5FU9rOiCNTsRrlLv+ATGtQOzGO+Coj5gtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fsib1+b28f68t9qxS+LAFD5EEfUsT5pLjU+J3WyCoaHnNXUGpOePy75pvLDhm5DZY
	 2uDctDPCWO43lAdxF/QVEIKW1ZSAnk67sGOTYVkFG4UiWLOt23qdmfWWDzbVEBMgn1
	 BugXwev2tjrTvB67o/9qsxNJF0AO3SQ+vvPCZbuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/101] NFSD: nfsd_unlink() clobbers non-zero status returned from fh_fill_pre_attrs()
Date: Wed, 17 Sep 2025 14:33:48 +0200
Message-ID: <20250917123336.997651546@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit d7d8e3169b56e7696559a2427c922c0d55debcec ]

If fh_fill_pre_attrs() returns a non-zero status, the error flow
takes it through out_unlock, which then overwrites the returned
status code with

	err = nfserrno(host_err);

Fixes: a332018a91c4 ("nfsd: handle failure to collect pre/post-op attrs more sanely")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ Slightly different error mapping ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1970,11 +1970,9 @@ out_nfserr:
 			err = nfserr_file_open;
 		else
 			err = nfserr_acces;
-	} else {
-		err = nfserrno(host_err);
 	}
 out:
-	return err;
+	return err != nfs_ok ? err : nfserrno(host_err);
 out_unlock:
 	inode_unlock(dirp);
 	goto out_drop_write;


