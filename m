Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C007285073;
	Mon,  9 Feb 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648541; cv=none; b=YcZLuWCEX9BIeKgE6EvAtNMMGTaK6+BTvcJuJe0/AVbPoSJSa4xBcLblGI2krvO5cPo2eXtmC9dOwWS/dl1f1PJEz9lW0sNwg4nT+xVViZozXw54FGuKL+KyUl2iVIptbVJowP7B2E+hPhh8btYQvn8cYZgmhaU4TKtKGZ+N+Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648541; c=relaxed/simple;
	bh=XBF9yqv+ypediRNL/wymj1llc1aU5s40HOkApkdLnhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFnkcuTJjR1PSwloF4Fa9GYUzSR1lVzSWeS6S40eEZzPJxx4LAVtlpzvtkeIyXzJwoE8BQOcVU/qeW8kIt1Oj9g7kRQ+Uw6hs/+QHhDVi6KFJmg6iZKa73c6IqVWZGzyPopsomabfEfzYA+joXQhiqxO6ry6Y9AvN6KfYJ2Gtho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdyHoxxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdyHoxxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C194CC16AAE;
	Mon,  9 Feb 2026 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648541;
	bh=XBF9yqv+ypediRNL/wymj1llc1aU5s40HOkApkdLnhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdyHoxxsueWNUdRXOSIkvfxnwg8RBOSi/oAFJAhOjoIvW4PMf9grxdjw8JqHm44xS
	 PLChjPwv3GVVYuWniEk2+SiLZ/2AOl2VOVO6XxdVIrabPV+NNXvCgeOv8ztwUsj2zX
	 Dp8ZylTjPu88ERnDXAL/W9r8W0+F1XmC+84kG99k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 69/86] tipc: use kfree_sensitive() for session key material
Date: Mon,  9 Feb 2026 15:24:32 +0100
Message-ID: <20260209142307.260750981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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
index ea5bb131ebd06..2721baf9fd2b3 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1219,7 +1219,7 @@ void tipc_crypto_key_flush(struct tipc_crypto *c)
 		rx = c;
 		tx = tipc_net(rx->net)->crypto_tx;
 		if (cancel_delayed_work(&rx->work)) {
-			kfree(rx->skey);
+			kfree_sensitive(rx->skey);
 			rx->skey = NULL;
 			atomic_xchg(&rx->key_distr, 0);
 			tipc_node_put(rx->node);
@@ -2394,7 +2394,7 @@ static void tipc_crypto_work_rx(struct work_struct *work)
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



