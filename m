Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C0815532B;
	Tue, 18 Jun 2024 12:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715405; cv=none; b=fGa012c53chxaTDP8D9//mvUbiPl3p9jv0lLf9BjN7X93cPT4tkPp9ee0z/4+259omr01eXAcY5zkT+QmIVwyTghs4HYoY9j8kEB5m2RiSBBSvi9Ytbkx4gyCz8j+IoU4KhLGpRJGznQguaar8k+JLc7j0spbdl06gmBkBYv2Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715405; c=relaxed/simple;
	bh=6OzN3OB+xrJU4UvKn3xldjxVFlm+rnf33T7EnM5GX3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw9r+PR2VTZAukpTua2yLlWn4dwyJv38cWMz7elWOtHdyAT1bHOr+1u//31KBLCe9XWdbDdZOYF89oIYGn9O4RBW1lp0aoRm7GUUNkmUZuxM4WpqiZ+D44zR52FT2lx2BlnpRwQBXQsT/B3rbp7FSELEf+MfNbeUaR82R/178do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyF5KCEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyF5KCEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9203C32786;
	Tue, 18 Jun 2024 12:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715405;
	bh=6OzN3OB+xrJU4UvKn3xldjxVFlm+rnf33T7EnM5GX3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyF5KCEvQyvtAKEe1OAr5UQCjFiGIlqCU+vdjd7reJi80uQI5iYGcbkOzg7BTBTKb
	 uh44PPJKQ2ZiDeY7dNbC8bBvy1SxL4eRMwXWvvperjqPl32zq/wwOSBCRGMVxaxDGX
	 ztrdStxp0nYmJ1iNkp5+jU5Uo9YO1EMOSYRQDaeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/770] NFSD: Fix error return code in nfsd4_interssc_connect()
Date: Tue, 18 Jun 2024 14:32:30 +0200
Message-ID: <20240618123418.727231555@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 54185267e1fe476875e649bb18e1c4254c123305 ]

'status' has been overwritten to 0 after nfsd4_ssc_setup_dul(), this
cause 0 will be return in vfs_kern_mount() error case. Fix to return
nfserr_nodev in this error.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 598b54893f837..f7ddfa204abc4 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1326,6 +1326,7 @@ nfsd4_interssc_connect(struct nl4_server *nss, struct svc_rqst *rqstp,
 	ss_mnt = vfs_kern_mount(type, SB_KERNMOUNT, dev_name, raw_data);
 	module_put(type->owner);
 	if (IS_ERR(ss_mnt)) {
+		status = nfserr_nodev;
 		if (work)
 			nfsd4_ssc_cancel_dul_work(nn, work);
 		goto out_free_devname;
-- 
2.43.0



