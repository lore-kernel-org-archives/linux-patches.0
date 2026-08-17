Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90D443C058;
	Mon, 17 Aug 2026 14:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976264; cv=none; b=heQ9bHcTlzuEISTQzhwNgRyJwxOF7NChxeDHMC+BI9w3hkXxWAfQ7VRZ8UilGOo8CkpKqsNt/NOiv2Y8j3IIAUcQdf+Su27RtYNKGqqo42XQAsjnISWHNYyfKMkzu1tcDfdOhSRF6jpOIoSP5tW4zsYa3AOOC51dO1xQgPGYRoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976264; c=relaxed/simple;
	bh=Cu8xV7nSjtqw8VPzFsMtGFfohO9qLMTN1dWJXPy5PFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wdugu7NDS2O47dXHaAjdh5DqWjhc6szV0d6DmKPckbU4klI3VTXzFjL4Bi9eWy8OA+6d1cmW2XzFZ8d7nJMXkYSCGfxg3jKMpMwk37t/L25naY7GpxRziuAchZmfm0mnHgkos76kXfNKJFMXt+MA96s16XU0tzD+dWkDGnns5bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1c/x0LH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1c/x0LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECD71F000E9;
	Mon, 17 Aug 2026 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976263;
	bh=dNpYYlFPdpG7uCi0LYgkG8X3IoUF/fnRue+VmTYnGV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1c/x0LHcuzFZwREsEI+fNmRnAS9sFxdtIBtpd28LFEqie5D+cu9UlT3WWFNfi6A+
	 S+dk9DVc3pBf6q01PkK8ca90x6B1Ua14vG4L0dgk4wZRtam8dc9hnWPtEI6JcudDva
	 cEvEs/smsgDvHfgqYCERvFPt1ypvQf4SHGG4Cy6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/389] NFS: Pin the struct nfs_server during a FREE_STATEID call
Date: Mon, 17 Aug 2026 15:32:31 +0200
Message-ID: <20260817132551.162189944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Schumaker <anna.schumaker@hammerspace.com>

[ Upstream commit cf616096a0f3a2b60f7d68b6b39674a6867ded9c ]

Dan Aloni reports that he was able to hit a use-after-free bug if a
FREE_STATEID operation gets delayed for whatever reason. Fix this by
bumping the refcount of the 'struct nfs_server' object for the duration
of the FREE_STATEID so it doesn't get cleaned up from underneath us
while operations are still in flight.

Reported-by: Dan Aloni <dan.aloni@vastdata.com>
Fixes: 7c1d5fae4a87 ("NFSv4: Convert nfs41_free_stateid to use an asynchronous RPC call")
Tested-by: Dan Aloni <dan.aloni@vastdata.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bd97e0b61e70d..c455f6a8f61ae 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10138,6 +10138,7 @@ static void nfs41_free_stateid_release(void *calldata)
 	struct nfs_free_stateid_data *data = calldata;
 	struct nfs_client *clp = data->server->nfs_client;
 
+	nfs_sb_deactive(data->server->super);
 	nfs_put_client(clp);
 	kfree(calldata);
 }
@@ -10179,6 +10180,10 @@ static int nfs41_free_stateid(struct nfs_server *server,
 
 	if (!refcount_inc_not_zero(&clp->cl_count))
 		return -EIO;
+	if (!nfs_sb_active(server->super)) {
+		nfs_put_client(clp);
+		return -EIO;
+	}
 
 	nfs4_state_protect(server->nfs_client, NFS_SP4_MACH_CRED_STATEID,
 		&task_setup.rpc_client, &msg);
-- 
2.53.0



