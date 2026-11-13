Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590532;
	b=S3kVldQhi/L/KRRF5R6AI8sOlvW4jzwpJqpXyfb+fvSN9WYWr0TBy02UemRnU+3BCX8x
	 wWV+4YS8MwXYRL23OrPFU0imE5wReO6fAFP49IhkFrIdo60b/aKQ3cSirP+jqiFdqVrAA
	 5RemoQ4R4peO9aKVu9PTuPuNX6//mu6one5eC/bNs7kQ1gtLJa/gq+mctg/HQQoEaUP+4
	 H268j0+RZT66YH0aUDe3o5fjthxqDYE6h2g6eFHwgjNX6SHHLxf8x+eWLAblRBmSsPrH3
	 6hv0cNMlVBMecpj2DxpHi1aL4L8SSMxjrjdzB+wAk0P1zMf3dqkKzbhcb4Lg1Kpbxhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WXzuUQl3SPiNHRrG7JEx7t6ylwOZQJvxSzAxsh5Cxyo=;
	b=pKWsPs5wYBAvU6c9jmELtME2k8BpIVPNo45R3U9H1ldPNc0YDLSHhAlkDb+jYTIC7HFH
	 ar2Zb2B1On0ohn82ZZcq+1eCoQss3Crf8f/cSYCFA8EhzTeQ41RR7/gsxqQcfjp7/v7o6
	 cD9/RayejN2k7hwR+lGJyuqC6D/bkkZ2gTArxuydHi1WesMYd7kkZF3C+FVUXty2kE8QH
	 L6jjn73STJlz5PL+X8J1b3Y/JC+VUmpUssPyumAFE9P0iq3HbEO3cOetyeq6ZhasBocJe
	 oK61F14SZgzj8pmfsx9CNwKU+DVpEHZK+wX99cHWjf2v8dMddxrHotMa7PmOMscoxMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOIRvhcS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CF2606B83C;
	Fri, 13 Nov 2026 17:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOIRvhcS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264E11F000C8;
	Fri, 13 Nov 2026 17:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590532;
	bh=WXzuUQl3SPiNHRrG7JEx7t6ylwOZQJvxSzAxsh5Cxyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOIRvhcS9n03ob10OEUMxB4kVXZAueGd8xMbiCbBvWcNlVyfVyqveFgkPunadKeoR
	 SQfpDwn+fUEboVhmWtDf+lmUrwIDwaauCME40HlxHl+032WGGMUizboUqOpTVjnUFI
	 Hvp1ugKw9bepHNBQMhn7I4F5H+1poSwYMnHzAKJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 474/686] batman-adv: tt: send ROAM_ADV on each roamed back client
Date: Fri, 13 Nov 2026 10:50:07 -0500
Message-ID: <20261113153836.996513473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d1cc702e1f14d..3f0b26ad699c0 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -729,7 +729,8 @@ bool batadv_tt_local_add(struct net_device *mesh_iface, const u8 *addr,
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



