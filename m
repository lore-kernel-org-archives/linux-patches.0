Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F0E2EF28A;
	Tue, 17 Jun 2025 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176167; cv=none; b=Ga7wlAJbwZCH9XPqO/VEwmeoOiHZsFQNHgsDbHAZ2igoDKMHQGr7OhTYWs/xpCr7plMGBEGXXy72SYRLGLMPEYoAtm/VhjNuQs0CZzvcob5NASohKOfcO9O52jteQGnoDPMNgVk0Xx855WOebnjetBlT4YIoNTtP2HiP6+v1dR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176167; c=relaxed/simple;
	bh=DBY+sGN/MtYQOCdQiRxGXE/hvMUmo3cTMFwNBFjrSv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JACc809wD6xc4ZzyX9c0jYJCvLkqVlwLP89Yf+wOsNZ8bUlqiOBgzk1XyugOIs/+C5JSf5rHOXnWo7Wq/Xe5QavH1KK2z9W5r1bBWC/zaE2WJpyHv014ihSsnZtScRdyEBjkGNfhHcre0bgddLuNZ88CkSA1Gat2mP1OPTyCtn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXFZCdke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXFZCdke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558E7C4CEE7;
	Tue, 17 Jun 2025 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176166;
	bh=DBY+sGN/MtYQOCdQiRxGXE/hvMUmo3cTMFwNBFjrSv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXFZCdkecL+VEQ5tt7+5TQ4HwsRrxoXWb+f3+L3z5bLsQKE0wpbELI3g/v2oPaYBM
	 Gb++oOvfILMwoRuYDvcsqqzGO0Ozmv+NGdvquvcJx4HOxY1ctfMgz2ZkRGdPOVs6g4
	 CO0ZFHphlqpOJRkXZkyIjS+eFM2oRjYyWNF0OyHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f0c4a4aba757549ae26c@syzkaller.appspotmail.com,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/356] net: tipc: fix refcount warning in tipc_aead_encrypt
Date: Tue, 17 Jun 2025 17:26:00 +0200
Message-ID: <20250617152348.070114815@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Charalampos Mitrodimas <charmitro@posteo.net>

[ Upstream commit f29ccaa07cf3d35990f4d25028cc55470d29372b ]

syzbot reported a refcount warning [1] caused by calling get_net() on
a network namespace that is being destroyed (refcount=0). This happens
when a TIPC discovery timer fires during network namespace cleanup.

The recently added get_net() call in commit e279024617134 ("net/tipc:
fix slab-use-after-free Read in tipc_aead_encrypt_done") attempts to
hold a reference to the network namespace. However, if the namespace
is already being destroyed, its refcount might be zero, leading to the
use-after-free warning.

Replace get_net() with maybe_get_net(), which safely checks if the
refcount is non-zero before incrementing it. If the namespace is being
destroyed, return -ENODEV early, after releasing the bearer reference.

[1]: https://lore.kernel.org/all/68342b55.a70a0220.253bc2.0091.GAE@google.com/T/#m12019cf9ae77e1954f666914640efa36d52704a2

Reported-by: syzbot+f0c4a4aba757549ae26c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68342b55.a70a0220.253bc2.0091.GAE@google.com/T/#m12019cf9ae77e1954f666914640efa36d52704a2
Fixes: e27902461713 ("net/tipc: fix slab-use-after-free Read in tipc_aead_encrypt_done")
Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20250527-net-tipc-warning-v2-1-df3dc398a047@posteo.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 8584893b47851..79f91b6ca8c84 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -818,7 +818,11 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 	}
 
 	/* Get net to avoid freed tipc_crypto when delete namespace */
-	get_net(aead->crypto->net);
+	if (!maybe_get_net(aead->crypto->net)) {
+		tipc_bearer_put(b);
+		rc = -ENODEV;
+		goto exit;
+	}
 
 	/* Now, do encrypt */
 	rc = crypto_aead_encrypt(req);
-- 
2.39.5



