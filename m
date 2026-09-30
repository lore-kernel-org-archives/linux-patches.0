Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2A45187F2;
	Wed, 30 Sep 2026 18:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792610; cv=none; b=qimDSIARowxaJRGhcCVjHy+/RK42GOH40k5UfbUtkC+M/gSh1+GmMKRfRmhIlV6EA8xOH4QZpLk1xxxOZQjBNnGfm4qnMjfIsmMiefJUoWlbfqDUwpYl85vMnVgGd0m+sOqmshFAflkN4LFfYOVl+9iDbn4oP8F3b6OV+Drqnms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792610; c=relaxed/simple;
	bh=z+a0e+AZ5m+3gSuJOo/eNx+RljcwLAtLwCO2kps029Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kyqee3XSclfO6clphRUNBe4YPBZx8+l3h6sgJtr2Fjf+3+T2nXDPesxMONaxAvQR9Qsv1jHoDQu9SRcT5pfkf39qYXPkpaS8wcPuDI4nzTSK1C+E3N5qM1QftI96jvQsggWk2I26TcdJOTZ+uaz+vTWbPEQKvqCxXZManWefhqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0Uhf37o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0Uhf37o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF3F1F00898;
	Wed, 30 Sep 2026 18:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792607;
	bh=lZsx2HVmI09SwPS+3eUbnfI/9IEK0iV7csa+fjNJKvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0Uhf37oKAoAbM2tPSx9ofs0N2oBP71e8TldXe8pZ7d8G/oHc4kAgKVnrM+0AxBq2
	 9XM0N3qCMOc/K/9FaGsTX1NLyIKnO3K/wezdz+p+27aCOdns5YZxxf7OBUXt/EUGN/
	 Wv7BOPC1PJDDFlpvJKUDDvEceya8FpNysmYYTTDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 716/752] net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()
Date: Wed, 30 Sep 2026 17:29:46 +0200
Message-ID: <20260930152413.718377502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -944,6 +944,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx
 
 	spin_unlock_bh(&ct_priv->ht_lock);
 
+	if (rev_entry)
+		mlx5_tc_ct_entry_put(rev_entry);
+
 create_counter:
 
 	shared_counter = mlx5_tc_ct_counter_create(ct_priv);


