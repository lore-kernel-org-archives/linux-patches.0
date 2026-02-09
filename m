Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D31F37BE65;
	Mon,  9 Feb 2026 14:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648266; cv=none; b=YV+OYvqXPeiWUx2ig48bAdF6nBl51UveQSosuOYlXrfLCQ4x065a0pALIkHGVAXPQ6BEKUk3Ci0sPx1Z/7HKS3TFOPpTLgB6Acm4SogkUANZKyQkPMqlQSVe2tjfd4aD0MqcNidggXhQNRw89yBexLFrInNAuHqVtb1OB1SgR4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648266; c=relaxed/simple;
	bh=xgUVAtqAQmHGm3jZXFjyqWrw/MOKDuTpCF3b0MvxC7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StJD49Lo+GSYARWC9PWdIm4ZavMpF6D475rK1niIDjRBM5d0LVkJwMUmxLUUhVv0cHiHcYuCjlLh2VHn7YsTTeacff0VyyhJ+iYeXmF3YUZU9LupBOTvURQS9w7tXhAvI4znoz+52Uju2dGhtf5ZdWsYQqev7mWZr2bKLHzPjm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDRderP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDRderP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EFBC116C6;
	Mon,  9 Feb 2026 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648266;
	bh=xgUVAtqAQmHGm3jZXFjyqWrw/MOKDuTpCF3b0MvxC7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDRderP1RIl6mMiLseCUaqVZQUarkOzkt2Pcbp1ihYR8STCuSBMC67F5smbELzDug
	 VcBaffNJjAYc3bwDqcokRgoLa5/i8Vl/PxnDO4vVRl5qa1zBI4xHhrxj8eC+sjNmhr
	 CAGFhxqBa8n+1teD1sfxyd0iBrnQqUAeA1vjebfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/69] tipc: use kfree_sensitive() for session key material
Date: Mon,  9 Feb 2026 15:24:23 +0100
Message-ID: <20260209142303.903887584@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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
index d52829c6aa472..0e84d86f75fe4 100644
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



