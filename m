Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341DC3FB1B;
	Mon, 23 Jun 2025 21:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715822; cv=none; b=fBDSRwdvhyZomkSHJ/qPXCS5bixp1WLeII2GrO1iOwTWDi7IZ1NohTrOk1sP+XvdX54UU7NiCoX0OA3OknIUNsMwHH9ysCQOxNq1vaT9XlhyCQybkhbi9M4gZ4Nlqie7ZEY7j5zZUyf6+fS/mchTcRBE0LRSz3my1Vby/5yiRrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715822; c=relaxed/simple;
	bh=P3OZNLzTzYud0PwJzMVaHz9TwTkLevChHw5qntH3iag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfsAdHpie1Jr0XTTCt5fMyDVWfPb+70gvaeH6BPvEtiNCntm6KdwbUDrKMuawJwp+0gnbBAa4O0gMxZjN0c+tAUyWBdW9wpxiYzUBiPguNHOyMJjInsfc/s2qS9cT7q/Rn+7jKHzT/PycQDn31CPSNy4CWzyNZ4gRPu0o3ySiiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVNEPwP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVNEPwP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD769C4CEEA;
	Mon, 23 Jun 2025 21:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715822;
	bh=P3OZNLzTzYud0PwJzMVaHz9TwTkLevChHw5qntH3iag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVNEPwP4seArO0Ki3v6PW9LJVxUtnAhp2GUb+kkcdFrf1FklMhIxCnCnE9ddsgKM5
	 Ed+cByYr0pkadj64/P5yutDHKnBGWoggMU6TVAuPJN66iD0bJm+lSVyVRIOqjOtOe0
	 YM5sB2BT8Er5tvI1agVTT6dmbOTAJt6BvqTzSEd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/411] tipc: use kfree_sensitive() for aead cleanup
Date: Mon, 23 Jun 2025 15:07:30 +0200
Message-ID: <20250623130641.348001400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 07f35c48bd3a2..b525e6483881a 100644
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



