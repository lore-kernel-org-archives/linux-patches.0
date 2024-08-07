Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9174A823A9;
	Wed,  7 Aug 2024 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043495; cv=none; b=Pjx0HOEdzIF1mhxXyyU8YYbflpEgjmnIzBwlYkHtzbDfN6gwp8IRoR5tt6ois+RZIKSnVuGF13iS897LIzjy2v5Ny0/g0wVyRbodTodw7OdqHF/7p7LYj3PqIRqyOmKZ2+J4H0OyLPFpizgtCWmrmbQDi0Kd1yNU/JMjHLxARtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043495; c=relaxed/simple;
	bh=QQMmiod5Qj82muUCv+WgqkDYlSVhjscPOTrtycngbzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGDwtdfBYsj6hiTBuW2l+1lHCJ6NZzCfUKJXC4KsWD2EwW953HLRDirxKLCd/By1EhP3DGYb23k949VuFnJDASb745/xKwUHeU0X+Y2cUfJKFFIr2EC82D6DxYJCXmVwB5f7Ke78Q8IIDLq5EXw43ObO+uPOi6GEQMSiGeWCGAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfFnWbV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfFnWbV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F4EC32781;
	Wed,  7 Aug 2024 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043495;
	bh=QQMmiod5Qj82muUCv+WgqkDYlSVhjscPOTrtycngbzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfFnWbV1cMvLGIhnkQcqFGnOrRORa04XaJ7UM/TyBYm9MmkeIgtKa50WoYULqGsu+
	 DJlwlevg3ahk6D9tWee/qETU2OQf6Oo7XvZ7ba5V0tTF3jfVVOzJmFtmRblrcRyYAn
	 RnJWoyfKqleOYrldgbMN0tvhczL+iqZk2ZLjtFdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/121] net/mlx5e: Fix CT entry update leaks of modify header context
Date: Wed,  7 Aug 2024 17:00:17 +0200
Message-ID: <20240807150022.191941836@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 025f2b85a5e5a46df14ecf162c3c80a957a36d0b ]

The cited commit allocates a new modify header to replace the old
one when updating CT entry. But if failed to allocate a new one, eg.
exceed the max number firmware can support, modify header will be
an error pointer that will trigger a panic when deallocating it. And
the old modify header point is copied to old attr. When the old
attr is freed, the old modify header is lost.

Fix it by restoring the old attr to attr when failed to allocate a
new modify header context. So when the CT entry is freed, the right
modify header context will be freed. And the panic of accessing
error pointer is also fixed.

Fixes: 94ceffb48eac ("net/mlx5e: Implement CT entry update")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-8-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index fadfa8b50bebe..8c4e3ecef5901 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -920,6 +920,7 @@ mlx5_tc_ct_entry_replace_rule(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, mh);
 	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
+	*attr = *old_attr;
 	kfree(old_attr);
 err_attr:
 	kvfree(spec);
-- 
2.43.0



