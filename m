Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6465F540;
	Tue, 23 Jan 2024 01:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974419; cv=none; b=uXKVdLd7UZU5VLx2Rp+gtx3OgUIvFdHFlueX0Mjwpxdu1A5xUxr1wddiOLSmn1vmzHegoQgGk6KNDpXr4RS4Fep39jHhWDXotl8lV47BzUaz6+ZhGgTsmIr8p18nHXQSVpbQLK24ZPlUzZqfwDxOUKYVa0oKUF0zcB86R/9+bME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974419; c=relaxed/simple;
	bh=yxNjMFl+mwGj9v4E/1wOxcu0SudgbupA+aqU3mqijLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzkX2ffO/1L6D9DVMeOkvejQawSZcfJ1yFUH1OLeBf1tEpk0gKLaWSxZL5lv4jy8H3aUJ9PaELf8KsigzpkN0Mpra1ikHPKjWxVityT9Hv9aqkaAVugTDKJfe9imOGxmuyrEcNGEDsittNEN/wwG1te8XpXDbAd6gz5OWeVTg14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/BIuypQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/BIuypQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64E9C433F1;
	Tue, 23 Jan 2024 01:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974419;
	bh=yxNjMFl+mwGj9v4E/1wOxcu0SudgbupA+aqU3mqijLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/BIuypQy2qtWHMutmjOmTxWB65hFvAwBuPJ3Aafw21lZOXuMgSl/oHBhX2vplzpc
	 EZB681nuNK92I7JC4UIn8ZwRI5sCn3t8xsWVmxAWJA1mrNEu7nTSJrhnxqQAJ7zxuk
	 QLR3TBbLZc6GbFgZ6ApL6lhfzXrdeFpv1DzfOwSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/583] blocklayoutdriver: Fix reference leak of pnfs_device_node
Date: Mon, 22 Jan 2024 15:52:07 -0800
Message-ID: <20240122235814.489562889@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



