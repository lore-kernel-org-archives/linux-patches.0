Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC37158DC0;
	Tue, 18 Jun 2024 13:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716441; cv=none; b=E7Ytgzmy9I8pwmouiIvfai2Z2bih3VRNOi5oJk/doNJabZ0JQZjotTyudKObI3Sl+W69kd9F+thU10RwUhnBOJl3U3NNNl2/3ryVqvYnxpduq+fsvzmeCCMVHaOIDbHzEtaHGfgKMj/RGcADrgRDjBiX+ay07uLM7lB8s/pla4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716441; c=relaxed/simple;
	bh=A6UBKihWxQT052TL8d/48IfGrivIrdFjDxnknSP25wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PExVv5aKAysvcZKn9EW812ZuC3nip8HDDgivxA8Kti0oMyAgFpo5DzgDsBgsiMBV8lVPhBjdlLzK02r4SpWaXiAezHi6qNqtRU3L4lKFsrjecVMTSbMd5fHQbmZkN0mV0Q250nQuZxpWO8iQfY7nKmEfSfjAjp5Xun7t+37OtMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSqGvcmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSqGvcmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61010C3277B;
	Tue, 18 Jun 2024 13:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716440;
	bh=A6UBKihWxQT052TL8d/48IfGrivIrdFjDxnknSP25wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSqGvcmLVJRuCiZ3ZdvHcMtkAA6aDpV3SO53Nso7mGB0+ZQo1LmwVEMIu4JiRoUBa
	 f3yHnSHWl7PpP8sjtNrFHycIsJN1EZar7Df8phDRfIctr4htfBSgDzfuCq0cAbK0Xa
	 MSyvCricwq4tfVKU2PBGbt47wjSTON0Tny4kGjMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 646/770] NFSD: Make nfsd4_remove() wait before returning NFS4ERR_DELAY
Date: Tue, 18 Jun 2024 14:38:19 +0200
Message-ID: <20240618123432.224808746@linuxfoundation.org>
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

[ Upstream commit 5f5f8b6d655fd947e899b1771c2f7cb581a06764 ]

nfsd_unlink() can kick off a CB_RECALL (via
vfs_unlink() -> leases_conflict()) if a delegation is present.
Before returning NFS4ERR_DELAY, give the client holding that
delegation a chance to return it and then retry the nfsd_unlink()
again, once.

Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=354
Tested-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: backported to 5.10.y, prior to idmapped mounts ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5684845d95119..e29034b1e6128 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1803,9 +1803,18 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 
 	fh_fill_pre_attrs(fhp);
 	if (type != S_IFDIR) {
+		int retries;
+
 		if (rdentry->d_sb->s_export_op->flags & EXPORT_OP_CLOSE_BEFORE_UNLINK)
 			nfsd_close_cached_files(rdentry);
-		host_err = vfs_unlink(dirp, rdentry, NULL);
+
+		for (retries = 1;;) {
+			host_err = vfs_unlink(dirp, rdentry, NULL);
+			if (host_err != -EAGAIN || !retries--)
+				break;
+			if (!nfsd_wait_for_delegreturn(rqstp, rinode))
+				break;
+		}
 	} else {
 		host_err = vfs_rmdir(dirp, rdentry);
 	}
-- 
2.43.0



