Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD7F6134;
	Tue, 23 Jan 2024 00:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970687; cv=none; b=MM7eYd2nl61tWMRJFvc5zsLdmvCo/scYt7vxzmmtckWiZYXeVqTS8hmTjm7pDBxHI825y8O0a3Z4d81tI72+BYWI0rCGaUhPYKsksks+cQG81m91cthA+eDi2Ji3hOxU3Q8HxBfGXnGFVX2iv0EahbVn2ZfMvCbnGAQOxsbjHgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970687; c=relaxed/simple;
	bh=GTdM8Pn4JsW8511jd1sbvDdlmYGz0yuKUo7LlqXVXoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2Dj6sYBBJeX5zEFaIZr6eXatnZorVftSVydDJTOEiRpcfF7KbR6BgV4lBaZAUCVvBODPWfiajUfzJtSN8VKoOi7rlDi8B+u9p7QUdlFpdoM/EEA/meHgivYrseSteGFw4C1jXWyx8+zwbawrtUy4Uc+3oe1ztEE6Dl3aMxi7d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UirQeuQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UirQeuQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B997BC433F1;
	Tue, 23 Jan 2024 00:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970687;
	bh=GTdM8Pn4JsW8511jd1sbvDdlmYGz0yuKUo7LlqXVXoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UirQeuQvDqlUlUum0i2Z9uK8cv3U3ln7BL0SbNEUK94fnokwne5W0CQOfOtXs1udB
	 uI0qbmF9CYkP8f9X6jupj1u2wM47eNN5WGW6ss8Owj/5bLB39LqvOQ+5HooGZJAG0b
	 /Y8PyZINeq5hmpSWrqpPW2m8Mtxbhm9Kg0kxMDPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/417] blocklayoutdriver: Fix reference leak of pnfs_device_node
Date: Mon, 22 Jan 2024 15:53:52 -0800
Message-ID: <20240122235753.923817997@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



