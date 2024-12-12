Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60175221D93;
	Thu, 12 Dec 2024 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025009; cv=none; b=VI0n2h8UBC9mAmVJ0kxqRJF17+GK1oR0qqT9qod6w0v35VrdZfF+B6y9IuXB64F8ASaeBZObZFN0TzteOFOWU4lCPJ3JLlt2dqtE5WEwzjvbgDM/mJFEAS6fh4w9xj5ef6rjaqRo/Hqd3YiAIP5Smn68kibsmaombhfGeWBqhyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025009; c=relaxed/simple;
	bh=JpeSKqi5dqsLA3+kpy2a1JqHZOXogP35oekri1220Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWQRvyERdVedZo9d5LeMNgJ2+fGAZD8WWyn9Z9aAK5ecYjkWrSyZ/B9kEZibp4WlaUP/VzTk3c40dYaOutPVLtvYKVLQnLVDIMHaTFToXZ4EZczbQeN5oWiPe3z0tJb5/VjG/n8JrclskcEgnVA4HI2jBWzx/q6CN46u6jnNF3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hChK5284; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hChK5284"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F4FC4CED3;
	Thu, 12 Dec 2024 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025009;
	bh=JpeSKqi5dqsLA3+kpy2a1JqHZOXogP35oekri1220Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hChK5284Wro5WQNRlq+VmInXzwGSt//62MSfys3mORR2yW6tQEGM+bb2hCKxFaxTx
	 P7b5H7A3U6S04J3UuQtJRzBdvIJtC9BJ7OhfV03bL1wH6TLldgdE/HGTsye3RaUKjM
	 avbhx4MorNpcn1AZOx2GsY4blWIxgAX9tsB7vBhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/321] NFSD: Force all NFSv4.2 COPY requests to be synchronous
Date: Thu, 12 Dec 2024 15:59:04 +0100
Message-ID: <20241212144231.036049453@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8d915bbf39266bb66082c1e4980e123883f19830 ]

We've discovered that delivering a CB_OFFLOAD operation can be
unreliable in some pretty unremarkable situations. Examples
include:

 - The server dropped the connection because it lost a forechannel
   NFSv4 request and wishes to force the client to retransmit
 - The GSS sequence number window under-flowed
 - A network partition occurred

When that happens, all pending callback operations, including
CB_OFFLOAD, are lost. NFSD does not retransmit them.

Moreover, the Linux NFS client does not yet support sending an
OFFLOAD_STATUS operation to probe whether an asynchronous COPY
operation has finished. Thus, on Linux NFS clients, when a
CB_OFFLOAD is lost, asynchronous COPY can hang until manually
interrupted.

I've tried a couple of remedies, but so far the side-effects are
worse than the disease and they have had to be reverted. So
temporarily force COPY operations to be synchronous so that the use
of CB_OFFLOAD is avoided entirely. This is a fix that can easily be
backported to LTS kernels. I am working on client patches that
introduce an implementation of OFFLOAD_STATUS.

Note that NFSD arbitrarily limits the size of a copy_file_range
to 4MB to avoid indefinitely blocking an nfsd thread. A short
COPY result is returned in that case, and the client can present
a fresh COPY request for the remainder.

Link: https://nvd.nist.gov/vuln/detail/CVE-2024-49974
[ cel: adjusted to apply to origin/linux-5.4.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index e38f873f98a7f..27e9754ad3b9d 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1262,6 +1262,13 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	__be32 status;
 	struct nfsd4_copy *async_copy = NULL;
 
+	/*
+	 * Currently, async COPY is not reliable. Force all COPY
+	 * requests to be synchronous to avoid client application
+	 * hangs waiting for COPY completion.
+	 */
+	copy->cp_synchronous = 1;
+
 	status = nfsd4_verify_copy(rqstp, cstate, &copy->cp_src_stateid,
 				   &copy->nf_src, &copy->cp_dst_stateid,
 				   &copy->nf_dst);
-- 
2.43.0



