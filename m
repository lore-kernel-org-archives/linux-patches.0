Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636F35680;
	Tue, 23 Jan 2024 00:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968406; cv=none; b=dc/D3syODSwq7ZWuMvsAjNQ4dNRZQVifJ/PyORUCAb+pRa3ypm471rR06NbFcJYFPEnSQ/nsuAAJSBXXQ0Xw9w5cybQmR0LPJPXxnjyjPTrzhYX/9cDujMST+dkSQdUYdDKYCzIc15Nx6thxGmcY1SOy2Iwwi7J7Of76X2bnfh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968406; c=relaxed/simple;
	bh=AEesORLJcKV7eqKv1ud6fgddnOKMA68Ks7/qICYjV4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huyhaWuKNmSJUZsnbVjjlfZssKEuN7dNqxB6WappCggC9LVI5NyUeaeIvC7jhor9RYJuzI5rm9EfwontbDT30sqkGkNt4sO4EoghJg+pg+9OrLN23Yfx+KP84k/tFiijnOc1ZcV9arY7ZjEbPUYB4ezVvNkeilLuBWp5WrrhDR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jw2jV44U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jw2jV44U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E1EC433F1;
	Tue, 23 Jan 2024 00:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968405;
	bh=AEesORLJcKV7eqKv1ud6fgddnOKMA68Ks7/qICYjV4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jw2jV44UX6OgqpDMnTIw16WxgJL8M0IJbRICrFrFTtfJupEmb/Z47z927C/svgy/K
	 db1niWrr8Tf/5m+aVHD3cMka3WX/jCFpTXkR8YwYpYVda9izr68p4oy0s3opJs7JF7
	 GXFhC6Oo/a3nKG0cVJQs1lDWrpxAn7kFEi6X/Z64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/148] blocklayoutdriver: Fix reference leak of pnfs_device_node
Date: Mon, 22 Jan 2024 15:56:58 -0800
Message-ID: <20240122235714.914715527@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 1530827b90025cdf80c9b0d07a166d045a0a7b81 ]

The error path for blocklayout's device lookup is missing a reference drop
for the case where a lookup finds the device, but the device is marked with
NFS_DEVICEID_UNAVAILABLE.

Fixes: b3dce6a2f060 ("pnfs/blocklayout: handle transient devices")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/blocklayout.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 06cb0c1d9aee..a2bca78b80ab 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -604,6 +604,8 @@ bl_find_get_deviceid(struct nfs_server *server,
 		nfs4_delete_deviceid(node->ld, node->nfs_client, id);
 		goto retry;
 	}
+
+	nfs4_put_deviceid_node(node);
 	return ERR_PTR(-ENODEV);
 }
 
-- 
2.43.0



