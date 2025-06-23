Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAA91DF98B;
	Mon, 23 Jun 2025 21:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713185; cv=none; b=RUOXoSmIS6zN339pYWxHeTyS1cP5lG2M5QKFbcNtcTKEhjjgpdcEECk1aWTxWkKnbRTRlw1LlBLg2PGku1V44PnJ0FVCykDtnySLQXQaF4RgWWWfkbfMgWp/v3NMV3j5wr4LRU7k4NZrirrosurjOsj6zc/dvxp9PDGHx6SiPAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713185; c=relaxed/simple;
	bh=kzIIdmfyzMg5RLEGQqKf6JqF82CnAM42Hus5AVZyd+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enKAkm+N02hqVSIE0BstKuCEtZKKIChNEXux6000fgFpm4+DvlWEgl1EB+xcCJtRUCLCqyhEAplOFnsc2zkEpBl5ZbTna4aJSw5mdDRMXu6EJ7Ja9YYlhyEFuRtTqgCLPbYX0q4YC0IhIyZGYUclkNmuw6/l/MUZLv7re8hPyWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wg203deQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wg203deQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D6DC4CEEA;
	Mon, 23 Jun 2025 21:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713184;
	bh=kzIIdmfyzMg5RLEGQqKf6JqF82CnAM42Hus5AVZyd+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wg203deQpg+0Nbv00EN37WD7cmIBpayccfuev1Ttw+JTZyK6zTNNNosz/LaURFpgB
	 fAEUVVCqymF64j++DVaH1h09OWOPGTRakb6Zvt4F1ShZo15yWKLStkEL56kg/CgLtm
	 bfAmYctC7jn0z3rWZCQHsgNIQ43/z9Xdhr153/SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 313/592] tipc: use kfree_sensitive() for aead cleanup
Date: Mon, 23 Jun 2025 15:04:31 +0200
Message-ID: <20250623130707.863381508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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



