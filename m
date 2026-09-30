Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A7B3D9041;
	Wed, 30 Sep 2026 19:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795275; cv=none; b=R7eQ6X9cbtKJa0z7pCt0SPlyIyW5t9Y1rVgzkcnqqJDwKQ4Fo1RCpu4otf/OwHlDUypoE6XfLPAyz1khJRdm52U6d1oAuNb9m3HK1HseU85C15msIA6BZon2kCh5ZTb7UVDHwhC9fjp8ehWLQMwXmKSD6A35uTphMaIYjVwhAAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795275; c=relaxed/simple;
	bh=UxpQHobpv6utStNiSg+1FQyFzlWRa3oAFVCu30EbSRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdVudW/Hlr5i7FYJR+N3aX2Vv3X9zg0Vz/ePFrtUj/+cGRMDGFL9MALho/AKfTH2XF7PqqGs9ubVbMl7BaAK7fudZ6fEK+NKprlgDZ9I1jt898/VeqlDb970QqPHmYJf2LosykSMD4K2m1b4exO2X6G/A0Tr0Qg0JutKBsJnZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nj9QK4+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nj9QK4+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4E41F0089B;
	Wed, 30 Sep 2026 19:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795273;
	bh=+qW/rL2yr+9WSGZkPkLxcidQvwvfKzLlOvUDfHSFd8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nj9QK4+/9JNLhe3T5+1IVpZxjcCOspdRgplFFqJU+aZxxms+TLPWG7ezgWqZ6AZSd
	 ksVZBt8UxWU6jtGabXPWN/TSpw/kcgkfchfgBZAyvS24Nm3Wo/6fuKDbik5c/sOETF
	 V4xeBiaJ+lQmIqZUK2+WshoFjpq3knLX72mySUMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0503/1193] net/mlx5e: Fix use-after-free race in sample_restore_put()
Date: Wed, 30 Sep 2026 17:19:47 +0200
Message-ID: <20260930152445.337592146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit af3aef0245abbab5e9f6302e7a7d6407187afb71 ]

Concurrent teardown of TC sample rules sharing the same restore
context may re-read restore->count after dropping restore_lock.
At that point another thread may already have completed cleanup and
freed the restore object.

Use the result of the refcount decrement while holding restore_lock to
determine whether cleanup is needed.

Fixes: 36a3196256bf ("net/mlx5e: TC, Add sampler restore handle API")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902193341.3668809-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 5db239cae8145..5ae13af900308 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -311,12 +311,15 @@ sample_restore_get(struct mlx5e_tc_psample *tc_psample, u32 obj_id,
 static void
 sample_restore_put(struct mlx5e_tc_psample *tc_psample, struct mlx5e_sample_restore *restore)
 {
+	bool last;
+
 	mutex_lock(&tc_psample->restore_lock);
-	if (--restore->count == 0)
+	last = --restore->count == 0;
+	if (last)
 		hash_del(&restore->hlist);
 	mutex_unlock(&tc_psample->restore_lock);
 
-	if (!restore->count) {
+	if (last) {
 		mlx5_del_flow_rules(restore->rule);
 		mlx5_modify_header_dealloc(tc_psample->esw->dev, restore->modify_hdr);
 		kfree(restore);
-- 
2.53.0



