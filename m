Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A7CBE5A;
	Tue,  2 Jul 2024 17:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940157; cv=none; b=MRi1scWpAQXbH/aZ2m+31SxJx/dWDl6SlKRtKZ0cZBxGTqTspx1PKIuiMr59OUoEkzq15BUt5c+9hZxZ0CWfxt4WQuAliY79SBbX1HSZhE/ER/NsQzKHsr33YyvOOoWtjBTk6jO4WujLA20jclQkISwAhTMA8BGeFPhBFBNYSJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940157; c=relaxed/simple;
	bh=SpHS5fqnD9Yb/VCDc9Lj5e60yDUq+V+0ifsnrQ1ZrnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jH5BKhbPth0utIlU6p0neI6MP0KaqXsBzawVzFkTVOHhCaCNrY/JLB4eBFiFLSGQSPBnzkKQw+13L4GTxmZA5GJhj6r3Oced8mI322D0J0Yf0zZDElBokES1Nl+SpT1qrw1JFdjzDUzurhWPXrW/gYlZ316AhgfxxgBgh9Resws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lK97Zcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lK97Zcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0CBC116B1;
	Tue,  2 Jul 2024 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940157;
	bh=SpHS5fqnD9Yb/VCDc9Lj5e60yDUq+V+0ifsnrQ1ZrnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lK97Zcpe1nnXAZyCusYN7Ztew09q2/eS85OQBLvE2Vt8OSksjdIC61pIHi6BSCmN
	 LU4fzBehwqwdoFSBgomPLpqDDypKk8ULs7IzTHbMA2UXVSWxZDWTxZXkMov2HSZzhX
	 g0GXfo8RQlaTwIocV3cP+VWEIOcQaV7+DFYKGbNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Maxime Coquelin <maxime.coquelin@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 069/222] vduse: validate block features only with block devices
Date: Tue,  2 Jul 2024 19:01:47 +0200
Message-ID: <20240702170246.618832044@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Coquelin <maxime.coquelin@redhat.com>

[ Upstream commit a115b5716fc9a64652aa9cb332070087178ffafa ]

This patch is preliminary work to enable network device
type support to VDUSE.

As VIRTIO_BLK_F_CONFIG_WCE shares the same value as
VIRTIO_NET_F_HOST_TSO4, we need to restrict its check
to Virtio-blk device type.

Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
Message-Id: <20240109111025.1320976-2-maxime.coquelin@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 56e71885b034 ("vduse: Temporarily fail if control queue feature requested")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 73c89701fc9d4..7c3d117b22deb 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1705,13 +1705,14 @@ static bool device_is_allowed(u32 device_id)
 	return false;
 }
 
-static bool features_is_valid(u64 features)
+static bool features_is_valid(struct vduse_dev_config *config)
 {
-	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
+	if (!(config->features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
 		return false;
 
 	/* Now we only support read-only configuration space */
-	if (features & (1ULL << VIRTIO_BLK_F_CONFIG_WCE))
+	if ((config->device_id == VIRTIO_ID_BLOCK) &&
+			(config->features & BIT_ULL(VIRTIO_BLK_F_CONFIG_WCE)))
 		return false;
 
 	return true;
@@ -1738,7 +1739,7 @@ static bool vduse_validate_config(struct vduse_dev_config *config)
 	if (!device_is_allowed(config->device_id))
 		return false;
 
-	if (!features_is_valid(config->features))
+	if (!features_is_valid(config))
 		return false;
 
 	return true;
-- 
2.43.0



