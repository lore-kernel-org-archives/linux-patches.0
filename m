Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE981DF98B;
	Mon, 23 Jun 2025 21:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713272; cv=none; b=PV5Fwg7Of5fYq6IHsv1ooc7Wuv/uM7JfDw87Q5AQWvkhDxFBpTsu2b14YRNUoQ9itZQHoY39ON4HgyZi+xnH2ew9m2OTVSnQdMwXwoi/f86e1cuoNltk3QCEBmQWsZxet7gYDxpdwOfcwD6Aox0Bq7upVjZ/HncI1BTg62Zr8h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713272; c=relaxed/simple;
	bh=vgsja0pqPyTp0x0s0/cSlezVo6Nbd23SNWs3O1hAzPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7cXXhyghx+FsD6EF/1aKb4xq1hg/bL6/KGX//5MTiLiI5p/NpaPz9Yx1YHsFPrqx0ZkDOohlRDMUdxts9MNaE3bqIW2v/ZzWSd/9+u4lHPVThcY0/+cokQ4n8dKZDC0BYvYKMcND9V4LNw9n2GDqtmOVwtOp9MNJf9iWOCT+p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wlz53oHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wlz53oHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5535FC4CEEA;
	Mon, 23 Jun 2025 21:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713272;
	bh=vgsja0pqPyTp0x0s0/cSlezVo6Nbd23SNWs3O1hAzPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wlz53oHJyZtK5PF14zRfyci7lrlQ+/TodXyQnsh2fQ6QCubWMyO7jIPMS7Tl8GrU8
	 pVkUJ7oa8rSjyntScalmHXX3PtKp3Y6zNCOF9OnLF0xDHYahU9nA48q21HiutteKmn
	 vRTAMz7C4h50rr6x+Whsyry9jPnsiw6aR0RrxcP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f0c4a4aba757549ae26c@syzkaller.appspotmail.com,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/411] net: tipc: fix refcount warning in tipc_aead_encrypt
Date: Mon, 23 Jun 2025 15:04:18 +0200
Message-ID: <20250623130636.402005532@linuxfoundation.org>
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
index 35e0ffa1bd84b..07f35c48bd3a2 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -829,7 +829,11 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
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



