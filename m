Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5220C423A8A;
	Tue, 31 Mar 2026 16:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975598; cv=none; b=Lx/d44mHLk3FUp38Fa9hZbwxX0tyEpe6tg1mLHV7ZuCr35qDlNlo1Tr4z2erggTK5c0JiZjGjGc9LN66rmeU1Sfg17rF9/NYYGbfNI62tMYLBYIBSVbl89kmUh8CDNmK9D7IUg1hOK0WNG48cbwJ8dsY2zCDIOlZMYK57zGQa/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975598; c=relaxed/simple;
	bh=17D0YnUcqPluj68DR8ET6o3bMlCeOVVf+9lDSwmZ1U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsCJbET6dDuHqH+LYIZAi2K9QN1OjU4m474i7opBEkKWmbuNGVBXBfgU0vSv+x/Xs4KLhsQiQMsxe0d5+cr0oVg/pVVGgw3WBuuFP4sMblUZbdrcEw4vGCRDzfFWrPc0C7mtk88YW/8H6b5MFu94PFDTcXQNGuWquWKOtKC7Tvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j48PcsXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j48PcsXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE389C2BCB1;
	Tue, 31 Mar 2026 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975598;
	bh=17D0YnUcqPluj68DR8ET6o3bMlCeOVVf+9lDSwmZ1U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j48PcsXWh+X3vUc08RrYIYA9Lpln5k9KJjLPx61IsbQBEsRdT6xLmH4bKILtre6Hs
	 gnchqGbW0wvkPtKrabIdDhanU7Kyzw4uNYSJS6iuLcJetqeS6oyOwKjjnKhGHGKpsK
	 Efq6WmtcyAwgSvmU9rmGPc4Ahdlt3ko3uBBycJkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/244] nvme-pci: cap queue creation to used queues
Date: Tue, 31 Mar 2026 18:19:24 +0200
Message-ID: <20260331161742.232688437@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 4735b510a00fb2d4ac9e8d21a8c9552cb281f585 ]

If the user reduces the special queue count at runtime and resets the
controller, we need to reduce the number of queues and interrupts
requested accordingly rather than start with the pre-allocated queue
count.

Tested-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6bd02c9116501..7a58ba05484bf 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2456,7 +2456,13 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	dev->nr_write_queues = write_queues;
 	dev->nr_poll_queues = poll_queues;
 
-	nr_io_queues = dev->nr_allocated_queues - 1;
+	/*
+	 * The initial number of allocated queue slots may be too large if the
+	 * user reduced the special queue parameters. Cap the value to the
+	 * number we need for this round.
+	 */
+	nr_io_queues = min(nvme_max_io_queues(dev),
+			   dev->nr_allocated_queues - 1);
 	result = nvme_set_queue_count(&dev->ctrl, &nr_io_queues);
 	if (result < 0)
 		return result;
-- 
2.51.0



