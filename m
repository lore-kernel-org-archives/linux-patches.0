Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985D034F497;
	Sat, 12 Sep 2026 19:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240613; cv=none; b=Gf15ob16ftBLrFlUZ0F5wPreE8GstKu7ooQfI+FjFHFlGUFtgsEnUEo3LzqFosnXYHdmVJxt/WLAEnfSesYSjBL0UkYBj30VwJKTTobVfErrFkItQaJfFkEKs2kNog+wrtAnAyy0O1mSVJ4u3hf3JG49+cM/kVdifcXBhjeNElg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240613; c=relaxed/simple;
	bh=uesAdastUMHMfahOEwNKWU4qOYWqaMxZ01WbKPELAGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxxPQugbwx7A6inuuLjgtB8Wufl/1VM5+6Sa1dpLNpMXAVBLuIBFxB/JpXNFUtfE2xTh9DuPSRbuVDlefFkJejstJJXif4H6ThQIx6tYnq9SGoM12apvzFyhVBu4Tnz98XSeHn1T7X+pOstFt+PrrtgaYXzW+L9X5eG9uFVRNss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Laqxq9ej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Laqxq9ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DC91F000FF;
	Sat, 12 Sep 2026 19:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240612;
	bh=7kZhvedlJMDZRXUE/PLSiXevusOIKx8MQDHys2SBdfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Laqxq9ejKO669Fsoe0jEziQZ805XWaVL/fJMCNwkrHdoKfpeG7KOFheAUUqYIQpnA
	 TgiM5sh/Ki5kTPomv8NAeyYSqK8nSyIugS/vOsDHbIqn79+WgS9cyD+vs2/KCBo8Th
	 GAnmxHx4zJS18S94ePN26pgl5cZ8bzljdLTgaaN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 862/935] vdpa/mlx5: fix wrong list iterated in add_direct_chain error path
Date: Sat, 12 Sep 2026 09:04:52 +0200
Message-ID: <20260912065546.594036436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 59504edd1e55b..b9a3746bc908b 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -345,7 +345,7 @@ static int add_direct_chain(struct mlx5_vdpa_dev *mvdev, u64 start, u64 size, u8
 	return 0;
 
 err_alloc:
-	list_for_each_entry_safe(dmr, n, &mr->head, list) {
+	list_for_each_entry_safe(dmr, n, &tmp, list) {
 		list_del_init(&dmr->list);
 		unmap_direct_mr(mvdev, dmr);
 		kfree(dmr);
-- 
2.53.0



