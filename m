Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1A91C68C;
	Sun,  1 Sep 2024 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208376; cv=none; b=olIOi0OI6S228YYXjFdilEIFxMOIR1P88+VvkxnG2zemHhahoYlmx+z89uHQ16flsgrGhbuGBL4ZIUFH1lklssZQHF3qHswuFsgTUQBYCZPH/GNWQLtPnZ1s5UCFDjegOH0Zs283tVGFU/l742XLCdurkxxX2J11vqqh1AWGDFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208376; c=relaxed/simple;
	bh=DvA/GBr+DBJaPabzwgNrnm2avMX8KWayy4Nr4MCLfds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXhtEa69uW+w/0A83IgCo91iVVY+G8/cXHGtFxg/GnZXg+w3baFoVod6rmAgi37Ng6ZTaZ1Pc3gMHPfjO1b7t1iN+zJAxj/CW/IB49MNXr7Dnqj8gMaXRVpTYtcITBQt146+I33Ya1Ry3NvpHSCO2nVF/ysIbdZkbn38jp553D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ay6zPs1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ay6zPs1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75A5C4CEC3;
	Sun,  1 Sep 2024 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208376;
	bh=DvA/GBr+DBJaPabzwgNrnm2avMX8KWayy4Nr4MCLfds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ay6zPs1YvYuf675IS0TZrtRVu8j7K/6GPPUD/w+oa+mQYd1nhEIBoaU1oKE8BKhiF
	 /ea9F1GuTKXrm8AlLYXPCH9U7Jod04xJE+ZPpSJq/KOEOXMH8N/8DmzpxytoFyFqUY
	 YlwfpdbVXD6IxqbGKSaftfHiaIGsv6++vAU6o0u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 064/149] nfsd: prevent panic for nfsv4.0 closed files in nfs4_show_open
Date: Sun,  1 Sep 2024 18:16:15 +0200
Message-ID: <20240901160819.874025648@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit a204501e1743d695ca2930ed25a2be9f8ced96d3 ]

Prior to commit 3f29cc82a84c ("nfsd: split sc_status out of
sc_type") states_show() relied on sc_type field to be of valid
type before calling into a subfunction to show content of a
particular stateid. From that commit, we split the validity of
the stateid into sc_status and no longer changed sc_type to 0
while unhashing the stateid. This resulted in kernel oopsing
for nfsv4.0 opens that stay around and in nfs4_show_open()
would derefence sc_file which was NULL.

Instead, for closed open stateids forgo displaying information
that relies of having a valid sc_file.

To reproduce: mount the server with 4.0, read and close
a file and then on the server cat /proc/fs/nfsd/clients/2/states

[  513.590804] Call trace:
[  513.590925]  _raw_spin_lock+0xcc/0x160
[  513.591119]  nfs4_show_open+0x78/0x2c0 [nfsd]
[  513.591412]  states_show+0x44c/0x488 [nfsd]
[  513.591681]  seq_read_iter+0x5d8/0x760
[  513.591896]  seq_read+0x188/0x208
[  513.592075]  vfs_read+0x148/0x470
[  513.592241]  ksys_read+0xcc/0x178

Fixes: 3f29cc82a84c ("nfsd: split sc_status out of sc_type")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a20c2c9d7d457..dafff707e23a4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2789,15 +2789,18 @@ static int nfs4_show_open(struct seq_file *s, struct nfs4_stid *st)
 		deny & NFS4_SHARE_ACCESS_READ ? "r" : "-",
 		deny & NFS4_SHARE_ACCESS_WRITE ? "w" : "-");
 
-	spin_lock(&nf->fi_lock);
-	file = find_any_file_locked(nf);
-	if (file) {
-		nfs4_show_superblock(s, file);
-		seq_puts(s, ", ");
-		nfs4_show_fname(s, file);
-		seq_puts(s, ", ");
-	}
-	spin_unlock(&nf->fi_lock);
+	if (nf) {
+		spin_lock(&nf->fi_lock);
+		file = find_any_file_locked(nf);
+		if (file) {
+			nfs4_show_superblock(s, file);
+			seq_puts(s, ", ");
+			nfs4_show_fname(s, file);
+			seq_puts(s, ", ");
+		}
+		spin_unlock(&nf->fi_lock);
+	} else
+		seq_puts(s, "closed, ");
 	nfs4_show_owner(s, oo);
 	if (st->sc_status & SC_STATUS_ADMIN_REVOKED)
 		seq_puts(s, ", admin-revoked");
-- 
2.43.0



