Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E48C33F59A;
	Sat, 12 Sep 2026 11:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213401; cv=none; b=R7T8mSfA5J/RY3GnzNhjKd2j9AMQAvU6biuicrMussU5DsnN2N6qkqQjvLdu5KFqROgwzSJArOtFIFlWEoR3esTFCRm2IJquNiPJsSiUbGs5ZLWqpaKkxc6KsixqUh/milg7PZG4NAoL6AsG3TOH36Jxi0gUkoRTMrPhqp9uvew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213401; c=relaxed/simple;
	bh=czdsvD2hqfwryCd/WgMIbe/2JRHHLLmarF7jzCHio9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl+roJs6fiXzp6rJ7JEXBDuuKlRNa5/BQn+4qlg/dpbNtHI46ssHIjrF2ObrJMtXRDJU8W7cMGNk3gWsVvkpbG6TG/uT3rEtNczw4VO/bQyyseceujx/Sxyt3otwvIWkiGMUTOQPf6+vDaIVt/ImPKlEnhCvIIPBaTvv/TEoygg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKlZ17TV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKlZ17TV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464E61F000FF;
	Sat, 12 Sep 2026 11:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213400;
	bh=HwdH5itEwzSV6Z1piZpvcbrdRsblQTbF6yZmcCFrcMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKlZ17TVLGYwJ20QFss29gyY17eOew7HQJP4DXu3JI2XI1/5Tqj8Z6iJPasiP6l00
	 DxmBtGs8MPJJZKqA1cI+qSpmLIJ6SwgIzi1S2IkSe45kd5a5Ze6SxhKEjeIYmV5vUg
	 SOfq/KDQy5RZuLZZK47ZOT4BaBB/5kbKxkZ9TB+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0114/1376] batman-adv: mcast: linearize skbuff for packet generation
Date: Sat, 12 Sep 2026 08:42:20 +0200
Message-ID: <20260912065610.094608552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

commit 6a30a59e2660afd03c975f1b8eae6a2301161197 upstream.

batadv_mcast_forw_packet() and batadv_mcast_forw_scrape() is not only
called (indirectly) by the unsharing+linearizing batadv_recv_mcast_packet()
handler. When it is called (indirectly) by batadv_mcast_forw_mcsend() then
it will be unshared but not linearized. The SKB_LINEAR_ASSERT() can
therefore cause a fatal BUG().

The linearization should happen during the expansion of the head because
the scrape function can be hit already during the initial
batadv_mcast_forw_mode() selection code:

* batadv_interface_tx
* batadv_mcast_forw_mode
* batadv_mcast_forw_mode_by_count()
* batadv_mcast_forw_push()
  -> calls batadv_mcast_forw_expand_head() before everything else
* batadv_mcast_forw_push_tvlvs()
* batadv_mcast_forw_push_dests()
* batadv_mcast_forw_push_adjust_padding()
* batadv_mcast_forw_scrape()

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 90039133221e ("batman-adv: mcast: implement multicast packet generation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/multicast_forw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/batman-adv/multicast_forw.c
+++ b/net/batman-adv/multicast_forw.c
@@ -1103,6 +1103,10 @@ static int batadv_mcast_forw_expand_head
 	if (skb_cow(skb, hdr_size) < 0)
 		return -ENOMEM;
 
+	/* batadv_mcast_forw_scrape() + batadv_mcast_forw_packet() require linearized skb */
+	if (skb_linearize(skb) < 0)
+		return -ENOMEM;
+
 	return 0;
 }
 


