Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9803C401A0A;
	Thu, 16 Jul 2026 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211628; cv=none; b=LhupKALhU5nyuzSWAVjYByAkqqBkYm7FrmzeIAcWPJ5JEPD247ta/c37e8bXFLqHlQvb+Jy7OXPTtzkH4yhiPh7+H6MMaXzaxZ4ATpk3GtFFABvLNeeMNm3FzUaU3coL4SIMJ40EH8uuRXRYQlPpQE9AbHpS0mq3jVZSq3jtPug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211628; c=relaxed/simple;
	bh=Ic8mslHDzNmj2/60HgUKhlpC0qGbj8xq8a+UQbC9p/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrzgZKuLyspKR8aBu02CarAnQatRgpbkCamA37FWYUn9hs647qbRrCoGWNO5xbnQaWl4ZtHGJRIbnB+USR4VFVy2pcCy5ZGogWJkcjdyCsMZkKzQmIT1kHudyEfSYNRgC8WuhddJosrj+5vFwLQsuAi+tWOh7XOJCaGwUYGxtRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBzGQlWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBzGQlWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093CA1F00A3D;
	Thu, 16 Jul 2026 14:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211627;
	bh=PubHpJicT71FyMDlYHDNSO5Ey8q+L9fzzQBZyLBmcxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBzGQlWseMUUQW7BtGddMHaGokdArvY5tOSB8bfyoElCRngvBud8RcWq6G474pGbB
	 ikx2UyWRyZnpGmlWBwP7T9xK/H4KWxjdhiyUfGrUj1A6mbCm5M7EeWndVXqFrUo7VS
	 2JcFHmehUd9v7gKw0Vb27ExhWIfNCacs0w0ivNwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/349] nfsd: add nfsd_file_{get,put} to nfs_to nfsd_localio_operations
Date: Thu, 16 Jul 2026 15:29:14 +0200
Message-ID: <20260716133033.750724772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit a61466315d7afca032342183a57e62d5e3a3157c ]

In later a commit LOCALIO must call both nfsd_file_get and
nfsd_file_put to manage extra nfsd_file references.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: 2c6bb3c40bc2 ("NFSv4/flexfiles: reject zero filehandle version count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/localio.c          |    2 ++
 include/linux/nfslocalio.h |    2 ++
 2 files changed, 4 insertions(+)

--- a/fs/nfsd/localio.c
+++ b/fs/nfsd/localio.c
@@ -29,6 +29,8 @@ static const struct nfsd_localio_operati
 	.nfsd_net_put  = nfsd_net_put,
 	.nfsd_open_local_fh = nfsd_open_local_fh,
 	.nfsd_file_put_local = nfsd_file_put_local,
+	.nfsd_file_get = nfsd_file_get,
+	.nfsd_file_put = nfsd_file_put,
 	.nfsd_file_file = nfsd_file_file,
 };
 
--- a/include/linux/nfslocalio.h
+++ b/include/linux/nfslocalio.h
@@ -56,6 +56,8 @@ struct nfsd_localio_operations {
 						const struct nfs_fh *,
 						const fmode_t);
 	struct net *(*nfsd_file_put_local)(struct nfsd_file *);
+	struct nfsd_file *(*nfsd_file_get)(struct nfsd_file *);
+	void (*nfsd_file_put)(struct nfsd_file *);
 	struct file *(*nfsd_file_file)(struct nfsd_file *);
 } ____cacheline_aligned;
 


