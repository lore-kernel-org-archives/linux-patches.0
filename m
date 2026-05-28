Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512F71C3318;
	Thu, 28 May 2026 20:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999890; cv=none; b=fJ4yxGyoe3JbmSKlw7cBuXatObptZTnyu4vENmdgjRpVkV1ifSHXlfKBRUV/4dTDAU7qFRHHiSe5uYoObGvovAS/oo8zARysrDU9PescTt0yQcpTfwZWxt+BbyT7wZcIDu7XqwMAK29VaCk7Tk5Vafbh13ECsxbxec0cEiZIJyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999890; c=relaxed/simple;
	bh=Yx2XpbaVPy6M/XXMcow5ulYZzfI+oMeVeip5QYLG5oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IURaE/n6w1QBhTk315sOWQC7zUJ4Ny8XR5rVStl4fOJ5tr+7EB4ic5SvOjK8dTSlPwbTzx7O79LeZgemEQBM48uZrogvd3GoMvZg4/dwXm0phBjtODA2As2k3jdqaSjpBDWx2hDSS9R2Aw5I4mzMcPogWVl678EA/65ZJIPv4II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myeNqebA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myeNqebA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3741F000E9;
	Thu, 28 May 2026 20:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999889;
	bh=kDsJEtOAd3UWRiS/Xrx6cjgEV2/W0WfoAYhLeAsWUuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myeNqebAOhMVo/ZAO/JeimJ3dkwqAaANlzF3KiArZ6CpQL/HS+EHponSboMSgvGCJ
	 4O8hlcR8mpVphex6nohdKypvq8MbK+Mv7WnWKqaUEPfY//UeGA6stivHeFJvOf0pRQ
	 z6pZmZy+mcn2rtKtRYR46M4c6WTWR+pfaDO0bGJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 226/377] nvme: fix bio leak on mapping failure
Date: Thu, 28 May 2026 21:47:44 +0200
Message-ID: <20260528194644.936144737@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 2279cd9c61a330e5de4d6eb0bc422820dd6fdf36 ]

The local bio is always NULL, so we'd leak the bio if the integrity
mapping failed. Just get it directly from the request.

Fixes: d0d1d522316e91f ("blk-map: provide the bdev to bio if one exists")
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index c212fa952c0f4..5bbaf257fd6c5 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -122,7 +122,6 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	bool supports_metadata = bdev && blk_get_integrity(bdev->bd_disk);
 	struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
 	bool has_metadata = meta_buffer && meta_len;
-	struct bio *bio = NULL;
 	int ret;
 
 	if (!nvme_ctrl_sgl_supported(ctrl))
@@ -154,8 +153,8 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	return ret;
 
 out_unmap:
-	if (bio)
-		blk_rq_unmap_user(bio);
+	if (req->bio)
+		blk_rq_unmap_user(req->bio);
 	return ret;
 }
 
-- 
2.53.0



