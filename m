Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BD83557E8;
	Tue, 16 Dec 2025 11:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886250; cv=none; b=RMyU4MMNaRPkP0R7b6XF/ujGhmQ21ue8mLnTa1stNdmkez0aYhV/CcrZZIxerT1Kqu7s7wnvWKRmwmkkxDawiD50+y3ZZIw2s5+UMQK1+lvY7dYwI3Mo0Onox7yrsxiXNRBMzsiuw8COHthOZOeq8fz0yDbDCmbUnwV5DZZX8ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886250; c=relaxed/simple;
	bh=OqHFCuKyh35GXTTvRp3MWjL55O5i1Trhnb0OedK9FZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1D7eGHlzP49/PQHjB/ZEz9dBp1ounLZ2NnFEoSAtV2bCqz0Pa/j951Bl2cOh3TaU5kwj3Gv30fA8xyUa/h+iRUkMspaTs/V7HVw5GBtnulqxEitU8+QpthWboZE2uK3XV2FdYS9UywjFZXSNlUEGbYnr02dJaJnoqdvBz5wqw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpVhtFEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpVhtFEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22656C4CEF1;
	Tue, 16 Dec 2025 11:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886249;
	bh=OqHFCuKyh35GXTTvRp3MWjL55O5i1Trhnb0OedK9FZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpVhtFEyFNLc3qrL2L7OTT0a0RBCvHs5tSj4zS+OiT0xXW8C+LAAXc+0piArP/REl
	 qn6SCm8eLZ1e6BJWj3+bxAEV4LwNgfS7EX093BhcrhQjtAsUqnqoudE5HX71JwVWKm
	 lMPIFaq8Fpj/5SNwJs0vacWh2NrsXjdxWCDzVYqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 380/507] vdpa/mlx5: Fix incorrect error code reporting in query_virtqueues
Date: Tue, 16 Dec 2025 12:13:41 +0100
Message-ID: <20251216111359.227071855@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 53cc9ef01e9f7..ab626f7c81172 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1256,7 +1256,7 @@ static int query_virtqueues(struct mlx5_vdpa_net *ndev,
 		int vq_idx = start_vq + i;
 
 		if (cmd->err) {
-			mlx5_vdpa_err(mvdev, "query vq %d failed, err: %d\n", vq_idx, err);
+			mlx5_vdpa_err(mvdev, "query vq %d failed, err: %d\n", vq_idx, cmd->err);
 			if (!err)
 				err = cmd->err;
 			continue;
-- 
2.51.0



