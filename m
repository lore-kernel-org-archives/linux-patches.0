Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFD318E025;
	Tue, 17 Jun 2025 16:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177097; cv=none; b=hFPLwZ8pGGzT8P3RlRXCKl61L8NB7Gecb4sCLRdUCR7qBN8m6gXJg/tZcCKsVrnaC59k+7TNIDo5KoRFhA/7V9ZqFI/km8Zp1bBrv9BpbcjxSiDoOvyUVKTQeRF7oYAuubjb7iVKFhIXaa6vH7TJFt7PQ6hi6RcRs2rt9pm0U8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177097; c=relaxed/simple;
	bh=qwDEhIv+07Nm01vx0LDN9LqQmO3gLcx59A7mPfhnVho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbfLH5kM1eX4E3HwjsF0JjGznG88FelR+H6zS35pmKAlTwUyJ8eMqq3PE4HqO6O45DDg3qDcoqZwZ9GfwBJihNODHGoWoiraPuCfKLqx7SiPvL5zKJXKMdNXDphe2D9PVKA/pXyOP2TTTF5iXHiinP9DsTb4k3zjON4mvUzVPcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3SzGmEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3SzGmEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F14C4CEE7;
	Tue, 17 Jun 2025 16:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177096;
	bh=qwDEhIv+07Nm01vx0LDN9LqQmO3gLcx59A7mPfhnVho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3SzGmEo84NmCz1CKLlGfxbmxxGqFSuV963EPekHPSWkA4qf8JqkEvgut2TbDHXp1
	 Uxt+J0BHVBVuLI65nwWhGRnsINVlZaDyxBUWR6M9LMXtNBwBzuFZqkgmFOhojS1N1g
	 XSOsZkijlnRK1/LmxmU/GWZasfO7JMPVsevIiTLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Sean Hefty <shefty@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 238/780] IB/cm: Drop lockdep assert and WARN when freeing old msg
Date: Tue, 17 Jun 2025 17:19:06 +0200
Message-ID: <20250617152501.149575862@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Dumitrescu <vdumitrescu@nvidia.com>

[ Upstream commit 7590649ee7af381a9d1153143026dec124c5798e ]

The send completion handler can run after cm_id has advanced to another
message.  The cm_id lock is not needed in this case, but a recent change
re-used cm_free_priv_msg(), which asserts that the lock is held and
WARNs if the cm_id's currently outstanding msg is different than the one
being freed.

Fixes: 1e5159219076 ("IB/cm: Do not hold reference on cm_id unless needed")
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Reviewed-by: Sean Hefty <shefty@nvidia.com>
Link: https://patch.msgid.link/0c364c29142f72b7875fdeba51f3c9bd6ca863ee.1745839788.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index effa53dd68002..e64cbd034a2a1 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3786,7 +3786,8 @@ static void cm_process_send_error(struct cm_id_private *cm_id_priv,
 	spin_lock_irq(&cm_id_priv->lock);
 	if (msg != cm_id_priv->msg) {
 		spin_unlock_irq(&cm_id_priv->lock);
-		cm_free_priv_msg(msg);
+		cm_free_msg(msg);
+		cm_deref_id(cm_id_priv);
 		return;
 	}
 	cm_free_priv_msg(msg);
-- 
2.39.5



