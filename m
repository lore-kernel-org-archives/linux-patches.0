Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11C219DF7F;
	Tue, 18 Jun 2024 13:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715953; cv=none; b=FfnP3VqZr39zWFIaX4rTZgfuIhDTrj4aLgx52LqBMYXWgneP9hnCWieenQX6fz8R9hzq99EnvCreWQi6vwZGIJ5qulvZ45HpWzOTNddTV97r3v5f1uHayRrX5CQ1bt5mpjbQTFX28DStSDeLU6Uv22kzfejiwRQdivRfsTgC67A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715953; c=relaxed/simple;
	bh=b2e0tNdukoVZmOT7DqelNCEs6JKIJ2xUS/qCkaLuuyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUYl8J9GJ3ApbmHzzolWuZ7350wxrAr+RlHtac095kkb353GKwZogSYIOX5sEKE0f9HeD0YIe3rVTCFmHwZjHJX+AtfpPI2XkFSTfGKRZDyNmxj89qdhO5Gd7zpZzMTfjgyyLdLiD+3bO6t9vwQyXQumuocALOc2EaV7JB9LZV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJIFTDa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJIFTDa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4079C3277B;
	Tue, 18 Jun 2024 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715953;
	bh=b2e0tNdukoVZmOT7DqelNCEs6JKIJ2xUS/qCkaLuuyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJIFTDa3N7FnespoUJKUWW1rXocKa2+aETOV4QprbVHO3rqJY9Ccrjlaq92PhNMEU
	 rxSbf+pnu3ZoOf9d3i/hKaQ6/XZmpMjlk8fM1teWZwQzkqOcNjafBR4RMLz2TEyisq
	 qOohAjX1shzHoOUMcN4RhNpXktFT4ZBSkPWUBiHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 451/770] NFSD: Clean up nfsd_vfs_write()
Date: Tue, 18 Jun 2024 14:35:04 +0200
Message-ID: <20240618123424.704100337@linuxfoundation.org>
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

[ Upstream commit 33388b3aefefd4d83764dab8038cb54068161a44 ]

The RWF_SYNC and !RWF_SYNC arms are now exactly alike except that
the RWF_SYNC arm resets the boot verifier twice in a row. Fix that
redundancy and de-duplicate the code.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index b343677b01efa..cef8435d76a69 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1023,22 +1023,11 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
 	since = READ_ONCE(file->f_wb_err);
-	if (flags & RWF_SYNC) {
-		if (verf)
-			nfsd_copy_boot_verifier(verf,
-					net_generic(SVC_NET(rqstp),
-					nfsd_net_id));
-		host_err = vfs_iter_write(file, &iter, &pos, flags);
-		if (host_err < 0)
-			nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
-						 nfsd_net_id));
-	} else {
-		if (verf)
-			nfsd_copy_boot_verifier(verf,
-					net_generic(SVC_NET(rqstp),
-					nfsd_net_id));
-		host_err = vfs_iter_write(file, &iter, &pos, flags);
-	}
+	if (verf)
+		nfsd_copy_boot_verifier(verf,
+				net_generic(SVC_NET(rqstp),
+				nfsd_net_id));
+	host_err = vfs_iter_write(file, &iter, &pos, flags);
 	if (host_err < 0) {
 		nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
 					 nfsd_net_id));
-- 
2.43.0



