Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBE7257AD1;
	Tue, 16 Dec 2025 11:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884628; cv=none; b=Slzr924OVf8xTL/ufqmhn3/sKPjq7NFFBGEOGPsOY2eoSwKrwT6EaBeYJkuzePXZx0MEnLitkNWVMDN3diLHWNpgoKRhQDo0aFXr+qzK8tKFLKpypKFePaj/XUcC9MOVpre6VppVBsn08pAXHnTaIy5n43YdItKLVXj/Km7CU6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884628; c=relaxed/simple;
	bh=ayVKR268dzAzsjoQR2DJd+JShSZrfokO4SCgkhtFApo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fm1LqMwsTYx8kbMZqOaDH2tlkihSQVtuwGZ0184QF+KVROYBe0CYFbOq/JnxuA8bTr4FX45+v6kzbMSHkc62vWkaXmejAtd8mTR4USEPWnFawUG+jxMgLoqDxOXivxJ7JwGlTRtQNGVlFNMMJ+T0E9Ij2FhX2/BHofyF/yUu0vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GBhguzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GBhguzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9547EC4CEF1;
	Tue, 16 Dec 2025 11:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884628;
	bh=ayVKR268dzAzsjoQR2DJd+JShSZrfokO4SCgkhtFApo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GBhguzxpUctydfRerDT4PqJ/hMohEiyb0oN+uPPiruOqpHF5GZlCTJEw0AiysuSO
	 HhjvPaL6hHOk2LVwbAJINIwI4sjUkm9b1r+BaUnmvuZql35/8+bkR3QsCyqsrcb6SY
	 TOnFAn+y4o326Ky3ofLHNgHlv79WPYTaYFnBH2NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/354] vdpa/mlx5: Fix incorrect error code reporting in query_virtqueues
Date: Tue, 16 Dec 2025 12:13:39 +0100
Message-ID: <20251216111330.045225366@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit f0ea2e91093ac979d07ebd033e0f45869b1d2608 ]

When query_virtqueues() fails, the error log prints the variable err
instead of cmd->err. Since err may still be zero at this point, the
log message can misleadingly report a success value 0 even though the
command actually failed.

Even worse, once err is set to the first failure, subsequent logs
print that same stale value. This makes the error reporting appear
one step behind the actual failing queue index, which is confusing
and misleading.

Fix the log to report cmd->err, which reflects the real failure code
returned by the firmware.

Fixes: 1fcdf43ea69e ("vdpa/mlx5: Use async API for vq query command")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20250929134258.80956-1-alok.a.tiwari@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 2e0b8c5bec8d2..51b2485e874f4 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1258,7 +1258,7 @@ static int query_virtqueues(struct mlx5_vdpa_net *ndev,
 		int vq_idx = start_vq + i;
 
 		if (cmd->err) {
-			mlx5_vdpa_err(mvdev, "query vq %d failed, err: %d\n", vq_idx, err);
+			mlx5_vdpa_err(mvdev, "query vq %d failed, err: %d\n", vq_idx, cmd->err);
 			if (!err)
 				err = cmd->err;
 			continue;
-- 
2.51.0



