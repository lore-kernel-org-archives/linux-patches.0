Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B739A12A17F;
	Tue, 23 Jan 2024 00:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968878; cv=none; b=LwPmDS2TIIOwSo9BBboE1afJImgYNnZLq3aUYh+Jq5cbfdc+My4EvizExhgBJA1QUvaXxewijgn4SONvWxZnOYnTRttbgfW4lUdAM7ThnbkOOLH7j/DtjXMBUyqR4dA7foXcmGdItmXEFFs1FcGdAmMp7H0pslIIPAh4IyJKO94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968878; c=relaxed/simple;
	bh=5Bw8ktFYAu4aqzjwK+y/o6iYuSma9lPmKIZkoIR0mt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ0e7wMyaOYXYM5sPbbas8eqbG5FHthMPspkekC4vosG7kkHWXQrVFV189wjDGOO2RM9/hg/SxOJQUoZ0MxZKlcZyfXtBUchiOXKg5KyF3nFilOANCy33DSwWSH0syAbInAwbGQcQhOwQTqaugR5olvQh02ajEI8Q+xZm3E8bkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlx8KcUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlx8KcUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74095C43394;
	Tue, 23 Jan 2024 00:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968878;
	bh=5Bw8ktFYAu4aqzjwK+y/o6iYuSma9lPmKIZkoIR0mt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlx8KcUJBMV8KYwA7B4ObcJAojrmzXkyT5YcKoXuD+nfoIwpVXn+9doxg3gJPJt/k
	 IDL4DWynzZi1AcEukQUROEdWqnUL2zOGi+N3iv1OpGUckad50GH+dBEu/+B5QH2YdQ
	 tbu/IYZu/MFcA6q1tRVmtWDPKBgV0JfzAI5P7JF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/194] blocklayoutdriver: Fix reference leak of pnfs_device_node
Date: Mon, 22 Jan 2024 15:56:48 -0800
Message-ID: <20240122235722.579762418@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 690221747b47..9f10b90debec 100644
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



