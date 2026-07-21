Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0B82E736D;
	Tue, 21 Jul 2026 17:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654287; cv=none; b=kEYmfpZA3xdhodlmKF5VwV62F9zEKdCOhpFFAi9l6XUk1NynxdfjgufoAa5yHqQl0WHzFjfQElsSILn8P4rjNCcXr1e8GwixYxjLPGITTNalx2vdJT6UCmeqYO4pw+w/iYK5mMKT2qrOurr1u3TfcPlDayywd+sihHdW5bMUXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654287; c=relaxed/simple;
	bh=RCBtQQhPaggr4GcF0h2vBTMP3Ag3f3or58oYTNZ6ugM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOvDLQsNFyyS9jjigEw73D82hdVL1QUHkR2Y5tOvUkLeMfH10W9Qaw2DcXogMpWfvjXZa6JvYYiATwEEZDjug/CrFlwTj/Dr9XUUYa0XjofwVP7V1lahnvUKaWgDNQgLytANfzOIgPEU5HLPoZCiSwiNiAk3d7pogUC0WvilVpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8bgPgCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8bgPgCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0851F000E9;
	Tue, 21 Jul 2026 17:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654285;
	bh=+GOO9Yc4NXuyHRCjmSDAT2EPVpYNxQQjdJ8hLUMhVOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8bgPgCPww62dOFue669MCe3JivQf33/TL0VM/GDpkZLmRtrDOGSioVC8fiIYH2JB
	 wYUDwioLVUG8/L2KTj2S+Cn+DlK1KwQ4XWyIeUBZQ/Rp36ezAW1cOTdyVYCFc08S6r
	 +W88g1h1mOGehSmv1tyUZNOzrcLEKfehJnRuM+vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1646/2077] batman-adv: tt: avoid request storms during pending request
Date: Tue, 21 Jul 2026 17:21:59 +0200
Message-ID: <20260721152631.574092091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2963,7 +2963,7 @@ static bool batadv_send_tt_request(struc
 out:
 	batadv_hardif_put(primary_if);
 
-	if (ret && tt_req_node) {
+	if (!ret && tt_req_node) {
 		spin_lock_bh(&bat_priv->tt.req_list_lock);
 		if (!hlist_unhashed(&tt_req_node->list)) {
 			hlist_del_init(&tt_req_node->list);


