Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C348013B7A3;
	Wed, 17 Sep 2025 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112638; cv=none; b=nOLpR1Yt+Te0qzumESWpzr4YpKPVKTliECMLfqE0lfc1l6czK14t+tceRZkQQ6jndXFHhdz5kTNFqU5qdxSrMMXQrlJ3TGvOc1ZUwqKd0AdZuS+OVkzCK4q7TY0PbziwhP5airYYAWDsvs0aW7Z/CRW4uiAVnS51k6r+DBV43p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112638; c=relaxed/simple;
	bh=kgN+UUpiv6qOo5ZX4E7thAI29fMe01y/HUkkz3Ftszw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIM+h+EH2+nSc/ymZeJAgyN5D2tQk8yJwt/UK0T76ybNsWGNFOzen9SzXK0BBLSKbHZwEQskGbGs1EmgXbFuVgS+V2MtACX5k5h4/SzB2lPB/t1RvgXZtYNtKvYgJPN9s0Nrh69x5ZBq2gTgeTX8rAFwsq/bAWJubY4Y7CBjtjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGD4+DEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGD4+DEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F42C4CEF0;
	Wed, 17 Sep 2025 12:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112638;
	bh=kgN+UUpiv6qOo5ZX4E7thAI29fMe01y/HUkkz3Ftszw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGD4+DEhcc8YYZsbGOVfz+NherFNTyawK71KWT9oVlOFTM2II3mageggiKg1bwCfZ
	 n5gj1TnvygmrhhT8niscnxRQ66xZzP4Gyti0BiM49/spX8/iTBd38cOfVH8AnYUbOr
	 lSS0/J1HRGwyIkaT8YsVlQ0w/PZEsvy1pEsnJbHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 031/189] NFSv4.2: Serialise O_DIRECT i/o and clone range
Date: Wed, 17 Sep 2025 14:32:21 +0200
Message-ID: <20250917123352.614234397@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c80ebeba1198eac8811ab0dba36ecc13d51e4438 ]

Ensure that all O_DIRECT reads and writes complete before cloning a file
range, so that both the source and destination are up to date.

Fixes: a5864c999de6 ("NFS: Do not serialise O_DIRECT reads and writes")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 5e9d66f3466c8..1fa69a0b33ab1 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -291,9 +291,11 @@ static loff_t nfs42_remap_file_range(struct file *src_file, loff_t src_off,
 
 	/* flush all pending writes on both src and dst so that server
 	 * has the latest data */
+	nfs_file_block_o_direct(NFS_I(src_inode));
 	ret = nfs_sync_inode(src_inode);
 	if (ret)
 		goto out_unlock;
+	nfs_file_block_o_direct(NFS_I(dst_inode));
 	ret = nfs_sync_inode(dst_inode);
 	if (ret)
 		goto out_unlock;
-- 
2.51.0



