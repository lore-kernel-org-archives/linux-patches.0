Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F371AD3E1;
	Tue, 18 Jun 2024 13:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716768; cv=none; b=jzsn+7ZZJ670hDsjoSy1S/EBQUUmZvFGQP7oPcOCgcsJQhCDO+RzpNndhHEarN6OMorrwnJsvjP5al4VBP7pBEO25LajE9vo9ETj3TbiO2tNc51PL8M4NcFCacaETbZLh9aHlsWrWfgh8R3jC7O/lrRCR8iMydzGDmu7kOGqfvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716768; c=relaxed/simple;
	bh=ou7CMSSDnPTZqtCBrefQGTrUjnCYzYem0K5GmmKTng8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyAzminUfxXyN4Fnzq0wAPQmY4cOjZQH2B7KAAKe/+zvWsuDFiUwfHr89CZSY0AA78RZkf/F/Z4sUtHJaweVU39AeJMVW3yEdvY/flaofc3OZFOuRqgxIQb47Kjm+cHBk73m7R+JrX/cuEiV+4y8YuEZiX9wHuT5BjZ142U/hXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6VIwvAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6VIwvAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB3AC3277B;
	Tue, 18 Jun 2024 13:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716768;
	bh=ou7CMSSDnPTZqtCBrefQGTrUjnCYzYem0K5GmmKTng8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6VIwvApTXjpUb2PFdSROH6elIf7SSEIN7E/bktNdFjG3ZTubxpRtDGbpCH4ptN6e
	 wYlxlInZrSg1P3POKB5blW423TfPMntJPmmBw+jto7S8OrAxa3RrgW8mR45ADVNbWo
	 +XTx86dR+YCMqPpIKJUYUFcFVkJnfyOYl2135j/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 725/770] NFSD: fix use-after-free in nfsd4_ssc_setup_dul()
Date: Tue, 18 Jun 2024 14:39:38 +0200
Message-ID: <20240618123435.254541640@linuxfoundation.org>
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

From: Xingyuan Mo <hdthky0@gmail.com>

[ Upstream commit e6cf91b7b47ff82b624bdfe2fdcde32bb52e71dd ]

If signal_pending() returns true, schedule_timeout() will not be executed,
causing the waiting task to remain in the wait queue.
Fixed by adding a call to finish_wait(), which ensures that the waiting
task will always be removed from the wait queue.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index a89f98fa3a9d0..4ab063a2ac84e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1320,6 +1320,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 			/* allow 20secs for mount/unmount for now - revisit */
 			if (signal_pending(current) ||
 					(schedule_timeout(20*HZ) == 0)) {
+				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
 				return nfserr_eagain;
 			}
-- 
2.43.0



