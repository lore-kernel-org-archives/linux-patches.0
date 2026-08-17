Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB093D301E;
	Mon, 17 Aug 2026 14:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977549; cv=none; b=Xj8fB+yQvyfF5Js1pEumW+Boy3xZavL78Ho5G6j6uyIrRJVoMSEOs5Hf/sYWWG/a1/UFXUpkc1afuTuWgT8p0p4rRbZPRUbSC6U9aqpX3EranTbxnUCA/3jsBClbOg7dtXLSrVL53s2K4vppW3Ir7I9rdcPvmJtlzPWxwi4XH5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977549; c=relaxed/simple;
	bh=9i4Q2vousXAca+AvAogl1Nd0J6NvOT2XT9+h70TFlz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0d4rX39xUuyDcnjvrraF331HsxCVBvAx8X7b+jwUf/1IANUvqx2bSsnGQ959Ace663SDYUTz9EkShYTaTzcJg0SCrKWLUPKQhaLH6e5yiTylRT6NUCxWgnWI+XFTaTuB4geOVIkiIwzQbxNM4zpOzg/4sN4rxHsVOSCUiMaCwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y98RKeKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y98RKeKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772B81F000E9;
	Mon, 17 Aug 2026 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977548;
	bh=DRkGtaWjZP1k+y1XNA8sfXl04sfZDxSM1g04asdw1uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y98RKeKKo7Ei4MpFFdwoEs4XtcsW+Rn7olklUy1gCZQV7MHeHz2fovqt1F7ntHTrM
	 XjRGjDWMyp8hyCsSDXZNBAmmDgv8nxDYcY9atbD0Fden2RCdFyGl5/2YixDrR1muNX
	 tEHkGFjec9B3JmKeYFvaVHP/pcwoi0N8B3aFRVJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/456] nfs4: take a reference on the nfs_client when running FREE_STATEID
Date: Mon, 17 Aug 2026 15:32:38 +0200
Message-ID: <20260817132553.881202445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 576acc259146af848cec0940f573f7125a116b9f ]

During umount, the session slot tables are freed.  If there are
outstanding FREE_STATEID tasks, a use-after-free and slab corruption can
occur when rpc_exit_task calls rpc_call_done -> nfs41_sequence_done ->
nfs4_sequence_process/nfs41_sequence_free_slot.

Prevent that from happening by taking a reference on the nfs_client in
nfs41_free_stateid and putting it in nfs41_free_stateid_release.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: cf616096a0f3 ("NFS: Pin the 'struct nfs_server' during a FREE_STATEID call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index cd97312860ce6..41bbc9407680f 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10294,6 +10294,10 @@ static void nfs41_free_stateid_done(struct rpc_task *task, void *calldata)
 
 static void nfs41_free_stateid_release(void *calldata)
 {
+	struct nfs_free_stateid_data *data = calldata;
+	struct nfs_client *clp = data->server->nfs_client;
+
+	nfs_put_client(clp);
 	kfree(calldata);
 }
 
@@ -10330,6 +10334,10 @@ static int nfs41_free_stateid(struct nfs_server *server,
 	};
 	struct nfs_free_stateid_data *data;
 	struct rpc_task *task;
+	struct nfs_client *clp = server->nfs_client;
+
+	if (!refcount_inc_not_zero(&clp->cl_count))
+		return -EIO;
 
 	nfs4_state_protect(server->nfs_client, NFS_SP4_MACH_CRED_STATEID,
 		&task_setup.rpc_client, &msg);
-- 
2.53.0



