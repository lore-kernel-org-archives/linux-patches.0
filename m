Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C502533471E;
	Tue, 26 Aug 2025 13:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214664; cv=none; b=R36bl3dA4bK+IdWKx2TuLCLngUALEuxwqmL8kFcIYDeO31Rn6wT8Ab/94yq6w7QXEHULxl586G+T4U2lNPTSOuRxiJkKtIHNIyL8bsM53E+W77uhnGrGltiFq66SDExT4piGS0jnoYfKopv8RjVjaEm6PD8iAbpS/iXNSsEqbN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214664; c=relaxed/simple;
	bh=Yo3sSFe6FbCeIyU78Er8Lo4i0LdwVa6NSdASueXNhcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUTEHUJ0J8se67FjoC5pLrQCWUG7CTOEDpEGo5QdH1WvQeZzTQtYzH0nDwGXdEWd1ez7yh+uLA89e61tkDVS1/a6PDenRk1ZA7bwswUUpWKxWMZVH4fTnQPRv0dtGdimvDRiHymwp1ZBkFQZBBWqP+EKnYMHNODA5NxeTreiL48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHAs+rpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHAs+rpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53429C4CEF1;
	Tue, 26 Aug 2025 13:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214664;
	bh=Yo3sSFe6FbCeIyU78Er8Lo4i0LdwVa6NSdASueXNhcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHAs+rpueLFRawgUpV0KBoQMmx6KAoYcuwMVeBy6173bzVGlI+X9n23OT2UuG5vxT
	 F8Qvv+RIg/tUkiDSCHcvKG+G6haQJgvwFCfi9AKeNWfn6v988S2LPCYm8PoHOYntMA
	 /RmAohldrLhUpMg0G0gju8stc6hp1/GhNhZqHkww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	Yishai Hadas <yishaih@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/482] vfio/mlx5: fix possible overflow in tracking max message size
Date: Tue, 26 Aug 2025 13:07:57 +0200
Message-ID: <20250826110936.309763066@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3f93b5c3f099..06794c48170c 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1127,8 +1127,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
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



