Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585865;
	b=DQlGAFu/Hydw6C/AiQApqAK9Bg65/ibOjPBrdwK4A60+5LA6ZANVzJES7c9hTdgaeUU1
	 RAUrJPYjp1fJNNEAqvsWWu5UftEC52eARGP8Rh3TUyusB4kPVBZ93ynTng36NxkGfrwBV
	 x8QXe9b+fN+XuM0U8nz2FrISSk+ewbTVuQ819z8wgDFp+zO7IM0htugnUuKxh6432Qu4m
	 6B42RNavGmHEixO8uLp24sHfNP85Kfo707WJwQX3t2NYMtUstKORucVuu3zqlmwWZ7dw5
	 SMxfKBSRSEAXi50A0gQ9l1/VK2x23DZ4GWalWn3JJvMIZYTVT/1O5a07U+PBncW3Pzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NcVt4Oxm8cWCLtmwa7rdGEAuGFc8QsKVCxwTzWhScyw=;
	b=AS6wod/NrM252K290wANAyWx7SBoywO4qCCDBf87caMp+BuMqSOnAYz7EKDo/D6dKjQd
	 xWz2uNmgrAZWmE9ZQ7eKKs4qAc1zvvbmPWFN6HRpVLcVBvT3Ht5cTD029ZFcXSuOX9dW+
	 gvdSQ9yF1yCWpZSRbIjmDxk02+ULE7gtlPhSebOZ0LCPeWLBNOcdpbChny/OPtKhb2uIi
	 /MIQuRFmDt/z5qOpHCXdRnndJ1pRRXw0blf3K/6YyI0TPxIgk8A14nNW9KVOh2Un2meMw
	 G0m0SFhZIZamtEdoozjjRdWVitMLo3J1NKl9K8yzaGcD/+CzW1DGPNu5GmSxWbVsmWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuSRcZGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265F2606BAB8;
	Fri, 13 Nov 2026 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuSRcZGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B051F000C4;
	Fri, 13 Nov 2026 16:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585865;
	bh=NcVt4Oxm8cWCLtmwa7rdGEAuGFc8QsKVCxwTzWhScyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuSRcZGgbUwRXbOi5UfF4+gWIgL161JA+ic/vxo9MMidLqe6j13fq2eELafqfwKhb
	 psKzN5Ni80rm/jBqmdYOvkZ2BrUb+WN6tv4MnbqGRyObJkg2zZlZRsrsReFhaH6un8
	 BKA1Az6Vri65psxrCYEfBZASgvwmp3b5fh1QrS6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 438/507] batman-adv: tt: send ROAM_ADV on each roamed back client
Date: Fri, 13 Nov 2026 10:52:22 -0500
Message-ID: <20261113153811.581461089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit aff4d5d10f2dcb4a9b604e27414dafa1d51b6406 upstream.

When a ROAMING_ADV is received for an announced local client,
batadv_roam_tvlv_unicast_handler_v1() creates a global entry with the
BATADV_TT_CLIENT_ROAM flag set.

If the client sends a frame again before the next TTVN commit,
batadv_tt_local_add_roam() is expected to announce this return via a
ROAM_ADV frame. But this doesn't happen because the global entry (created
by the first ROAMING_ADV) carries BATADV_TT_CLIENT_ROAM until the new
originator announces the client.

Let batadv_tt_local_add_roam() always handle a roamed back client -
independent of the ROAM flag of the global entry:

* trigger sending of the ROAM_ADV frame(s)
* remove the (with the roaming) associated global entry

Cc: stable@vger.kernel.org
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
[ adjust code still in batadv_tt_local_add ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 0be2f693d5955..4ade3ca5af99c 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -755,7 +755,8 @@ bool batadv_tt_local_add(struct net_device *mesh_iface, const u8 *addr,
 	/* Check whether it is a roaming, but don't do anything if the roaming
 	 * process has already been handled
 	 */
-	if (tt_global && !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM)) {
+	if (tt_global &&
+	    (roamed_back || !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM))) {
 		/* These node are probably going to update their tt table */
 		head = &tt_global->orig_list;
 		rcu_read_lock();
-- 
2.53.0



