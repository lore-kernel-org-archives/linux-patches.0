Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19734470449;
	Tue, 21 Jul 2026 19:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663609; cv=none; b=rkjtnITbfvZ+aWvKS1wT1HnzwSUsaw22LF3plipJ/jrZRDe5b8etLdEDjKd4ayDpOFf8NC7gOkQ4JDpGjTsKPPsj2AYYpS4r61k30rYTKx7KVRNoY36QOHnKR6yMqK+trnP5gP6P1zpl4CykRCSEfLTYTa/qxPJmwnHhykCX9m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663609; c=relaxed/simple;
	bh=B+lW34V761bstdA9B/7KVPy9z7hlovm74pwcUHnWdOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NC15JOIbrxWepNA1OSUljjwNP599AlrH0UgmYEI8ni4qT0qHl1H7xnLw4HEEZv/XsceVqN2GD0RcxT42/9zyZ1BM/b6mDJJ1iSr7Qi6z8qBwQWNiXANoxmra/4rJsJ+IgW3nTl0jAvSS89DEuPBKlZcoO+KzqdGMIfxdICab2mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cnmn9UjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cnmn9UjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8EE1F000E9;
	Tue, 21 Jul 2026 19:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663608;
	bh=TZ+pZXghupJUfhmhqiCFuttEh0aZ6q5T+Nl1H62DC6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cnmn9UjW0jmB3H0g5fFRS/QTyw1+1MmPMTXuBIV9W4nTZRqKJVmdP17nKwrJaG4MZ
	 vq8tGT2M7hLR/aMKdvT0Xek4gMIB3AX75S6Lg96Fg6e2MDRWePPZiNHHKas5W82390
	 uG8ZMXr0YYI/mXRjdujcDIXD/BD/B7FsnmZ/dA4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0888/1276] batman-adv: tt: avoid request storms during pending request
Date: Tue, 21 Jul 2026 17:22:11 +0200
Message-ID: <20260721152505.919412107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


