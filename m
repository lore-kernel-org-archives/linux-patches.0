Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A508629F6;
	Tue, 23 Jan 2024 00:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971182; cv=none; b=gUZ8dnUJk3hZ6rIJ5gEOxO45u/Eu1mfl5VTTvlO23bkFyogWv7ivvKKj+gfEjfOoOx20Kkm1QQpeBgMo5OKosXiVCNb5ZSC+z/dK6sjtLSJQ3H/a1caizqCa3qU1gYcMUPE76QHGUUJPFHccBad23Gw6el0MCYMjKkEZbOPciQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971182; c=relaxed/simple;
	bh=XgvkJb5T1bMj7e8Qnwg7+jkLvFIWJb51e8cWkdV5MXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXszJ+5JmvS4Fu+ZHi6pfUfiKxxTJFUQEWuTk3CFGiKC2VxXAUizXGIhPtR7JWnIksjOHhCpxWi7jkjbN6k6Si1DDXu1TybV8MjER9n1lviC70M4kNu7KLKO1J3oP+aNIuIDwuqYZHXvvvZaLVBdIKJMJxPhr9hvuSl6vGRHntM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atjOCxc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atjOCxc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069ADC43390;
	Tue, 23 Jan 2024 00:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971182;
	bh=XgvkJb5T1bMj7e8Qnwg7+jkLvFIWJb51e8cWkdV5MXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atjOCxc8bX410Riv79UQFcK6KX64FIduSBOGrRWkWmcJjOPadYd/DlTxXdnQnSN7x
	 ngr/fQ+6122D16de/SD/ZyjE5xRVFJdIm5vNhfkz/YahfNZkmHFBxXFr1R118TYN/A
	 1EEODZhG+0urAsE+OcM2/yp0B/Ll5S+SSpEIS16g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/286] blocklayoutdriver: Fix reference leak of pnfs_device_node
Date: Mon, 22 Jan 2024 15:56:52 -0800
Message-ID: <20240122235736.181276149@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 08108b6d2fa1..73000aa2d220 100644
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



