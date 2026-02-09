Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B63B36BCE2;
	Mon,  9 Feb 2026 14:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648917; cv=none; b=bM9Fcn0hNgbPnRvX3wXtU2XTh3r2BugwakdlEA+DHfLVzYMlno5CJyF45GBjoMUNLglOZzb7K9mOev6JGaXyOe0Iv185IpK0SsJEn6GUrI4ovoYysoiQIF73ymDSYL+2E9r8YNi/AI1oLzoFarqTTPhgtwqE9nCrYTCH9vp811s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648917; c=relaxed/simple;
	bh=KeAgDelqZpzXO6rMgDoxxGqkWpxPTmmXZ3r9D9j+1QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYg/77Ktu3ZLFxo8xE4UVfWEdRNqM+Xzq5AhqxSUJoO7odQG+jliliuZseOjIMhESgrRo+vlybz8nbk7ew6MXSbntewCuB8M5AWY2LqgfCW2HkGyNGw+DpzdLhnNlhNI7t0pWq/4WPggDk+L6nuVJP8w/TCBoBNVJtUzFAPi4lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt6WPUFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt6WPUFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F898C116C6;
	Mon,  9 Feb 2026 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648917;
	bh=KeAgDelqZpzXO6rMgDoxxGqkWpxPTmmXZ3r9D9j+1QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt6WPUFgpaW45SE2RKAVd+eHtUdVAKq+zk9YXjvWmToqyRxSFGhWqpgteDqRtQLgm
	 mniegbHypsQJxpnRtpq0EbRagHteddDIadSXBAw/eDX1OWdzUOOV5jXze1a93H2TZJ
	 04v7tLx6Yk4ttVLXOGhul0tytn/SIozVCSc4mUm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 52/75] tipc: use kfree_sensitive() for session key material
Date: Mon,  9 Feb 2026 15:24:49 +0100
Message-ID: <20260209142303.719129198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

From: Daniel Hodges <hodgesd@meta.com>

[ Upstream commit 74d9391e8849e70ded5309222d09b0ed0edbd039 ]

The rx->skey field contains a struct tipc_aead_key with GCM-AES
encryption keys used for TIPC cluster communication. Using plain
kfree() leaves this sensitive key material in freed memory pages
where it could potentially be recovered.

Switch to kfree_sensitive() to ensure the key material is zeroed
before the memory is freed.

Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
Signed-off-by: Daniel Hodges <hodgesd@meta.com>
Link: https://patch.msgid.link/20260131180114.2121438-1-hodgesd@meta.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index b525e6483881a..22c07a270ed40 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1230,7 +1230,7 @@ void tipc_crypto_key_flush(struct tipc_crypto *c)
 		rx = c;
 		tx = tipc_net(rx->net)->crypto_tx;
 		if (cancel_delayed_work(&rx->work)) {
-			kfree(rx->skey);
+			kfree_sensitive(rx->skey);
 			rx->skey = NULL;
 			atomic_xchg(&rx->key_distr, 0);
 			tipc_node_put(rx->node);
@@ -2405,7 +2405,7 @@ static void tipc_crypto_work_rx(struct work_struct *work)
 			break;
 		default:
 			synchronize_rcu();
-			kfree(rx->skey);
+			kfree_sensitive(rx->skey);
 			rx->skey = NULL;
 			break;
 		}
-- 
2.51.0



