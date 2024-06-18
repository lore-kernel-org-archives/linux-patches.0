Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C985573461;
	Tue, 18 Jun 2024 13:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716290; cv=none; b=haGJ1GMUbnxFyhzhA9EVqtUj2D8AzEpqQAky414NHCk5sBrPeTN/cG9+RAeIAnKDNNl4sUkznFNe9O5RkqJhy5iNzWBYs3a2Fjuun8YENkKbKYYtBNiGKsU//wGV3mng0zrBWS7vK5wJJhhdkPcnMdYPF0Cg3UKOt4IKUEzfElk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716290; c=relaxed/simple;
	bh=ETfhoq+tnffcWeNf2B5CUHe3ifQXPdd8qqyyCEJGO38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zqw9SGithTpDtGVlPtqQUJ4gVIPQYIJmslcHw0ypbvjK4vp7eVVDkZLxE+ZlfQJgUSovcuYffCagU63bDM1bZmHQavrfu4uJ+pwHDrv2szdjGXOz5HmG5Bd9vqz1QKKEP5h6o8j+gQqv1Xj49hrstb62AJ0bUwfflh+TNHZAa/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRZqUXuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRZqUXuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52596C3277B;
	Tue, 18 Jun 2024 13:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716290;
	bh=ETfhoq+tnffcWeNf2B5CUHe3ifQXPdd8qqyyCEJGO38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRZqUXuUdyyCnsMl72qkkiog5r1FFepOaYcUZnnuOmx0ZR5BnI/XRVCHeDrWpV0MG
	 U/oSkqO117wqxniFnu4YBZU2PlmOh2wy5ZyIV8DYVAI9xyjmlDkZcsrRGcHucj2u3I
	 yV7J5ap8tzdFKaanCQrFsQUXxawaAV824B9wkt+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 597/770] NFSD: Fix strncpy() fortify warning
Date: Tue, 18 Jun 2024 14:37:30 +0200
Message-ID: <20240618123430.337676114@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5304877936c0a67e1a01464d113bae4c81eacdb6 ]

In function ‘strncpy’,
    inlined from ‘nfsd4_ssc_setup_dul’ at /home/cel/src/linux/manet/fs/nfsd/nfs4proc.c:1392:3,
    inlined from ‘nfsd4_interssc_connect’ at /home/cel/src/linux/manet/fs/nfsd/nfs4proc.c:1489:11:
/home/cel/src/linux/manet/include/linux/fortify-string.h:52:33: warning: ‘__builtin_strncpy’ specified bound 63 equals destination size [-Wstringop-truncation]
   52 | #define __underlying_strncpy    __builtin_strncpy
      |                                 ^
/home/cel/src/linux/manet/include/linux/fortify-string.h:89:16: note: in expansion of macro ‘__underlying_strncpy’
   89 |         return __underlying_strncpy(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~~

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c      | 2 +-
 include/linux/nfs_ssc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 08c2eaca4f24e..1b49b4e2803c7 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1391,7 +1391,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 		return 0;
 	}
 	if (work) {
-		strncpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr));
+		strlcpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr) - 1);
 		refcount_set(&work->nsui_refcnt, 2);
 		work->nsui_busy = true;
 		list_add_tail(&work->nsui_list, &nn->nfsd_ssc_mount_list);
diff --git a/include/linux/nfs_ssc.h b/include/linux/nfs_ssc.h
index 222ae8883e854..75843c00f326a 100644
--- a/include/linux/nfs_ssc.h
+++ b/include/linux/nfs_ssc.h
@@ -64,7 +64,7 @@ struct nfsd4_ssc_umount_item {
 	refcount_t nsui_refcnt;
 	unsigned long nsui_expire;
 	struct vfsmount *nsui_vfsmount;
-	char nsui_ipaddr[RPC_MAX_ADDRBUFLEN];
+	char nsui_ipaddr[RPC_MAX_ADDRBUFLEN + 1];
 };
 #endif
 
-- 
2.43.0



