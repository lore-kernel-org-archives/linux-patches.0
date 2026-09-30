Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4355328CE;
	Wed, 30 Sep 2026 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793587; cv=none; b=govELD2voN/NXjM2IfO3egkmRvj14GrxTSLWyXoW0ju0Ka7HTZH/l4Qpq+lnYkqpp9/iLuwI3ubcxce3Oxt8u4csoo6AMfDUwwRNumQy+8FYhDTQiETmN9/cB9lu5iPWyTv3pk4RiwJHlgQvmD41jYTlOB8Kmq7oDsT/aLgFACA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793587; c=relaxed/simple;
	bh=t257BW6LgY75uHIjTWvwqtlSAC5NiKrLVtc9Nyv3Hac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMdEzSXL3fxo6PmJW2UDFOPlSInOgbq3zvLRExdksRB9DG9VNtbKAVHOmWhRsIxGrg/B/ukCi/LWLp7dzB73EVySddz+b9fhHTe35XPilzVKU44OLR7JJoQOPUy1LcEWX++qk2gP9cHjKOlZlpiUgR+nnWeO7EkAXN6p0yZJD78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8qwhfd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8qwhfd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A27A1F0089A;
	Wed, 30 Sep 2026 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793585;
	bh=tJxQ5ansNKtaUkcv6PeqGYmD8LBr084CYQbljS8BsJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8qwhfd+74KYrE8HAmZGyx6ZYfKBXOtZP+wc27vw/VBTuO3gtaxe0AGgy1Xw0/ANB
	 8GAZjABS5URI/H8uVY6AZmbUus1sAmqPB40YnFVnTqlCgl0EJG+Pj+8qVy6DY656iL
	 AqbM65f1PK7363U7Xpt8a/f7XEHkI0sa2lTjq9RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 270/395] net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()
Date: Wed, 30 Sep 2026 17:28:52 +0200
Message-ID: <20260930152346.514017366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


