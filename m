Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702E546C4D0;
	Tue, 21 Jul 2026 18:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658600; cv=none; b=tkV/oTNrE0rIk0YYnwoafoO/FQh9l5Ni96g9QTK/43FVOOyAwZRaYUoqP1VltmY/sCsdepZaqOG1VmGvnnN27++zNQdhRDoFqhwCl+0Mm+Gy+pDL8lNo0xwUDYR5JmcDJV13cVVDi4IVtrosNMBIu2nltIFf/PdS6TR7O7npTKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658600; c=relaxed/simple;
	bh=z/MjpL3uhXSxwmmG+BCnBpbRWUGgqFpHifzWHwL53oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jm0OfVzVcAWIhgWMBJSR2AK0SoOrEaRL2cs8G6/Ji9iK19fTl//85wHl202A3yRRx46qlctTbupKzsQ81L6OpaNBN1XuyMrnQsXJ+XHemuOg+d7vqBdDGVRYfcJdWNkbWurrOz/2iHnKfVCEUQC1HJBXZUt0ZmmhFlbdvSg75NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMaeMaKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMaeMaKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5C21F000E9;
	Tue, 21 Jul 2026 18:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658598;
	bh=8CGjb4h6saVo+aOM/75cNBR/gz+hExoFVzkeV9DQCDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMaeMaKZ8vyVlpKByAu6O8LIiGgY8ZH9Fy3K8c36OV0lKL2YCtMdoUKF6rA5slrJY
	 Emw7sSyPff6IorMXzyn0iUAFd76mCo5YVcfWcmV/alVyaL3UpeNZcW0MdUczQ/kLXN
	 P6GiOJ2mtapnvCBq1nvPbe+yolv4LnsPFNoBtFaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1202/1611] batman-adv: tt: avoid request storms during pending request
Date: Tue, 21 Jul 2026 17:21:58 +0200
Message-ID: <20260721152542.471742009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


