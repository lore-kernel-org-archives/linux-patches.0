Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977D53203BA;
	Mon, 18 Aug 2025 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524238; cv=none; b=BNdRc6O9B34tpl6BiHb5fkvv7OkrQupy4Zb4CdvdGxa+HRiKkYGRof8GHx6ndLzwSo+GYQgjYT4ZJOZ8enej40wIgYetqY0phA0PGGDQhXcPTGiPSBV/9xOsqGjQh0KhGfmUSIzflrSji86zNCQL92LogaPXUY35NrU36BjY0j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524238; c=relaxed/simple;
	bh=LP2SznVFEoWh3mFLzYixVzphMUahhH7IR8K78LVauJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7Tn/lQGTMwSiMtE1KUF+3b+9Pn88efcfpYRHMVycv3Pk0S5LdEbB+8e3xbhkutUuBpSG1JF1ErefxJwyUzIoQ2MnmaRRDOVTzdI1EE27zu+IFM7CGqdso4LZF2aB4fMfXRNuN3e3IG3pD8VLTh/TDUuJIuzhRuJ2c7aUlw+nuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KR3XWUgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KR3XWUgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D007C4CEF1;
	Mon, 18 Aug 2025 13:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524238;
	bh=LP2SznVFEoWh3mFLzYixVzphMUahhH7IR8K78LVauJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KR3XWUgK2FarrWi5Ozh+pDUWkKwZA3YBhyhhPOXqG93E+2IN9gcaSTFpp+1sRzEE8
	 J/kZP/GCwPAoSLnvEHGKd0wZCcawc9mfx8/AzYOUNNWnKcI1ZWHXEjsukdZ+rcJt0+
	 dFSNFnuZLOTEcCmJp2tM6YOB3n3KUAQhdzJy7zOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	Yishai Hadas <yishaih@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 411/515] vfio/mlx5: fix possible overflow in tracking max message size
Date: Mon, 18 Aug 2025 14:46:37 +0200
Message-ID: <20250818124514.237802429@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 11eda6b207f1..6d36b3b4cd30 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1538,8 +1538,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
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



