Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE4A34FF78;
	Sat, 12 Sep 2026 09:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204504; cv=none; b=jy8+m7QmlMWquOLIdx2FcjRxlYds56ytdEuAdVdeljNbkGp1YJHc80A8w77EX3MfJXF402c4rtyn2q00w2bfYgdRtkm2egtXsXsT60qYBM96lvN20diO6uCCgqirsPubSz4hy4ge+g/3alJLt982H5OKz+xnPoH5qKuz+igKKbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204504; c=relaxed/simple;
	bh=3wguVNbjZPlngILSdmpAKbhOBvwoKydJNvHDzglo2Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TFUQsNKetrLa9vL0m6knjnqz0vppDFOUmNsxJvwkFZWQQjHIE1dbP22o5+J+Gz2EYTVQGPW/H7v+Q4o/18RO/x6v6RRpS+xFrM2qHoTAt4UthN9yCIW8oXzPeDZJ8XQda+yiodii8F/Aej5UeilE8Po4gLoaOEViU3xyVifqXnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiV0DxEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiV0DxEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E406E1F000FF;
	Sat, 12 Sep 2026 09:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204502;
	bh=3G3mSoOlpQj0MemnmsmWS4nJY0IIn9ATDz8z1N54xhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OiV0DxEVrOzz1K+ukxcz7yC4+AKWiqo0r82auY5I98o5L8IBnt9hd07jVuDU2rEFp
	 nN6YwarCEUyWBcBGy/3qBK5yhjSVnAJ0JDAsul0Y7hyOzUJMHnakucRZoAsUce+VsR
	 FNuzZ1pBkgrRWqtEmzRgR4Y46nUiI4gBcQFmGZcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1626/1815] vdpa/mlx5: fix wrong list iterated in add_direct_chain error path
Date: Sat, 12 Sep 2026 08:56:16 +0200
Message-ID: <20260912065727.160414479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 23ae56d9e74c122f95cae71ae3b9fc259fb88446 ]

In add_direct_chain(), newly allocated direct MR entries are added to
the local list 'tmp', which is spliced into mr->head only on success.
On the error path, the cleanup loop was incorrectly iterating over
mr->head instead of tmp.

Fix by iterating over 'tmp' in the err_alloc cleanup path.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260701113608.1972-1-lirongqing@baidu.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 77a479aeaa85a..b0c5ff23d022b 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -481,7 +481,7 @@ static int add_direct_chain(struct mlx5_vdpa_dev *mvdev,
 	return 0;
 
 err_alloc:
-	list_for_each_entry_safe(dmr, n, &mr->head, list) {
+	list_for_each_entry_safe(dmr, n, &tmp, list) {
 		list_del_init(&dmr->list);
 		unmap_direct_mr(mvdev, dmr);
 		kfree(dmr);
-- 
2.53.0



