Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9419C44AB8E;
	Tue, 21 Jul 2026 22:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672466; cv=none; b=PN1dgdmrJ8SAGlplrPbS5dAo2ChRpIuW4icF6SQzNTeaK4eAUfIuQg3781KH4gBx1NiBGMH4PF0J0zK0QP7bFTzWyGK6twTyS9zce45C1EnENB6Y42t70mFUpYzVvDd1EFsq+1pSPPvikxgxKYAz6DaWvsdbR5RaKzlC2FMuJLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672466; c=relaxed/simple;
	bh=SBPXrNcvoIZkql19Dv8/kGPbKYcowi2Ra5IUEgIMgdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKj8KzK5yC9EDqPIjGJ2VcKWoinj7L//Qd8UZkTsAWBJm2I24/12QlcYzlgyjYhqgEEY199yaaJdavOJwYQVS74zeQnzekFnFzEuLvrSn+o3J2JcVz89hihdljWzGC+TMi3g/HFJdQlTqo2NERkgw82W95kdYrxHY+PlvBTiPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0k6ahAQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0k6ahAQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0042A1F000E9;
	Tue, 21 Jul 2026 22:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672465;
	bh=0B3W2pqyC+VsoI278AsIetTh+rH64gYXy0pzbGl8i7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0k6ahAQJcYwc4pEVeXHSZCzIUSHnPKS6yymtR215rLBypJhpuOLUiA/FUAkLn0Hcj
	 6UO0YzoL/zwHd0TWKV0Jm/3y+jiMafOLMorbAYz/ggaPRQQC50ZS6z+o/L48qE2Z0o
	 MMhxabLClzLlmqtVRKcFvoscieZfZkCg7yHQAgxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 592/843] batman-adv: dat: fix tie-break for candidate selection
Date: Tue, 21 Jul 2026 17:23:47 +0200
Message-ID: <20260721152419.368614488@linuxfoundation.org>
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
@@ -546,7 +546,7 @@ static bool batadv_is_orig_node_eligible
 	 * the one with the lowest address
 	 */
 	if (tmp_max == max && max_orig_node &&
-	    batadv_compare_eth(candidate->orig, max_orig_node->orig))
+	    memcmp(candidate->orig, max_orig_node->orig, ETH_ALEN) >= 0)
 		goto out;
 
 	ret = true;


