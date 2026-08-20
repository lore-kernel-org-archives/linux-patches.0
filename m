Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE29236A37A;
	Thu, 20 Aug 2026 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238514; cv=none; b=JL0+hlvaTkJ5gzFoizwTVYv8GW9lvqCkyVLiSeV4dSYzlrYa6L/jGrD8XUhha4QKtezjIIIsqHzkTJg+P6hwHb0CzcHU/nMdqnZodY8eyeukCrtHGywbukmUJnMnDeCcl6eWi/39Lqr/C2ttGfJxEmSvBdOYz+V5P3N5+U0jjgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238514; c=relaxed/simple;
	bh=fpuLcqRdZp0UtcZDAvfBItTxbRpw39lwL9Ay73FJngA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/vTts50whEslJX3UIQ8ki553cXlChFk5KYfWLIDYJ7oUYUxmiJCyLkuB0NEnEQaDq4u9JmuXRMxPPapcANutKi6BMQD54kzsx3dIfBV/vGRadsVaNTuZVniMnVuvMJINpPnw9rvYF/cLBsJDqRhJjHDbh0fbXv8OxfLIoWthyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjdM6aHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjdM6aHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252B31F00A3A;
	Thu, 20 Aug 2026 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238513;
	bh=0aGGkrqMh0Gt+8vK2v0RNF67JVpHWank9cbnC4NyfNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjdM6aHcs2AefQw426+Hoj8PsV7yO0kY7ZJ50q+bAEIV6L96NgorIJ7dr1+UknWE6
	 I0ANvVzM6m6UEIkQHMFyQsoWjupkUHyz/rovCSCKSbVA6/O6h7EUv66PmgfJejelg6
	 VCrsSnd4CmtFnJErhf8ZY0ezTPbmIdHBjJC2rU0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 173/228] ovpn: fix NULL dereference when killing missing key
Date: Thu, 20 Aug 2026 16:55:15 +0200
Message-ID: <20260820145249.950871428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit 41d44ac7a61e2f74453af40d4fe1b82af9ea0ada ]

ovpn_crypto_kill_key assumes both crypto slots are populated and
dereferences each slot before checking it. That is not guaranteed: a
peer can have only one installed key, and the kill path may be asked to
remove a key that is not present.

Read each slot once while holding the crypto state lock, check for NULL
before looking at key_id, and only replace the slot that actually
matches.

Fixes: 89d3c0e4612a ("ovpn: kill key and notify userspace in case of IV exhaustion")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/crypto.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ovpn/crypto.c b/drivers/net/ovpn/crypto.c
index 90580e32052fb..2e95f29514fc4 100644
--- a/drivers/net/ovpn/crypto.c
+++ b/drivers/net/ovpn/crypto.c
@@ -58,15 +58,19 @@ void ovpn_crypto_state_release(struct ovpn_crypto_state *cs)
 bool ovpn_crypto_kill_key(struct ovpn_crypto_state *cs, u8 key_id)
 {
 	struct ovpn_crypto_key_slot *ks = NULL;
+	struct ovpn_crypto_key_slot *tmp;
+	int slot = 0;
 
 	spin_lock_bh(&cs->lock);
-	if (rcu_access_pointer(cs->slots[0])->key_id == key_id) {
-		ks = rcu_replace_pointer(cs->slots[0], NULL,
-					 lockdep_is_held(&cs->lock));
-	} else if (rcu_access_pointer(cs->slots[1])->key_id == key_id) {
-		ks = rcu_replace_pointer(cs->slots[1], NULL,
-					 lockdep_is_held(&cs->lock));
+	tmp = rcu_access_pointer(cs->slots[slot]);
+	if (!tmp || tmp->key_id != key_id) {
+		slot = 1;
+		tmp = rcu_access_pointer(cs->slots[slot]);
 	}
+
+	if (tmp && tmp->key_id == key_id)
+		ks = rcu_replace_pointer(cs->slots[slot], NULL,
+					 lockdep_is_held(&cs->lock));
 	spin_unlock_bh(&cs->lock);
 
 	if (ks)
-- 
2.53.0



