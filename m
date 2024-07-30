Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0419E184549;
	Tue, 30 Jul 2024 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358591; cv=none; b=HV0fVzy9Ad79i/8RoFxqtR6+o7F4tXluCcwKoHn2SMjZH9B++n3wT/stJt9awals3tqLi3IqkxighjoZx3ZrhANuEZMKliaANUMZBWpfgZ12M240vXvYtdS3f5CZliB02O6Yr3Ivr1ZSMofdjbHf1XVLvLWOt8SrBBjcnEvkDF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358591; c=relaxed/simple;
	bh=GmpZ9SRJ7zjyzhyxvXxoB0xp7VlH0hjUYWVEW24v9tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8B+v7F+sPu5hMGPPrZ/E00dSDTQqQHqF45rK7UWGnk5G+BIvng7o7wKm9IgyOvymvhH3beSxwiK2Oj2endSNA8DCGq9k7HaHgFTbtNNS8fOFL8k+gySaxWbwWzth3NwAS9DLdzBHpUu/WPI3Zk4ZPr2AuigUNooCSeSRktyKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00DnLxf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00DnLxf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62386C4AF0C;
	Tue, 30 Jul 2024 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358590;
	bh=GmpZ9SRJ7zjyzhyxvXxoB0xp7VlH0hjUYWVEW24v9tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00DnLxf6jPqiNdFBxDE7qCuA1MA+dLJFEYCfrRuvQTHRX+qmcm4aWWb6eLW35onpI
	 Fk/AYbPe1b274fcz1n6Gjbvvz2Evig3l7ErK6ghuXxcZ+csJLceTFkG+hkpLl3s3iI
	 658YA2f61jJhMd/d7S0kUxQeKbfoYCHSMzhbnaHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 370/809] NFSv4.1 another fix for EXCHGID4_FLAG_USE_PNFS_DS for DS server
Date: Tue, 30 Jul 2024 17:44:06 +0200
Message-ID: <20240730151739.273850150@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 4840c00003a2275668a13b82c9f5b1aed80183aa ]

Previously in order to mark the communication with the DS server,
we tried to use NFS_CS_DS in cl_flags. However, this flag would
only be saved for the DS server and in case where DS equals MDS,
the client would not find a matching nfs_client in nfs_match_client
that represents the MDS (but is also a DS).

Instead, don't rely on the NFS_CS_DS but instead use NFS_CS_PNFS.

Fixes: 379e4adfddd6 ("NFSv4.1: fixup use EXCHGID4_FLAG_USE_PNFS_DS for DS server")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4client.c | 6 ++----
 fs/nfs/nfs4proc.c   | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 84573df5cf5ae..83378f69b35ea 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -231,9 +231,8 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 		__set_bit(NFS_CS_INFINITE_SLOTS, &clp->cl_flags);
 	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
 	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
-
-	if (test_bit(NFS_CS_DS, &cl_init->init_flags))
-		__set_bit(NFS_CS_DS, &clp->cl_flags);
+	if (test_bit(NFS_CS_PNFS, &cl_init->init_flags))
+		__set_bit(NFS_CS_PNFS, &clp->cl_flags);
 	/*
 	 * Set up the connection to the server before we add add to the
 	 * global list.
@@ -1013,7 +1012,6 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
 	if (mds_srv->flags & NFS_MOUNT_NORESVPORT)
 		__set_bit(NFS_CS_NORESVPORT, &cl_init.init_flags);
 
-	__set_bit(NFS_CS_DS, &cl_init.init_flags);
 	__set_bit(NFS_CS_PNFS, &cl_init.init_flags);
 	cl_init.max_connect = NFS_MAX_TRANSPORTS;
 	/*
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a691fa10b3e95..bff9d6600741e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8840,7 +8840,7 @@ nfs4_run_exchange_id(struct nfs_client *clp, const struct cred *cred,
 #ifdef CONFIG_NFS_V4_1_MIGRATION
 	calldata->args.flags |= EXCHGID4_FLAG_SUPP_MOVED_MIGR;
 #endif
-	if (test_bit(NFS_CS_DS, &clp->cl_flags))
+	if (test_bit(NFS_CS_PNFS, &clp->cl_flags))
 		calldata->args.flags |= EXCHGID4_FLAG_USE_PNFS_DS;
 	msg.rpc_argp = &calldata->args;
 	msg.rpc_resp = &calldata->res;
-- 
2.43.0



