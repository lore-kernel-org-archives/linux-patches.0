Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B2915FA85;
	Mon, 27 May 2024 19:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837311; cv=none; b=fdBXGFFTwFXZmPJ1AKwT1h7cjkIz1FPOxOn59v/C6AmZruxFnPO0/K0qvA6tjrtM+EcroRc4f7e/WcSZYuAGO3J/Bk0mgdzpFsDvOZvqMneCv2L1fXluTzXklXRplc1PeO92X+l/5Ivdgl5xkiay84c/olct2hnOASGIpbDFghw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837311; c=relaxed/simple;
	bh=Y9qtySFcvXSqSQIkoSF27O722MRDCupfLZGsLIvDvWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgutkjl1TGPEKWjzCeW/jjB/H8MTwoLgz1ilve6A5s2zf1l9Djnjc5CaCGXYJootA/CKA+SCXnroLyU+gVPcYdET3Sv1/0F46OTKAcN7YAU4fTyetqP/cJiGolNjMk7Mu3C3n/1J/VwUgsZA5vmDw9Nk1rfscmRCKZ8S4WmhN88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycP7PumX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycP7PumX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF61C2BBFC;
	Mon, 27 May 2024 19:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837311;
	bh=Y9qtySFcvXSqSQIkoSF27O722MRDCupfLZGsLIvDvWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycP7PumXOArxnkyDX/NOKMSkcyel8lZhH1D0sJvG40SsJfmzZioa+no5SV/ztr+ks
	 VPlCZzB7IjEIko8nJPHGTufVm8VKCLG4ucK8f175SF8qLIjLWhq1EiaCFcMke9IlJj
	 SqMlMkDAnR/y0UDVAjO8TxaWO7Y+VQjV7eO0e+zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 391/427] nfsd: dont create nfsv4recoverydir in nfsdfs when not used.
Date: Mon, 27 May 2024 20:57:18 +0200
Message-ID: <20240527185634.822742348@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ecd18bffeebc7..4d23bb1d08c0a 100644
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
 
@@ -1360,7 +1358,9 @@ static int nfsd_fill_super(struct super_block *sb, struct fs_context *fc)
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



