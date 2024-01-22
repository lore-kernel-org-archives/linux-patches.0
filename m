Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EE114A4CF;
	Tue, 23 Jan 2024 00:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969222; cv=none; b=ddaSYxbDkjBHY0nxWbO3ShF3N1acWxzfnG141DCtNE89WO3URnSNSUdQ74wcEraPLdVRDdSor6QVEC27eNR1iao0cgDD/4WRugmaGlQeSeMKQZdxwriHKWY+Ew9dxJCyzlMdbFjr49TbxoMtrgqpc3lmWyVN9vy1o01L/TbJvM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969222; c=relaxed/simple;
	bh=NA9qtJep9G/UGFeXy5k+Y7H6/HbSUaoXszox+u4iQKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mi3I631K0RkTi67UjbdKxxjqwmuuLekpF4Y6FXnXdvtPNmd3CSrxj7lGsKV6R0ZtY5+HLNyyhSyz/NoCQyYI3swqOf4bfZtnuMEbJX1/snJ24l+DLOd2mk28M0DsnpuGhCMz1/tq7nB987dJw8/jqOtZJB8TFNQJu9E3Q56n+8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xisql163; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xisql163"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D74C433C7;
	Tue, 23 Jan 2024 00:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969222;
	bh=NA9qtJep9G/UGFeXy5k+Y7H6/HbSUaoXszox+u4iQKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xisql163vlNutTw++5P7+O170sfN+56x1/N7sv7l35jVZwOq9p/8qrI5/BJ4UD3dm
	 axsXpEQYifmhM0Q6CfNmrKjNK/rYY2zGDsb964Q1+u/Y/qiYz2g7dvGJqeSPvELB6/
	 Tf5HMJFtDLKBGHYmVin7FPEgBd/LRthHVHXfudZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 085/641] blocklayoutdriver: Fix reference leak of pnfs_device_node
Date: Mon, 22 Jan 2024 15:49:49 -0800
Message-ID: <20240122235820.689904742@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 943aeea1eb16..1d1d7abc3205 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -580,6 +580,8 @@ bl_find_get_deviceid(struct nfs_server *server,
 		nfs4_delete_deviceid(node->ld, node->nfs_client, id);
 		goto retry;
 	}
+
+	nfs4_put_deviceid_node(node);
 	return ERR_PTR(-ENODEV);
 }
 
-- 
2.43.0



