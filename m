Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EE651EE0D;
	Wed, 30 Sep 2026 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789511; cv=none; b=M5SeUJg61M5k+VPgW7plFIfY1sgbC610EP3WEeV97G8BitzUu9+jKfDV1+uTYXqTFoTxbXuCfXiqf7aNi7SQikJEKwjlP+xbiCyoLc4KeNT/lHs9+33rdjhcxJInYBdSuyHoHP/tzhJq8q5YG+kQRwVq7dECwL3QihfjMDcPrzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789511; c=relaxed/simple;
	bh=YByHh/92hCi9a9VrKJZL0rqhbnNNeOl45si3tr8v01Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH9pSlcpKRPXo/A5v2LDMsVoH5WCebEipAkB2MEI9httU/Xyr5yF1JhGdEQMNy5OfecvDphN8GKqbFVbui/ef0QsjR1sYq8jS6eov+Ny1KhseAW5+TayCCU42gz+Fv2gY9biewelE5eIroBvhEem545JP6DCT8ON02WzkeRa6z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUkEdwZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUkEdwZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EEA1F00898;
	Wed, 30 Sep 2026 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789510;
	bh=gOMhJpI78YVEXzLIU557EsaxQ7HqUpj6lJe5G6kRepE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUkEdwZKoNOku/B1TOKgtL/N8G2p87YCWxbKNnHWt1c9qhCrbCFOYvOiILEO6suxd
	 fVWz+OTc3/mU5ZDPR0lTM4t2J6XO4TI/oThKBGPVle65q0omFQQM4YrKC+HCE3Diiy
	 mTAHiUlH+u3KZjLLli8dVy/4G+rqJNUMYlNba9do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 504/877] net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()
Date: Wed, 30 Sep 2026 17:23:35 +0200
Message-ID: <20260930152425.537557343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 0bf6bb567f0edaa771e7dd208ef98da50e6a4485 upstream.

When the reverse entry is found but its counter is already being
released, refcount_inc_not_zero() fails and the reference taken by
mlx5_tc_ct_entry_get() is never dropped before falling through to
create_counter.  Drop it so the reverse entry is not kept alive forever
by a shared counter lookup that did not use it.

Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260917113131.2149024-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1082,6 +1082,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx
 
 	spin_unlock_bh(&ct_priv->ht_lock);
 
+	if (rev_entry)
+		mlx5_tc_ct_entry_put(rev_entry);
+
 create_counter:
 
 	shared_counter = mlx5_tc_ct_counter_create(ct_priv);


