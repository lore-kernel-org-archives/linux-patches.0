Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D971DA3D;
	Tue,  3 Dec 2024 15:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239248; cv=none; b=oY6Sun/ck9QIpdFbq7blewX0S9MLlqysGyUgSn4MFypVMuiqiuZD8iQlv0INbbkREf+zkhR6EhHPF5i3hgwaGOJToi+1iJFs+B3LubWfP0xt73Hm7isPT28/dk7sTLUI5e1WV4EJx1PQZAGjTN17Dpa9+OaulnjZMIW0d4Ntcro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239248; c=relaxed/simple;
	bh=wLB7Ouh0E5GRJ5xeshpEQFIr7iDyReE6zyCOlx4OP1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7kJDpEETXxtdLSElMnLTPb29Eabx3pbI5EiG6bmzgDBYeWEtdFBPbXC5YE32Ss2Lqc0pMG4c2THm7y/Zo1ktmfTJg+I3Ao4gU/HxcpehvX7Cx/LQsCvVm6CcX4w5ABGwqJJWcOvzMIVmnocB6W1a0exQdefmJ7BwXNtdHb64MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LH/6h8hB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LH/6h8hB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3ADC4CED8;
	Tue,  3 Dec 2024 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239248;
	bh=wLB7Ouh0E5GRJ5xeshpEQFIr7iDyReE6zyCOlx4OP1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LH/6h8hBHkv0Gf5DaKK6g/AQRjRtgFOqUKIENbdnO/w15CJ3i/Yl+Vg23d5OKpfBt
	 9EsPCF1wgOpIQR7dnZaY3L93Qy8TQl3oflTg0DsKZqi8XZny7iuU76GJFPT0urcS7J
	 5DkiwPkk/lhRrKKr+yuaXcQIp3SRlRk4mDQ6k3Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 541/817] NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()
Date: Tue,  3 Dec 2024 15:41:53 +0100
Message-ID: <20241203144017.021968963@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f64ea4af43161bb86ffc77e6aeb5bcf5c3229df0 ]

It's only current caller already length-checks the string, but let's
be safe.

Fixes: 0964a3d3f1aa ("[PATCH] knfsd: nfsd4 reboot dirname fix")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 69a3a84e159e6..d92c650888312 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -659,7 +659,8 @@ nfs4_reset_recoverydir(char *recdir)
 		return status;
 	status = -ENOTDIR;
 	if (d_is_dir(path.dentry)) {
-		strcpy(user_recovery_dirname, recdir);
+		strscpy(user_recovery_dirname, recdir,
+			sizeof(user_recovery_dirname));
 		status = 0;
 	}
 	path_put(&path);
-- 
2.43.0



