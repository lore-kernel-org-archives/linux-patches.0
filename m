Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55D0218AA3;
	Thu, 12 Dec 2024 15:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016085; cv=none; b=HgfjyNUVCPplLlDnvz6YQ1LafjSQcjX6/uQAD8QJvk2ICvc3+9vIeCUmfZTuuuLblAAo7KK0QKNiUnpGgqGSSvPS+9n901tQN6U8eYNp7SciWZ4EsEcHPW3B4HoSJplTEjGPmA8sTLF4ESMNNNqbCLqDiJ6XbHp4rcsPn+5ICwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016085; c=relaxed/simple;
	bh=w2lRu6GUYUvBCNh24rL0WlvZ5aQADrpPjBPpGJuwwQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEAyAfb68O6OMpNlAJqIFhwCcEF2zI26TqJidN5xPQCk6Y4SVe5FFhj816xhJxXAsb28TEIV/d34aIB/ke2QXnjSa0fGxnWMALaTwU0NR0mLM8JshKZkpI78Q+jOARa8h8wCHodn1pginAHlQ7exNATuSDtog0xP7kzZloQxDLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xqw5JRYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xqw5JRYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBA9C4CECE;
	Thu, 12 Dec 2024 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016084;
	bh=w2lRu6GUYUvBCNh24rL0WlvZ5aQADrpPjBPpGJuwwQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xqw5JRYPxRg2LYFQfB/AZPbUorS9KZgrnP4zP2DtKadHukvaWdaZYdGyQPRgHspRG
	 8kkonG1+EKQE4Vxr0ueZb45vAu1Y+pgQqct+bvYoP480EM+nVKEI6iM2rloDjAHxTC
	 Jio5Ftxr0GLVDZE99dR5qk2qYQc1UjwQVD+xjo3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/466] nvme: dont apply NVME_QUIRK_DEALLOCATE_ZEROES when DSM is not supported
Date: Thu, 12 Dec 2024 15:54:26 +0100
Message-ID: <20241212144310.645811767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 58a0c875ce028678c9594c7bdf3fe33462392808 ]

Commit 63dfa1004322 ("nvme: move NVME_QUIRK_DEALLOCATE_ZEROES out of
nvme_config_discard") started applying the NVME_QUIRK_DEALLOCATE_ZEROES
quirk even then the Dataset Management is not supported.  It turns out
that there versions of these old Intel SSDs that have DSM support
disabled in the firmware, which will now lead to errors everytime
a Write Zeroes command is issued.  Fix this by checking for DSM support
before applying the quirk.

Reported-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Fixes: 63dfa1004322 ("nvme: move NVME_QUIRK_DEALLOCATE_ZEROES out of nvme_config_discard")
Tested-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f0d4c6f3cb055..fe83d31ac928b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2064,7 +2064,8 @@ static bool nvme_update_disk_info(struct nvme_ns *ns, struct nvme_id_ns *id,
 	lim->physical_block_size = min(phys_bs, atomic_bs);
 	lim->io_min = phys_bs;
 	lim->io_opt = io_opt;
-	if (ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES)
+	if ((ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
+	    (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM))
 		lim->max_write_zeroes_sectors = UINT_MAX;
 	else
 		lim->max_write_zeroes_sectors = ns->ctrl->max_zeroes_sectors;
-- 
2.43.0



