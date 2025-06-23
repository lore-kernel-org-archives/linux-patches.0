Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DA7221FD2;
	Mon, 23 Jun 2025 21:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714407; cv=none; b=ACz0IttV+6JmexZnM4INX7nc82FNEhOS97Dar0qVB6wk/iAhQIH28FzfottQYggAD7ys42MmMccmhKCp+K3GmsJ898pww+wyO4C2oqhwH6spfB9+WTIPeTUIPnlsZC+/NgjQsSRhwR9c72qdhoq7JvLH7hjs0mAb47y9RAejDk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714407; c=relaxed/simple;
	bh=JBDb/Fz3GZwBLdFZcAVtzNeyMuTakAEGwH4nmxdz+O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCDhKzv3zsAueNP1pB8Hw6hdOfkwPqZwLpkLWV3ndHZ4nU6tMnN9eiKtCHRxDZQMPmos+i0h1Rgs66VuHmZ+no6uGJ4EV/kiJTiRk9cXWV4r51WfuyTy3Jp685EnVwXW2GwNHdtqiRydwkIVaLChfiNywGXsVyGQxOPsBrIzIjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz3GpfwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz3GpfwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B28AC4CEEA;
	Mon, 23 Jun 2025 21:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714406;
	bh=JBDb/Fz3GZwBLdFZcAVtzNeyMuTakAEGwH4nmxdz+O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz3GpfwPE3ri1039viege+pnonZS4umbKNnG7x/3BfgHm53HRFJUsfspgNW022+Kh
	 gukNGI1DbMaREKtJ07QTWsqGwbQTH2+AYQWakCEVICdnSz1phyx9E4wy3xCqh3Exoq
	 GBAbf4+94NqPc9LG4rQdgd5I2h40v0beGo8nzz7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/290] tipc: use kfree_sensitive() for aead cleanup
Date: Mon, 23 Jun 2025 15:06:36 +0200
Message-ID: <20250623130630.972159201@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit c8ef20fe7274c5766a317f9193b70bed717b6b3d ]

The tipc_aead_free() function currently uses kfree() to release the aead
structure. However, this structure contains sensitive information, such
as key's SALT value, which should be securely erased from memory to
prevent potential leakage.

To enhance security, replace kfree() with kfree_sensitive() when freeing
the aead structure. This change ensures that sensitive data is explicitly
cleared before memory deallocation, aligning with the approach used in
tipc_aead_init() and adhering to best practices for handling confidential
information.

Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20250523114717.4021518-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 79f91b6ca8c84..ea5bb131ebd06 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -425,7 +425,7 @@ static void tipc_aead_free(struct rcu_head *rp)
 	}
 	free_percpu(aead->tfm_entry);
 	kfree_sensitive(aead->key);
-	kfree(aead);
+	kfree_sensitive(aead);
 }
 
 static int tipc_aead_users(struct tipc_aead __rcu *aead)
-- 
2.39.5



