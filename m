Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C22232A3FA;
	Mon, 18 Aug 2025 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526203; cv=none; b=p+nCKf7HLbMke9e4yp2r4Aigvwbltkusfi02ZqQbp8lBq+//cwEuo6hqatDezXYCkdHCGPc8qO+XpURGa22Ca5k2uBmiePQKZJ5hPhzzwTZuPh8+U7OB+w7YKaT7ufSMxMRGE9avRPTOVx1xsSNYbcxovqrlHAwYWuaSGwYwddg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526203; c=relaxed/simple;
	bh=d2mEA5NF33oHA1pHwyjvjljCuHTcP5SgISkbVMZk5oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZZBb9tHHbknz4A5i1UsFdSXxdFEdpS7FWvQq/KCyqpUSMwjLBDUDtNITFO3erZL+ja17poK3fOTxsEaB1Ynf5jzyFg7llkwTViZHLto+zoqpYUIMIzmFvuxJ/jFLq4FHxBapqRL2OFYFaOgtyBn6Ep9IVBY7qKIuZSiYG3tkCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoQjpAKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoQjpAKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF7CC4CEEB;
	Mon, 18 Aug 2025 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526203;
	bh=d2mEA5NF33oHA1pHwyjvjljCuHTcP5SgISkbVMZk5oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoQjpAKV4dZxiSuxc3hJJ+9h67XvyDFAHjpUCeAtppKCQJVG4qa5aK37awsPyNYkF
	 yCyJgHsXJUZHCddF7plX97Ma3naH1foGoy/Bz95HN4f27k0XOlpHJcecOG6Yl0MTYL
	 /J3ykclQA4ojcr6mIsU0DajbCOsrGEdMsLsIFPhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	Yishai Hadas <yishaih@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 445/570] vfio/mlx5: fix possible overflow in tracking max message size
Date: Mon, 18 Aug 2025 14:47:12 +0200
Message-ID: <20250818124522.959642309@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Sadovnikov <a.sadovnikov@ispras.ru>

[ Upstream commit b3060198483bac43ec113c62ae3837076f61f5de ]

MLX cap pg_track_log_max_msg_size consists of 5 bits, value of which is
used as power of 2 for max_msg_size. This can lead to multiplication
overflow between max_msg_size (u32) and integer constant, and afterwards
incorrect value is being written to rq_size.

Fix this issue by extending integer constant to u64 type.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/20250701144017.2410-2-a.sadovnikov@ispras.ru
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/mlx5/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5b919a0b2524..a92b095b90f6 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1523,8 +1523,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
 	max_msg_size = (1ULL << log_max_msg_size);
 	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
-	if (rq_size < 4 * max_msg_size)
-		rq_size = 4 * max_msg_size;
+	if (rq_size < 4ULL * max_msg_size)
+		rq_size = 4ULL * max_msg_size;
 
 	memset(tracker, 0, sizeof(*tracker));
 	tracker->uar = mlx5_get_uars_page(mdev);
-- 
2.39.5



