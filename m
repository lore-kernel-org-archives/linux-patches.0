Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C454032898F;
	Wed, 17 Sep 2025 12:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113413; cv=none; b=J3BkzA7K2nae6yK/s8gKAO3VLhx+kfcNLdqLbdT6os8bRrXAPAdW04i+aHb+L8v6unQk6XIlWEeZTib1cMRzSVeiUIawiy4Tw9EAKRCBffq2wGb+b26DYYu+Ab6ZT0WIO4NGZqzcCpri4EloqD7e773rcsdLbsJK7Ji73LbHcRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113413; c=relaxed/simple;
	bh=UjV05xDIggOty3XJwQjSqAQTCFFrJQupU1YdpzDoqIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIThk0tliD/9/OlFLV3KyFzdgJay7UTqTTfZM+MgbmXxRWMaBgqmBycaKcuzvOZIpPeaOu/QWEwpUw/ch1MdKb6MbvwhdiG6NyMl/K34Gmea4c0b+OFw2ZjV0NW2TnZw/yrp7IWeZGJfPnjBhfapsvyCD07Oe0Qk4SoJvmFOjJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IUXqya4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IUXqya4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC67C4CEF5;
	Wed, 17 Sep 2025 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113413;
	bh=UjV05xDIggOty3XJwQjSqAQTCFFrJQupU1YdpzDoqIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IUXqya4asVIbnYCmD1BJ8GVRFEncIR/i98YwSRz3VXxv+/Xus9T2zDNvFCacIz//
	 lghUIc4Wb6mASim4AE9ShxF8QCNO3Ah2/KfMhDvZqFn1YNC3grRrP+nStyMPvDSUiI
	 zcFMyUg0q8PVYjklX4UJwoeroB/0E0WYTt1W/YJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/140] NFSv4.2: Serialise O_DIRECT i/o and fallocate()
Date: Wed, 17 Sep 2025 14:33:26 +0200
Message-ID: <20250917123345.143931600@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b93128f29733af5d427a335978a19884c2c230e2 ]

Ensure that all O_DIRECT reads and writes complete before calling
fallocate so that we don't race w.r.t. attribute updates.

Fixes: 99f237832243 ("NFSv4.2: Always flush out writes in nfs42_proc_fallocate()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 9f0d69e652644..66fe885fc19a1 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -112,6 +112,7 @@ static int nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 	exception.inode = inode;
 	exception.state = lock->open_context->state;
 
+	nfs_file_block_o_direct(NFS_I(inode));
 	err = nfs_sync_inode(inode);
 	if (err)
 		goto out;
-- 
2.51.0



