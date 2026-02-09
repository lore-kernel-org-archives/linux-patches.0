Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CB81DE8AD;
	Mon,  9 Feb 2026 14:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647567; cv=none; b=B566VZlC8nQotqc76w4gL+C15hXAbszn3pEOIjqB5NygEp6OG0DbIbkYCwwg741NNiyo//FsAwc83DcV4MWAfhtUfb0O/9PVydACPsWLRPSInjayZomAZmlxvE/wwF/B7MGcic4RpTHdpxc3uSGMhG+OqBXGe64vaJTNRRLwQ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647567; c=relaxed/simple;
	bh=6ykED7Qb6L0ek3o0XWlLIQpU1DjofXnUmBHmioIIHME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxvX9Kk9c8BHuqFMcitbNcijTLzWhbct5s8QLcVH60SQJp3G9JzYhGVIRFTHENTOdNFIlWqbolFgLxuQxXqaEzkbAUYHG9td4CVqTi2Zo6yr0R4sMiEZHfeAwnjW/n8T+sho8BrOHRPCt75gL1Qiqk3V4Qp8OHRy9rBPVTXerSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euU7OVeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euU7OVeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECBFC116C6;
	Mon,  9 Feb 2026 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647566;
	bh=6ykED7Qb6L0ek3o0XWlLIQpU1DjofXnUmBHmioIIHME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euU7OVeE3tBNi7l9eWSENv7+DNGKilql/N5ArHi7VYVNv+rBJT3jh+8lvfYvS73FH
	 l2HgloZeOcbNhAFdhyNtNgsmOxT7pEOlMcWCutT0gDYZXNp3D3xWysK3slng+7+CG0
	 IiUV2KPazCqsi5tZ6mdTTg6nSiwpj76/KM1LbIUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/175] tipc: use kfree_sensitive() for session key material
Date: Mon,  9 Feb 2026 15:23:32 +0100
Message-ID: <20260209142325.507218818@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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
index 751904f10aab0..970db62bd029b 100644
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



