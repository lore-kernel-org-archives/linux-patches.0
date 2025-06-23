Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061472472AF;
	Mon, 23 Jun 2025 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685852; cv=none; b=uFac8iY5T53zwy+9G6bCL0wY+hpza5V0/6Ad5G2+JemH+byx6VEPxuR+jpFPustFWpaMdI7ONqLg/l+/sf67t75wZlsnK2Hex/Tra10P8eMVRGBUpnwD+7CDuZzNmhM6G1fSL+aLTRQ1+rVymMi83Igygk+LPFqT71Y1wRG7wZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685852; c=relaxed/simple;
	bh=7r44JUFSkghFsH67xeVCuwdcba5xNYd/QI/xxW9kBzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbKf9kvWK/zS0AVdkSejsRnU5MP9SxFYy+tKJJa07wVfZ6OJ09M610XutdDzTPaebtTWrYvWnRMSVKsq/Xo20BTJr+FDz+6W0LdISkZyEERQLXdUNy9PohrOd7FTvF3vvcczZWONxmylbdT+DFK62enGhFfmvZC3wffr3wsDDzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NK/TelK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NK/TelK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C28AC4CEEA;
	Mon, 23 Jun 2025 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685851;
	bh=7r44JUFSkghFsH67xeVCuwdcba5xNYd/QI/xxW9kBzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NK/TelK/H4oFdKF4w+UTAvu2vw1NC3+0MB6VUIPyEtf9WaW9WOdNOm+IGJNH0AH9b
	 UVURpYDUJXOLFyQAfO4lA7njxEwrP9ip7kmLWiZ71UZp7WEfK8mGdAvTgj8DKqtYsM
	 Ozkw0MD9IHXkwHQmsN5ZCZ+HDBSNU6L90HHT59T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f0c4a4aba757549ae26c@syzkaller.appspotmail.com,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/355] net: tipc: fix refcount warning in tipc_aead_encrypt
Date: Mon, 23 Jun 2025 15:04:58 +0200
Message-ID: <20250623130629.705706690@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 159d891b81c59..3b26c5a6aaaeb 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -822,7 +822,11 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
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



