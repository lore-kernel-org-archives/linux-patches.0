Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD3D15FD04;
	Mon, 27 May 2024 19:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838604; cv=none; b=LJ/WZlYyaZXKeKiY9fd/eMad2MDzPDvjmPjUGKDAJt7Xsw9f59fTeddAbW4Lpv1J5r9qw1SoZ9A4W/E0a809yU6gzRNaYi+WYqkrziKoI2dIoS9UjthJl645ODnlLbXjv9xkaRGy/8YeGCTO1vjCSwBBB1du6tWF8PgWnSnRBD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838604; c=relaxed/simple;
	bh=1l0+uAZ6wMKFv0l+0ItBvsrV0RbIVOKxywX6/YXGXqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlaLGrrDLzD+F1swE9V5QYB8cUPBv17DgxSxMHu0CGtQ0+hkuapaTVGVfmGHgwpzYFGCswBADdtmxw5fsG2Ifu+BbErora8HeK2pBygX6CqoLq/UBkTU+QvU11nKVkex2Wgo60elKqFMcw+3cMTqmxgaiKHTJnbNKMrMXWocvfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3HdWt06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3HdWt06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C05C2BBFC;
	Mon, 27 May 2024 19:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838604;
	bh=1l0+uAZ6wMKFv0l+0ItBvsrV0RbIVOKxywX6/YXGXqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3HdWt06WaXAcZrsfisvaSBzQ62jqPVoomctvUhkBYxFgDM6pLWgcVzeLYFP2y6GF
	 BaCAPkFyxQ0p+f6hiro0eavfvmV/GmTSudAy06E1XTk1hWLrwyH/Ojx742NXaWu0d3
	 J0u664XPCGQWDyTUwbEgk1/lwULpZmi8Z4mICl5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 457/493] nfsd: dont create nfsv4recoverydir in nfsdfs when not used.
Date: Mon, 27 May 2024 20:57:39 +0200
Message-ID: <20240527185645.151574903@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 0770249b90f9d9f69714b76adc36cf6c895bc1f9 ]

When CONFIG_NFSD_LEGACY_CLIENT_TRACKING is not set, the virtual file
  /proc/fs/nfsd/nfsv4recoverydir
is created but responds EINVAL to any access.
This is not useful, is somewhat surprising, and it causes ltp to
complain.

The only known user of this file is in nfs-utils, which handles
non-existence and read-failure equally well.  So there is nothing to
gain from leaving the file present but inaccessible.

So this patch removes the file when its content is not available - i.e.
when that config option is not selected.

Also remove the #ifdef which hides some of the enum values when
CONFIG_NFSD_V$ not selection.  simple_fill_super() quietly ignores array
entries that are not present, so having slots in the array that don't
get used is perfectly acceptable.  So there is no value in this #ifdef.

Reported-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Fixes: 74fd48739d04 ("nfsd: new Kconfig option for legacy client tracking")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index ea3c8114245c2..d8f54eb7455e3 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -48,12 +48,10 @@ enum {
 	NFSD_MaxBlkSize,
 	NFSD_MaxConnections,
 	NFSD_Filecache,
-#ifdef CONFIG_NFSD_V4
 	NFSD_Leasetime,
 	NFSD_Gracetime,
 	NFSD_RecoveryDir,
 	NFSD_V4EndGrace,
-#endif
 	NFSD_MaxReserved
 };
 
@@ -1359,7 +1357,9 @@ static int nfsd_fill_super(struct super_block *sb, struct fs_context *fc)
 #ifdef CONFIG_NFSD_V4
 		[NFSD_Leasetime] = {"nfsv4leasetime", &transaction_ops, S_IWUSR|S_IRUSR},
 		[NFSD_Gracetime] = {"nfsv4gracetime", &transaction_ops, S_IWUSR|S_IRUSR},
+#ifdef CONFIG_NFSD_LEGACY_CLIENT_TRACKING
 		[NFSD_RecoveryDir] = {"nfsv4recoverydir", &transaction_ops, S_IWUSR|S_IRUSR},
+#endif
 		[NFSD_V4EndGrace] = {"v4_end_grace", &transaction_ops, S_IWUSR|S_IRUGO},
 #endif
 		/* last one */ {""}
-- 
2.43.0



