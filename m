Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096F4357CEB;
	Tue, 21 Jul 2026 21:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670004; cv=none; b=JsBGq5S6b6fBXtdFTZqUnTMQ30lZEZSc+bJ+lnQOM0xf8GbNknDqnY/mpH8IlxdIoyK35XRzeYjO7wUkRJTp7tK4ammEEafT15UT7egFn/dJav2LM0FZe2+4KysoK7TWJtrgeUsQUxlb9G7/nYr//8WmugOlXXUUDaIYq5ByRRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670004; c=relaxed/simple;
	bh=LFtB+jTFkFfoOZLTcHgqY0vx8ViY1S/3nuQFfgeEXJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJy0A+c0peygUjKQroT2YK7AQ9ujnuDkib1fC/Pn8vYtGHMi22wRehAZZs2l1IEcAlhEwKoF8H8yP7kiqyNCa8kBQGQI69bCzRR6LpKmtxj6WbwOM++vTsMx9yTczcRQL0MVnncF41iZy3/H51bo22gU/q08yTE+SxP1xPBlg1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHsC+hgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHsC+hgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521821F00A3A;
	Tue, 21 Jul 2026 21:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670002;
	bh=AfCSFfelOZW3kcWtDKakANM8SObo4rnZ0FMyFSvg02A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wHsC+hgU7HjJRSCwSyNexcjlUF+9x14Ef7DnZHzaXplt0g+wBwBYFl7Om4Pp2miiW
	 Mn84/JKiM6whBNYYvhqC1/oN5wcJSStn8Phpl4cAmcCMPwxJz3P+78sivoz5C3A+ZH
	 nf3SBMdIedVMbAc4eJRoMJO1nqnZUe46pZfeUaHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0768/1067] batman-adv: tt: avoid request storms during pending request
Date: Tue, 21 Jul 2026 17:22:49 +0200
Message-ID: <20260721152441.753420015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


