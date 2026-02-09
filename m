Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FD237997A;
	Mon,  9 Feb 2026 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648739; cv=none; b=p/psDtneL6Mj/ujUWks1Rc6cH1oI+MK4ppiXGf4ZUiGHdsJJ6AKiZYeuCImfV+xo6/rpBkHHmuNQSSfpDT09LreglVZzJYTIc3XuLurE5c0Th57W0wLNZ8lEK99L57RUPGKvm4aEXWclFMCivm/5soS+JKo3jCJLrqThVhP9Jb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648739; c=relaxed/simple;
	bh=ChpAUU99oreo/xuRmWfDlRqUKO/hLysu9osVy7WI3ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gsm7mq3Ad4i9Wb5CAE5dqN6qMkqBb35ZXGDngzEP2yOuVA1x7fRk89kKnMf1BkW0MSbd++i0kO6toRVyMoWAusQXdN4UkqZp9extv1jYRlZXVRbEv528Q6ktmhRBMuoKDqfYx/hZrv0qcMynwsT8DhH1MlkWBysM7Kr0QHPhCqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dumw/hs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dumw/hs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8449DC116C6;
	Mon,  9 Feb 2026 14:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648739;
	bh=ChpAUU99oreo/xuRmWfDlRqUKO/hLysu9osVy7WI3ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dumw/hs6M+MwqI8jcEol4zq2bPfxRGkvHxQz4GUmMGdvAQ8/hHN7kwfHRm1C6iIcZ
	 YjNF+p0sl3U5u3MTG8lQOsm+K5OMCApztkWdrTkSZ1vyjJb4/IYsPN0uokfybzW6Hb
	 jBiILJNmNgN5DLM49DXc3B5RoXwXHA4GPK34h19Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/41] tipc: use kfree_sensitive() for session key material
Date: Mon,  9 Feb 2026 15:24:50 +0100
Message-ID: <20260209142257.864186658@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cc409d55e1576..42e7d2bc78302 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1223,7 +1223,7 @@ void tipc_crypto_key_flush(struct tipc_crypto *c)
 		rx = c;
 		tx = tipc_net(rx->net)->crypto_tx;
 		if (cancel_delayed_work(&rx->work)) {
-			kfree(rx->skey);
+			kfree_sensitive(rx->skey);
 			rx->skey = NULL;
 			atomic_xchg(&rx->key_distr, 0);
 			tipc_node_put(rx->node);
@@ -2398,7 +2398,7 @@ static void tipc_crypto_work_rx(struct work_struct *work)
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



