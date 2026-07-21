Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2528533689F;
	Tue, 21 Jul 2026 17:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654284; cv=none; b=gIZwTQORAUTr1DRJHgcd6yA0zIMAFDdBWrgWLaVqdpYAgyvX5SBKu5lnGvbaBcWGOrodLGCgup4IPbOtMxB1Fb3w5oK35tPwd5Q6a3zVIE5v3tKkEOIZ4JO/Ri8quxrQb7M8jDMQ74XdObiQWfqWDJi1x1IZ1Zy3lWgMPitGoG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654284; c=relaxed/simple;
	bh=T4TtzkeAQwBNyCMpLeoDse4fN3wwyApBnpZMlluQoyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxLDTDGDJ3bE5KXb1SeRsPjqljM+i38n+GO227iq6IEzPkG1IKtU7bp924ZrqAV0Xoc9E16Q0PSNhrWW6xw5bQVoVFazPw6wgyZk0jvsRZ2tvPWGQai80zKewGcJLmmORyI/Soi2ieAqESGfcfqksloIO23JG4GU7dp+krh6CLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tk0mKDmB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tk0mKDmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A85D1F000E9;
	Tue, 21 Jul 2026 17:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654282;
	bh=28aRKkBo45BbtCNx/0z9DVl2CvsfYcGnbhGFcVraGqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tk0mKDmBaO+OS8Rp6Z+3oS19EpCEXDDokgoJe4oliFA4TuAYCdHdPXY3kdpl1WqnQ
	 6sRdOhom3cYj45ffhTtDSKv/vMxcpy77+SppUCWURqffzpGtVFSNOEgawc2xEJUKZJ
	 7MS18Lfo354poeC+xcG60aJbRJdYZ23WUGhshyo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1645/2077] batman-adv: dat: fix tie-break for candidate selection
Date: Tue, 21 Jul 2026 17:21:58 +0200
Message-ID: <20260721152631.550846092@linuxfoundation.org>
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

commit 98052bdaf6ac1639a63ffc10244eeeab1f62ed2b upstream.

The original version of the candidate selection for DAT attempted to
compare both candidate and max_orig_node to identify which has the smaller
MAC address. This comparison is required as tie-break when a hash collision
happened.

But the used function returned 0 when the function was not equal and a
non-zero value when it was equal. As result, the actually selected
node was dependent on the order of entries in the orig_hash and not
actually on the mac addresses. The last originator in the hash collision
would always win.

To have a proper ordering, it must diff the actual MAC address bytes and
reject the candidate when the diff is not smaller than 0.

Cc: stable@vger.kernel.org
Fixes: 785ea1144182 ("batman-adv: Distributed ARP Table - create DHT helper functions")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -545,7 +545,7 @@ static bool batadv_is_orig_node_eligible
 	 * the one with the lowest address
 	 */
 	if (tmp_max == max && max_orig_node &&
-	    batadv_compare_eth(candidate->orig, max_orig_node->orig))
+	    memcmp(candidate->orig, max_orig_node->orig, ETH_ALEN) >= 0)
 		goto out;
 
 	ret = true;


