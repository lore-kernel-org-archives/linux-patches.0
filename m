Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801CC320CD3;
	Sat, 12 Sep 2026 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225988; cv=none; b=V0XtOcVlmXr5A+9wF0RSCDVZdjballjSQIYlX8O1xhb3IpuabiBhRclnLdl0UOe5A6EbfD9UYnQNFWW1yf42CBM7Ewlxphk2k8IMH6/pgmT1oX8xC1/iqcIV2mnGXAnTwb56R9EtQXWr04NvdvqJOiSD08KGnmE+8v/9l8GB1dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225988; c=relaxed/simple;
	bh=rPOpTNZV5PQ6Oy+EkKqxUGE6kGfTN3ZZFP68LwNdcSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L6MewTFtqbGXWpRUhtyWLBM2KwGB14jhCKxb8AprYushIUT+wiQYo8++WfgKYlL9j9l3nbu9Bb79TT8/1U4pOzHdqoD4lP7bAhiSAWEitTCyuX8DsFFTvkJ4cn7g6XNvn5KIBNMQn2bDdSUKnpiH7wCo0ciYa9B95cIdrtNKef0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AigXDcDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AigXDcDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE721F000FF;
	Sat, 12 Sep 2026 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225987;
	bh=qS7eJx4mfeG5xNzmRysIrXQD9/l7sZMhW3GCzBmYcAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AigXDcDxpd40Ndt7dtFW1L3iyuiWnR3DPSaqgDEP7fq8ZdlyDVZ+UT2ZKbrIoLvla
	 Me3MxqFiIb6mWK90DEU9FiuLlw9TSIJ0sdldTSq0c08Q2IN3pcTZ/S8wcDBwDek+bw
	 Mw41KB5ib27TOkiot280myQkQ8+h228upmCW5s9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1309/1424] vdpa/mlx5: fix wrong list iterated in add_direct_chain error path
Date: Sat, 12 Sep 2026 09:02:21 +0200
Message-ID: <20260912065636.577275735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1657306569345..f102b9ff967b8 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -343,7 +343,7 @@ static int add_direct_chain(struct mlx5_vdpa_dev *mvdev, u64 start, u64 size, u8
 	return 0;
 
 err_alloc:
-	list_for_each_entry_safe(dmr, n, &mr->head, list) {
+	list_for_each_entry_safe(dmr, n, &tmp, list) {
 		list_del_init(&dmr->list);
 		unmap_direct_mr(mvdev, dmr);
 		kfree(dmr);
-- 
2.53.0



