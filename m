Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7143B42CB;
	Tue, 21 Jul 2026 22:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674235; cv=none; b=E7AaGDFsiWFHEb8vU79H+sYpL2snrSrqnHD0Rhg9nFvP0rvmw9Ru4ht2WhKXSxrNCm73ZkBIVYZd1N2dobWgcbzBatFwi47g7lRAjUNnAZnO4BVnzC8CFIHvq8cYDvzDo6uAVxG/u61jkOBmeeWCuNicO9UGFujo9H2/rh77ZzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674235; c=relaxed/simple;
	bh=1nTdRnDMq5pXJzLMCWhVeQ33mdKos3bvmmahOYluu9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVUDs2cT/626ZFDo6Xxa/DJN+r5wwko0vw2FDfSdvyZ/T2KXblX7xQ1s4FxDmRsDt+3o66nUH1t2mp+M1+5eEBETc9Xroqgxk0edEeZanWQoHvnZd5mWKRMVM8KDsALBr3LJ3nfYXVrXvEcbBj43l109MadFM+eBW2sZ3Ga7maA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JGvzd0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JGvzd0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF4B1F000E9;
	Tue, 21 Jul 2026 22:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674234;
	bh=xLwykwzKjWkbGGmihOTae4JYuptXsnqZqUjoEagZTrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2JGvzd0aR4IFafdaPkH5clLZjA+wY7yoaTtqLLSJP4IRP20vkAdqTwS7WJunw9vmV
	 KKPMiUF3tYXLJomWYWW/eUOEQMLIk4cvhJpwEcZU/PAy2kzZHW2pbnj072TGQfsDKZ
	 pmlmijiN5SiilJ6kM7RtH9IQ2yLwYNH9bb0rwrAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 465/699] batman-adv: tt: avoid request storms during pending request
Date: Tue, 21 Jul 2026 17:23:44 +0200
Message-ID: <20260721152406.184964630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3260,7 +3260,7 @@ out:
 	if (primary_if)
 		batadv_hardif_put(primary_if);
 
-	if (ret && tt_req_node) {
+	if (!ret && tt_req_node) {
 		spin_lock_bh(&bat_priv->tt.req_list_lock);
 		if (!hlist_unhashed(&tt_req_node->list)) {
 			hlist_del_init(&tt_req_node->list);


