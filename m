Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F891D0418;
	Wed,  2 Oct 2024 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876465; cv=none; b=gGfQ80O2xwe1kZCWNIVVkdT/mcYpmmY7loA/4ktoRPz6uW4FpOgDVklI1Zod24MKakNqqOa+ZSx6KpxLzyxYJ4Vi4gEe+NPYVzgpmJnotyqW8CeGWE0UkVZp+XxDJnJqvitg9thXnf/h8cVWSRr7+RhQ9UFuLkMoELpMLvLSQeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876465; c=relaxed/simple;
	bh=WGvIOtpLoepWX2yuohpoTbrMK54dU4mBxT0wIB3qGvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmC5+sW0gznmWIYZMWa539cKhe1IgOTNb2Hsl9mEY7AS73T233L3aaxjynpDOYv/uzojVmShDhumh1cdyBbDIrzIoalE7oeXM19Yqi+0oPl71Ab9Nw6nAavWR/LinjdViM4S/2Jgn7gl2dbNXGoIZnz3IvZyELjNBdKhKNfNCoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjWbD1vc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjWbD1vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB95BC4CECD;
	Wed,  2 Oct 2024 13:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876465;
	bh=WGvIOtpLoepWX2yuohpoTbrMK54dU4mBxT0wIB3qGvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjWbD1vc2tLEds5SQR+EHGahxclTrul9p4f1aKco3te7/vlr8UYvnjI6+SPZq2lDY
	 Pa97jwe4a0PU7b3LGD7WrBzRqA3Bk4hEc/PMOssZZCS1uPByBvpqW0PCUTHuHkToNg
	 c6MoUuUw5SDH9uwYA/y7e543t3QTog743+mJjSqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roi Azarzar <roi.azarzar@vastdata.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 452/695] NFSv4.2: Fix detection of "Proxying of Times" server support
Date: Wed,  2 Oct 2024 14:57:30 +0200
Message-ID: <20241002125840.501210177@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Roi Azarzar <roi.azarzar@vastdata.com>

[ Upstream commit 615e693b14ba22e1332c3bd5a4e038284bbc3e07 ]

According to draft-ietf-nfsv4-delstid-07:
   If a server informs the client via the fattr4_open_arguments
   attribute that it supports
   OPEN_ARGS_SHARE_ACCESS_WANT_DELEG_TIMESTAMPS and it returns a valid
   delegation stateid for an OPEN operation which sets the
   OPEN4_SHARE_ACCESS_WANT_DELEG_TIMESTAMPS flag, then it MUST query the
   client via a CB_GETATTR for the fattr4_time_deleg_access (see
   Section 5.2) attribute and fattr4_time_deleg_modify attribute (see
   Section 5.2).

Thus, we should look that the server supports proxying of times via
OPEN4_SHARE_ACCESS_WANT_DELEG_TIMESTAMPS.

We want to be extra pedantic and continue to check that FATTR4_TIME_DELEG_ACCESS
and FATTR4_TIME_DELEG_MODIFY are set. The server needs to expose both for the
client to correctly detect "Proxying of Times" support.

Signed-off-by: Roi Azarzar <roi.azarzar@vastdata.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Fixes: dcb3c20f7419 ("NFSv4: Add a capability for delegated attributes")
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index b8ffbe52ba15a..cd2fbde2e6d72 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3904,6 +3904,18 @@ static void nfs4_close_context(struct nfs_open_context *ctx, int is_sync)
 #define FATTR4_WORD2_NFS41_MASK (2*FATTR4_WORD2_SUPPATTR_EXCLCREAT - 1UL)
 #define FATTR4_WORD2_NFS42_MASK (2*FATTR4_WORD2_OPEN_ARGUMENTS - 1UL)
 
+#define FATTR4_WORD2_NFS42_TIME_DELEG_MASK \
+	(FATTR4_WORD2_TIME_DELEG_MODIFY|FATTR4_WORD2_TIME_DELEG_ACCESS)
+static bool nfs4_server_delegtime_capable(struct nfs4_server_caps_res *res)
+{
+	u32 share_access_want = res->open_caps.oa_share_access_want[0];
+	u32 attr_bitmask = res->attr_bitmask[2];
+
+	return (share_access_want & NFS4_SHARE_WANT_DELEG_TIMESTAMPS) &&
+	       ((attr_bitmask & FATTR4_WORD2_NFS42_TIME_DELEG_MASK) ==
+					FATTR4_WORD2_NFS42_TIME_DELEG_MASK);
+}
+
 static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle)
 {
 	u32 minorversion = server->nfs_client->cl_minorversion;
@@ -3982,8 +3994,6 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 #endif
 		if (res.attr_bitmask[0] & FATTR4_WORD0_FS_LOCATIONS)
 			server->caps |= NFS_CAP_FS_LOCATIONS;
-		if (res.attr_bitmask[2] & FATTR4_WORD2_TIME_DELEG_MODIFY)
-			server->caps |= NFS_CAP_DELEGTIME;
 		if (!(res.attr_bitmask[0] & FATTR4_WORD0_FILEID))
 			server->fattr_valid &= ~NFS_ATTR_FATTR_FILEID;
 		if (!(res.attr_bitmask[1] & FATTR4_WORD1_MODE))
@@ -4011,6 +4021,8 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 		if (res.open_caps.oa_share_access_want[0] &
 		    NFS4_SHARE_WANT_OPEN_XOR_DELEGATION)
 			server->caps |= NFS_CAP_OPEN_XOR;
+		if (nfs4_server_delegtime_capable(&res))
+			server->caps |= NFS_CAP_DELEGTIME;
 
 		memcpy(server->cache_consistency_bitmask, res.attr_bitmask, sizeof(server->cache_consistency_bitmask));
 		server->cache_consistency_bitmask[0] &= FATTR4_WORD0_CHANGE|FATTR4_WORD0_SIZE;
-- 
2.43.0



