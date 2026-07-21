Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9425C3AFAEC;
	Tue, 21 Jul 2026 20:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667150; cv=none; b=shQZBKA7m3BOmT6MUyq02YGZ2cfgaJNCH7yT7EIO3LJDB78M0NsvBnfKQnyCiTeJkd7ouQM1VR/izED7ru+oSBoetYKNhcsqYHZxV09zoE9HoXYs2x0bvblkcG/RjvNeeamQP+AjKhqx86nKUTtxJEr9TGntwZgR4DoK2ya6lUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667150; c=relaxed/simple;
	bh=OmEgdmqDiYDDbflbZFkERi9wUcmcB+B+UPjUBAjtd38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK9AT9ZmeuPEi8WEnD/N97AfCbQ7Z1OlxgDiHrpT9W6OGxJAYNV+p4TD3zuF1JYIDzzFDvXDMyZoD3aMmw0YHHrrZ1qewnlIT57UR+SBR94gE3D7dK1BSAnJgI9U5EYN5kNOyQTHSkb4ojFg+hG6n0jaqQya8ZGmkbYNwhzdrzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ydykag+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ydykag+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005591F000E9;
	Tue, 21 Jul 2026 20:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667149;
	bh=8x9mG+PO9iTgEGC81pP8ntiGNFi5FndAU7o+Ywa98W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ydykag+Wadi1WGiMUQaq138hsBoJtI5dgSQaTA2ocRVq1I7N/iSTKy7PS7HUJV7p+
	 B5Bvo2rgvZW7OEWqk/cBObcD1GnnKiTRUy2MAmyfj1Xn+Aw/LOtlrZAbJNsAg5+WjF
	 klJi9sUEF+uO4e9ElcOx/cN5t/WyciRpvjtvkwUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0951/1266] batman-adv: tt: avoid request storms during pending request
Date: Tue, 21 Jul 2026 17:23:08 +0200
Message-ID: <20260721152503.109352359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


