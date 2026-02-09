Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AF037C0F8;
	Mon,  9 Feb 2026 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648011; cv=none; b=Q4u5oNy/FTgEQhxoSmUiuctuyCUYJs7AOOTYuG4b9n7+3cBjOnydGf4TFmYzVyE93BSQ/lLXmKZFFMClS2hRRnYTFsVAuXdRx1xWj+xZFtwXXACqDBmAE7H3emvQDR6JevcckBIb8U1H4v2Alxc8BzGq8jxdKZsLkWWKS6ZkdHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648011; c=relaxed/simple;
	bh=3vuKwk64qI4phz5u+NaVZtaQh8hfWjwOzmzitSUesZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPDDFXqxiVHY+ZHkAx/iSb20lFAPcd8cRNOUr7H7IoK7TD5TMajIXxy7n6067CVFoJThZ8Eb9PJ8lw0wbx0iz2G0qH86whHEAlJih4UiJ8zfSaeC7CxTSsk8s0RXyux0vbGDfHZVq/huQbDCtwmjc7XJ10pUOGDMh28NdQqmcvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrwOrEcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrwOrEcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96E2C116C6;
	Mon,  9 Feb 2026 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648011;
	bh=3vuKwk64qI4phz5u+NaVZtaQh8hfWjwOzmzitSUesZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrwOrEcqqu8hTApnBKbpskwn5QzgNdTPqUHi2kDkNzJXgje4Vo5e072A7jkLrlEuj
	 RpRBZ64jlSj7Al59wsrL8NOGigHFmhH04mUe4nnWnTOQ7zybItiuobk5W3q97HX2aQ
	 ZywXjVeeTS2DOFEJBbKAML5CIzpR3t8KBIv6WHfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/113] tipc: use kfree_sensitive() for session key material
Date: Mon,  9 Feb 2026 15:24:02 +0100
Message-ID: <20260209142313.523608764@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



