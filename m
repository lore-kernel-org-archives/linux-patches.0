Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE761974E8;
	Thu,  6 Jun 2024 14:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683540; cv=none; b=iJ0MS1X3cvTM5mxzICyEz+XN43Qx26Yt3I51Vh4R9kfsPAw2LNnWyPpT/znfU/Xeja5fcxVlHVpWp8xnL4cRa21Me5b0AnypB83r6RCKEP3ZP5jKDIwgbBn6KY64/qOVH/E8hZjzHUQf83rOCuxYBOgTLZK1PuRBHF05XIpvgjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683540; c=relaxed/simple;
	bh=35IDMXWb6LrxzH9KKoxGDqeL0S5Ayysu1kVbOJIX1bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsW4NdzDFaWXaZ+9KRomteg4YNh2Sam0kfN6REBU8E14YCeF+y/vvFEcMRpJRLeExtyPDYaaQp276C5wqP0lEZph+RAdpod3DnFG9jaKQh7MGgLIx7OHxZQZBt8PKJzbehCVg3h3cTH/UVYCg277l5anltw6VPjfMYl8JX65GHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/DTrHyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/DTrHyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EAFC2BD10;
	Thu,  6 Jun 2024 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683540;
	bh=35IDMXWb6LrxzH9KKoxGDqeL0S5Ayysu1kVbOJIX1bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/DTrHyYCFMUD1IryRKKV6K6SzxQA1jGjlXnDOqXRRWvobhzTRPvRNnXOXvIriUWW
	 1iGYZ2iNcGYf2DM1Xi4Vts/JxGeyVNYnAm2AFG6BkKg77wzC7a4fttbT//9iMY/0yg
	 XQoE59vSd2jIHIKV/Otup4UU19lS+YiV0H37N7MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 408/473] nfs: keep server info for remounts
Date: Thu,  6 Jun 2024 16:05:37 +0200
Message-ID: <20240606131713.291040854@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit b322bf9e983addedff0894c55e92d58f4d16d92a ]

With newer kernels that use fs_context for nfs mounts, remounts fail with
-EINVAL.

$ mount -t nfs -o nolock 10.0.0.1:/tmp/test /mnt/test/
$ mount -t nfs -o remount /mnt/test/
mount: mounting 10.0.0.1:/tmp/test on /mnt/test failed: Invalid argument

For remounts, the nfs server address and port are populated by
nfs_init_fs_context and later overwritten with 0x00 bytes by
nfs23_parse_monolithic. The remount then fails as the server address is
invalid.

Fix this by not overwriting nfs server info in nfs23_parse_monolithic if
we're doing a remount.

Fixes: f2aedb713c28 ("NFS: Add fs_context support.")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fs_context.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 9bcd53d5c7d46..9a5b735e74f9e 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -1047,9 +1047,12 @@ static int nfs23_parse_monolithic(struct fs_context *fc,
 		ctx->acdirmax	= data->acdirmax;
 		ctx->need_mount	= false;
 
-		memcpy(sap, &data->addr, sizeof(data->addr));
-		ctx->nfs_server.addrlen = sizeof(data->addr);
-		ctx->nfs_server.port = ntohs(data->addr.sin_port);
+		if (!is_remount_fc(fc)) {
+			memcpy(sap, &data->addr, sizeof(data->addr));
+			ctx->nfs_server.addrlen = sizeof(data->addr);
+			ctx->nfs_server.port = ntohs(data->addr.sin_port);
+		}
+
 		if (sap->ss_family != AF_INET ||
 		    !nfs_verify_server_address(sap))
 			goto out_no_address;
-- 
2.43.0



