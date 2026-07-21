Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC93442139;
	Tue, 21 Jul 2026 22:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672469; cv=none; b=oRoqU10Hh7c467NS2mIKrdZzPeA6MjHXL8TGxHTOwAz1z6oBkpTgKR8bR7WbLykgEvFFm+9H9mBHxid9hHibQqWkCVZk4+Tm8qAFhNp9iET0u3bJQKs9pSg8/Huv9J/Hp9DlJbaVlQX7JEApxeuja3J73Vk97IY3Oqmb+DEOoIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672469; c=relaxed/simple;
	bh=SBOqqqTXVOVYaZ+jymtXp6EqwlOxuQujK5vU60+YpAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1pWsFtZMjz9d/VN1oeaNGHAVfe54N5i4JXI3gaQ4gjF1W8KWfr1gmKqEKBuiKAbMFlotuauXSiAQ9ks+UDxBJINR5yCFEEFjD3+tNTz4OKvIPud+qhiYdZmVv3tI5viRhdKBQqQ0l1p8Pj73OjNoC7kq5pUZmYuNaFzDuCf1xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+Brjkdo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+Brjkdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A075F1F00A3A;
	Tue, 21 Jul 2026 22:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672468;
	bh=7zjlY6qD52gqSBqyB6pOWL+ZrTpaaMxra8A0l2B/Kpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+BrjkdoRw8QbU7vk/ss8JKl/CJM7Me7i73Du/+PEhRxVfTQmQlzlcaO9QrKJ2dgI
	 6pK5cL78nXQkoFKcACv5Svmqviy6pP7bMquV2vUSpI+p9IdLPkfxyfAIphvIUzrDHe
	 HBKkRNYkyc+M7o2SVI2wMx3ix+Z3k4Yfoe7k0VHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 593/843] batman-adv: tt: avoid request storms during pending request
Date: Tue, 21 Jul 2026 17:23:48 +0200
Message-ID: <20260721152419.390799956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 27c7d40008231ae4140d35501b60087a9de2d2c3 upstream.

batadv_send_tt_request() allocates a tt_req_node when none exists for the
destination originator node. This should prevent that a multiple TT
requests are send at the same time to an originator.

But if allocation of the send buffer failed, this request must be cleaned
up again. But indicator for such a failure is "ret == false". But the
actual implementation is checking for "ret == true".

The check must be inverted to not loose the information about the TT
request directly after it was attempted to be sent out. This should avoid
potential request storms.

Cc: stable@vger.kernel.org
Fixes: 335fbe0f5d25 ("batman-adv: tvlv - convert tt query packet to use tvlv unicast packets")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3032,7 +3032,7 @@ static bool batadv_send_tt_request(struc
 out:
 	batadv_hardif_put(primary_if);
 
-	if (ret && tt_req_node) {
+	if (!ret && tt_req_node) {
 		spin_lock_bh(&bat_priv->tt.req_list_lock);
 		if (!hlist_unhashed(&tt_req_node->list)) {
 			hlist_del_init(&tt_req_node->list);


