Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA3332BC1A;
	Wed, 17 Sep 2025 12:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113279; cv=none; b=K9Iq30CzbTpIbCzPHFALbPeqvoFktYhvIvFN7Ea1RNW8s/DbglM4zn+nwJqY57nhGMA1HxkYr1++Pz6TmRqRHP8Ys6xtX1SvBjIjZ/utbrCfnN3HpUV9uktcuOce5Y23C3S5XtcON4/n9Br5z/796ay6nYd7z8nWnze2prITs5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113279; c=relaxed/simple;
	bh=S5EYKO6O8JHNuAa7NZdNQj1p/bWO8GdPWjINnS+FgeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anR+Ea/u5z/xyeJqRp9Dbo+9VcRGfPNbTttO0Bg1m0jZG/SER8ziC6IQi/bpWfxWwmpG+ktf6d0s4MArObQuP60DrPvurvMNDkyRURpf8J1Dcf+0DYQrh2TeoJ8lyGZYnzjQIzLNT1JYqAwYSe4JYKt75+fVDM6RzQbKVJitE4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7vgEgWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7vgEgWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092CBC4CEF5;
	Wed, 17 Sep 2025 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113279;
	bh=S5EYKO6O8JHNuAa7NZdNQj1p/bWO8GdPWjINnS+FgeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7vgEgWs0kakCZqkgv3fYHgvVjT4+Sz5Nmqvhw0eckO2VWh58fx9svIzSXBVPjEHI
	 V3DFu06CI3d7RBToYNNOI3EOFOQ/CH01Wu0Tr/VPhfE+Jig0Q/rXLAAFZeiRbpLYol
	 Yy8Wv+FCRKVcFuSv0tUb/PzTklqvk8Xiuvr/q/1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/140] nfs/localio: restore creds before releasing pageio data
Date: Wed, 17 Sep 2025 14:33:22 +0200
Message-ID: <20250917123345.043955682@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 992203a1fba51b025c60ec0c8b0d9223343dea95 ]

Otherwise if the nfsd filecache code releases the nfsd_file
immediately, it can trigger the BUG_ON(cred == current->cred) in
__put_cred() when it puts the nfsd_file->nf_file->f-cred.

Fixes: b9f5dd57f4a5 ("nfs/localio: use dedicated workqueues for filesystem read and write")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20250807164938.2395136-1-smayhew@redhat.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 8fb145124e93b..82a053304ad59 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -425,12 +425,13 @@ static void nfs_local_call_read(struct work_struct *work)
 	nfs_local_iter_init(&iter, iocb, READ);
 
 	status = filp->f_op->read_iter(&iocb->kiocb, &iter);
+
+	revert_creds(save_cred);
+
 	if (status != -EIOCBQUEUED) {
 		nfs_local_read_done(iocb, status);
 		nfs_local_pgio_release(iocb);
 	}
-
-	revert_creds(save_cred);
 }
 
 static int
@@ -626,14 +627,15 @@ static void nfs_local_call_write(struct work_struct *work)
 	file_start_write(filp);
 	status = filp->f_op->write_iter(&iocb->kiocb, &iter);
 	file_end_write(filp);
+
+	revert_creds(save_cred);
+	current->flags = old_flags;
+
 	if (status != -EIOCBQUEUED) {
 		nfs_local_write_done(iocb, status);
 		nfs_local_vfs_getattr(iocb);
 		nfs_local_pgio_release(iocb);
 	}
-
-	revert_creds(save_cred);
-	current->flags = old_flags;
 }
 
 static int
-- 
2.51.0



