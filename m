Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7AE13AA44;
	Tue, 18 Jun 2024 13:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716718; cv=none; b=R04k+UtdE6JASq/pdZU6HMvvCBvmheEWjbQzA/9F8VR/4cPt1doNuQQhBb3eqtjr3LsW2doarEG1TMYvqmZYUORqp1KxIehOX4VsjDYVGgwuTGTdlZmkVBQHn8zrxbib5Z3sO7sTCWHC6Mr9yhVaj5UwMl0ZL60LCLDWyobAKC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716718; c=relaxed/simple;
	bh=qqSWethrZkj4rCcUHjqLdtkXZ6mVWMCyxlQfljAvaoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKeJ7UhP7X78jRqCSQ5narpRWAOZDeHrv04zjQcGMDIcTaBioQfG0mhEctDsbwq98VwkkDyS7dxBE8jIkqP4cwjyp/KUg50MKFAfupYqP5IdA7YN9+plvfKEku2JjW7LCdJGUkJy4+kMSLKJ2HSU5qIEzj624AiVFX69bHefXwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhtPUpdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhtPUpdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A082FC3277B;
	Tue, 18 Jun 2024 13:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716718;
	bh=qqSWethrZkj4rCcUHjqLdtkXZ6mVWMCyxlQfljAvaoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhtPUpdtjq5H1ZTOcMLg1QryI+rXV635rMmGcMzTh9bx09tkcWu9gAnqkh9Rgc0sA
	 kJ+vB6q7+pfsZAicKnWOgWL1Rx+1jhUVsOMNlv97d6SE+Py3WSgWoJ4sdQsWrUjEdl
	 6yqcyn5zdMbKkc97QPLz9ApwYZpkE+EXq5m+lx/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	flole@flole.de,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 739/770] NFSD: Protect against filesystem freezing
Date: Tue, 18 Jun 2024 14:39:52 +0200
Message-ID: <20240618123435.794106514@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit fd9a2e1d513823e840960cb3bc26d8b7749d4ac2 ]

Flole observes this WARNING on occasion:

[1210423.486503] WARNING: CPU: 8 PID: 1524732 at fs/ext4/ext4_jbd2.c:75 ext4_journal_check_start+0x68/0xb0

Reported-by: <flole@flole.de>
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217123
Fixes: 73da852e3831 ("nfsd: use vfs_iter_read/write")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 3d67dd7eab4b5..ddf424d76d410 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1117,7 +1117,9 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	since = READ_ONCE(file->f_wb_err);
 	if (verf)
 		nfsd_copy_write_verifier(verf, nn);
+	file_start_write(file);
 	host_err = vfs_iter_write(file, &iter, &pos, flags);
+	file_end_write(file);
 	if (host_err < 0) {
 		nfsd_reset_write_verifier(nn);
 		trace_nfsd_writeverf_reset(nn, rqstp, host_err);
-- 
2.43.0



