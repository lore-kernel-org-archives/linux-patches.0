Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F64E40F726;
	Wed, 30 Sep 2026 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797038; cv=none; b=EE0S2OW5UpkWv5hF2NzngvEFJ5hpYR+Rg5lwJMIH04xc8VUy9VS2YxcTBhz/kHXcpBASTbA44IV6dPnRMxmV//7Cvho85TnQWeDTJagjYa+R4HfdGyUaq3o0CS2/opfi7VtDMhamJJjrLfjEv7dia2k3x1EUirnW9tG4DsBWzqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797038; c=relaxed/simple;
	bh=K1OLo5F0iO8YgPPXVvFesMYhXwTuuajQgFIb9QqoZrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6nC8IUaeNHk61lOAFBpBLUrWsxcCIowWjrHozbVyGz8ppnw6rNYpLwNgQPDeYzsA0Yk5E96C/G7D0ck1MKFqSbnSPSs0eILqWpLwRFtoHRJUsoHpgBp7h82dFUnC2u81G9JeHMppDeRaRGz1eI9vrkLPVN/8BYWZtPCqow2Sd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLeJqpMI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLeJqpMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EED1F000FF;
	Wed, 30 Sep 2026 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797037;
	bh=cUkkfRe56hBf9sKe6CMXTtsnhydyS9WDSfR/SP0fA88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLeJqpMIibKopZaLLH4bBiBdAqUY06UqfpOvkTGwkTjrAt/0O76sixc/fWgCYVbcI
	 NWpGhh0jj1ZFLsADKPJ9HHVfYXw8bNMR2CjY3l0Cl9ayyCopZPtI27Kxjjc99B0SPl
	 vDacqsD2plo1DPJxJ6v2C3QHN0rp+wrENYXidp/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1124/1193] net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()
Date: Wed, 30 Sep 2026 17:30:08 +0200
Message-ID: <20260930152459.210466037@linuxfoundation.org>
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
@@ -1072,6 +1072,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx
 
 	spin_unlock_bh(&ct_priv->ht_lock);
 
+	if (rev_entry)
+		mlx5_tc_ct_entry_put(rev_entry);
+
 create_counter:
 
 	shared_counter = mlx5_tc_ct_counter_create(ct_priv);


