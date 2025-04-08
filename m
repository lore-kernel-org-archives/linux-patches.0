Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4F220CCD8;
	Tue,  8 Apr 2025 12:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115311; cv=none; b=MjZ6QMo3kA0wNdWruTl6idEJU1Ybmbnl3ptBP4PIz0BHk39mCGZB2Z9eTeivFn/JN9uY7cml7T08xVnFU88ellDrkIQlGM7A4+YjJsy0vzhGpamkRJmAHQe/dtTsHjcxFJTkwsHdX3rxs1kZBysXWEqx3Ijvzsu3yxNp/7qZ4Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115311; c=relaxed/simple;
	bh=KB1b5zYMoUA04Uznv6r9FAA9ssPEgVDLOtmwMZVcWoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvgqlBneMpsALq+0nRqGhMd8+/N2fnf4VOBRhv94zch3xj2SvKAn9i8LJLqmvgegzuZ4WTcwj+IOERqKWXI8XNAoZ9dE3KtpRrxof9Wi3JPgIsJlyu37rOnQuN70+ozvzfMQNPAE+EST4+tl4tT6hNVk8A5eYT4a3nfB9vDWeNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZdY7lvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZdY7lvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FD3C4CEE7;
	Tue,  8 Apr 2025 12:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115311;
	bh=KB1b5zYMoUA04Uznv6r9FAA9ssPEgVDLOtmwMZVcWoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZdY7lvTTmDxU9nqoI20Ai17mKk1hs4IBjafI3A1b2TQGyyzX47yRqW1yQfztXYPP
	 dbAD9huBRhJNXygwpSoDd7OFBJC+hAfxDfwAr8BGJ25JF0bpZEL20/3ffwgwrbL7e9
	 GNy6cyWLCuYXH3SqX6BXJvuofhn11Azt0z0H/CRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 378/499] nvme-pci: skip nvme_write_sq_db on empty rqlist
Date: Tue,  8 Apr 2025 12:49:50 +0200
Message-ID: <20250408104900.659375523@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 288ff0d10beb069355036355d5f7612579dc869c ]

nvme_submit_cmds() should check the rqlist before calling
nvme_write_sq_db(); if the list is empty, it must return immediately.

Fixes: beadf0088501 ("nvme-pci: reverse request order in nvme_queue_rqs")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 99022be16d2a9..e6c27175880bb 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -990,6 +990,9 @@ static void nvme_submit_cmds(struct nvme_queue *nvmeq, struct rq_list *rqlist)
 {
 	struct request *req;
 
+	if (rq_list_empty(rqlist))
+		return;
+
 	spin_lock(&nvmeq->sq_lock);
 	while ((req = rq_list_pop(rqlist))) {
 		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-- 
2.39.5



