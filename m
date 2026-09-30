Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746AB509F0D;
	Wed, 30 Sep 2026 16:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786691; cv=none; b=aIpNX6WDJzul9yajqqO3eDglvabcIu5EXklE+ZxGftBhcsOMngd9ICHaSMqARab9XYUKUnkeQ152ZI96rjclFeSMcH4JH1+QRpwJg4zauUc6V2GStoCkZLaRIXLZmw8KCW3LS8bkyTD5SnmBe7KOwedb32Ebeqm4YV7leKLmbBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786691; c=relaxed/simple;
	bh=hUfNCzPhnwMJVJc2FwLHaG/hjWdXCYCeu6MavZSiEiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5y7Z4wLmCsx/0KUvCeI/b3jAhcpAlq8WkqMCk0zH1Pj3gTM7x5EVWOyL1DZNLBIDo/MTCULQy4gE0wGflVj+rQNgjwt8M9VqDodGidd0lirRiB3Xp2Hud01J9BxZA3JCCRYTYnWLVgNda3OHTs5iFFuIbD256BNyv4LpTNliqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yb1h5ADA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yb1h5ADA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED271F000FF;
	Wed, 30 Sep 2026 16:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786690;
	bh=V4rfNIe6DTHJBBD8atutlDWJCW4TOoHEsvpkfCzOucI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yb1h5ADASSlZMF8lULp6Zhojk6Fx/fb9Bbp9gdbNYIPzVbTlqDc/wwvvfC6cBly+e
	 NXW22w6tzN5O1hPTEX1Rpl8p+xnWdrhb3in37url3u6KGvFWocC5DwJlVQ6ArXFk40
	 ty6iLA4JHAODNuNi3BskYpMijhBVXK59BMsnjXlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 951/982] net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()
Date: Wed, 30 Sep 2026 17:28:07 +0200
Message-ID: <20260930152437.163133883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1016,6 +1016,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx
 
 	spin_unlock_bh(&ct_priv->ht_lock);
 
+	if (rev_entry)
+		mlx5_tc_ct_entry_put(rev_entry);
+
 create_counter:
 
 	shared_counter = mlx5_tc_ct_counter_create(ct_priv);


