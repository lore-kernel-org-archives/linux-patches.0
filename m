Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038010;
	b=YEghTV6SrkCvqulxknm5IaIhxA5q5tSDksaRuqao9551QKDbS10WhWG/Ic7ppXRry5Mo
	 tR03nfbALXHTqzu8lZxZDnEgRTrw1maeeLePJ0mPDR4OolnLOwKcIHafIwTGSf2bDwZ4j
	 KHtiU+G6xnwXyujLC4/mGRZlSGELDLiiXS9wig6rZlxEiDLaM35HAN2J2Yte6At5eSPhv
	 ea0QhteL5b9cpU8kTSGJBp6tNFA2HnYK7PMabCcBjwIKhLuI0Bboy09V+25M4GBh7ebk3
	 5ykcdQSYVqqApWcsRTqkkfDXsAZ/MXVosloKq8HsMI42ZgalBQ0ekbTcgcWsK/pTyqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9lu/ae4hAmdLKAM11E5FspdzvyJUDKt/BBGRJGsQtvY=;
	b=GslLI41Uc6f/RNQaHFInkp4kkTnKquPhps3HFFitBBKA2hl/Ttaoda35foY3PIbHTy65
	 kMHldzlwg+ixqL0Sccgu9xBd7KSs4rlLfLqJliIMuoenn7RbF5jYPdRmqEnrR+RGlGwFU
	 7WUIXi1nROjYgcighaBRwnggXaPK4i/t6tOtDuKa6QU6OetfgDPsTCOnxcY618BFoL67+
	 xuj0Rz4CrmqXXGJcOxChdwolFuOeLDsBEPAUd87jZQTpeu9LTnKBwJubzdJf6iQVrKkBP
	 +mY6rWQcIIZBO5nQpV2Wbi0zvkHPfu4NKSKt8KMiK903z3no02cXexGalkXznNtNqmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n4Pw03zi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DB2606A325;
	Wed, 18 Nov 2026 21:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n4Pw03zi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8D01F000C5;
	Wed, 18 Nov 2026 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038010;
	bh=9lu/ae4hAmdLKAM11E5FspdzvyJUDKt/BBGRJGsQtvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4Pw03ziBlTrMdhYmshvOv7nDTSWdQ7znF1OE+WbOE2V/I/GjkRKk5vCOdw0Y6s32
	 CD7rAyhy054YniZdGY3ZqaxYakDkUxttXETbbl5Rox2/G4MRogOuQujkU7bEb09lMd
	 tzxx1ULrVtuUok3rR5/UjWIlFK3oASqczLSg3Ivw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1594/3318] batman-adv: tt: send ROAM_ADV on each roamed back client
Date: Wed, 18 Nov 2026 15:36:56 +0100
Message-ID: <20261118150408.973622553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit aff4d5d10f2dcb4a9b604e27414dafa1d51b6406 upstream.

When a ROAMING_ADV is received for an announced local client,
batadv_roam_tvlv_unicast_handler_v1() creates a global entry with the
BATADV_TT_CLIENT_ROAM flag set.

If the client sends a frame again before the next TTVN commit,
batadv_tt_local_add_roam() is expected to announce this return via a
ROAM_ADV frame. But this doesn't happen because the global entry (created
by the first ROAMING_ADV) carries BATADV_TT_CLIENT_ROAM until the new
originator announces the client.

Let batadv_tt_local_add_roam() always handle a roamed back client -
independent of the ROAM flag of the global entry:

* trigger sending of the ROAM_ADV frame(s)
* remove the (with the roaming) associated global entry

Cc: stable@vger.kernel.org
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
[ adjust code still in batadv_tt_local_add ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index c148127799c1b..8397b9edb5aea 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -775,7 +775,8 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 	/* Check whether it is a roaming, but don't do anything if the roaming
 	 * process has already been handled
 	 */
-	if (tt_global && !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM)) {
+	if (tt_global &&
+	    (roamed_back || !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM))) {
 		/* These node are probably going to update their tt table */
 		head = &tt_global->orig_list;
 		rcu_read_lock();
-- 
2.53.0



