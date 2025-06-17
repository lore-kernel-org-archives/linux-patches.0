Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80751235067;
	Tue, 17 Jun 2025 16:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178643; cv=none; b=SXu1o4Zwgcj8p7PblFQ6PLO4geZFnCqw0cpyw7fmCeke7uAZGBjblfmRRW1McBH9wHQT0jxezi+QDwYS6Vd7sc3a+vqHXqQny6ft+5zawU+9Lfs+VMrTk0NwhWVLxxHRAIWJ5BmcaQXNYMvD10URb+PVqEmpeZP0SD4DO0Aaf0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178643; c=relaxed/simple;
	bh=3psxKwiW0unjyPD8dgyhoaofI18okE6I97PzaKBriu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtDl7wVGqsDEU4T2noXs1uq3a8344zWvxGMXs5loPRFGA3OSj+9WLgPuScPv/UeksmREEiRCFrV5cri1qK/GrlclUHjfL39S3X5+7jrOqZsQYhE8Des+jpSZqMKiRSZqeF76vnDk2x1nxBeY1MxlFN3al9Zz/B2mDNVpguUyUk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmssvG+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmssvG+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E9AC4CEE3;
	Tue, 17 Jun 2025 16:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178643;
	bh=3psxKwiW0unjyPD8dgyhoaofI18okE6I97PzaKBriu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmssvG+94a5/K74Nu4yvPKwtP/8Fd2V36seIRUKjY8WptT/vPwmf01whSbiUSnmpX
	 qXa9Ib9KZA+c4656+sHIw700ag80ZddeIVCIWHrotUbXPYI0q9mfAaJ6Z5FzqYNV4S
	 lDeR9XKnVWhMKNhZD1M/Tvlj/Td4lhj7zJi3TCjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 480/780] nfs_localio: duplicate nfs_close_local_fh()
Date: Tue, 17 Jun 2025 17:23:08 +0200
Message-ID: <20250617152511.038267803@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

[ Upstream commit 74fc55ab2a6a0c71628fcf3b9783aae7119b5199 ]

nfs_close_local_fh() is called from two different places for quite
different use case.

It is called from nfs_uuid_put() when the nfs_uuid is being detached -
possibly because the nfs server is not longer serving that filesystem.
In this case there will always be an nfs_uuid and so rcu_read_lock() is
not needed.

It is also called when the nfs_file_localio is no longer needed.  In
this case there may not be an active nfs_uuid.

These two can race, and handling the race properly while avoiding
excessive locking will require different handling on each side.

This patch prepares the way by opencoding nfs_close_local_fh() into
nfs_uuid_put(), then simplifying the code there as befits the context.

Fixes: 86e00412254a ("nfs: cache all open LOCALIO nfsd_file(s) in client")
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs_common/nfslocalio.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index 503f85f64b760..49c59f0c78c62 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -171,7 +171,26 @@ static bool nfs_uuid_put(nfs_uuid_t *nfs_uuid)
 
 	/* Walk list of files and ensure their last references dropped */
 	list_for_each_entry_safe(nfl, tmp, &local_files, list) {
-		nfs_close_local_fh(nfl);
+		struct nfsd_file *ro_nf;
+		struct nfsd_file *rw_nf;
+
+		ro_nf = unrcu_pointer(xchg(&nfl->ro_file, NULL));
+		rw_nf = unrcu_pointer(xchg(&nfl->rw_file, NULL));
+
+		spin_lock(&nfs_uuid->lock);
+		/* Remove nfl from nfs_uuid->files list */
+		list_del_init(&nfl->list);
+		spin_unlock(&nfs_uuid->lock);
+		/* Now we can allow racing nfs_close_local_fh() to
+		 * skip the locking.
+		 */
+		RCU_INIT_POINTER(nfl->nfs_uuid, NULL);
+
+		if (ro_nf)
+			nfs_to_nfsd_file_put_local(ro_nf);
+		if (rw_nf)
+			nfs_to_nfsd_file_put_local(rw_nf);
+
 		cond_resched();
 	}
 
-- 
2.39.5



