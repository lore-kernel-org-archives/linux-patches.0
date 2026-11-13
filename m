Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591298;
	b=u8A65LgAbqeW6vPMwlWKV6D/jNVl35eyw9FYE83hEH2YU6/Fa/rEb0FziG8IPTjTbcV7
	 soH9h+YBxZcG2pXBSknIixmx5erOPtoWx4r2rbHTGXpSpF0dLda25TCivcUSP0/7++cKl
	 QRP7CT1z5yiYJIs0HFkqSJzQ2avCJKkxgR8Xk0ZHrNWuTWSBwnPgZVZdUAWeRfTiJfc6s
	 i0c1+Ad+5cU2EXl5icVp4VTaptuGPvv5bzpPNPPzOR+I9nkG+fSrAVrchoAKKetFtvyI0
	 PTjJ16DXBOAWNLyZ2GllIq13aFtyOZDcuTu8y6/hPKlGSVnnL7jDmuVCYP8MO1BjOXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sibc+Ttsl4tZuZ+iHEe0JLpEQmjfVLcrM53jUfeatOQ=;
	b=C1cxfkcBAXqps03SIGtRMExhQw0hFivubjjsTR5frj48fax9PKkqAklG7JuSJCUpgJ3z
	 O6NzpZLqtXP9WRJHr8rxSuznCsIS4g9d9c+rpJgMmrYHOHSf3gR6+FH8C7myAj7tJDvk2
	 ExUA9vi67xSHviELH1jxLQX+hB5tLuJml7+GFlvW3DC3xZaF8iZgb/pwehD6zQm+1b6+l
	 CBQ1UOZRWzs+fruYNCuG1Yky6ZffaJdEvPcd7uAD1afdnO1TWsduXsKhySWxLvrhMuygv
	 4pGF0yTMKIRAqZfkZ6QxqkVujsJpF7aVoZoPobs1pWvXCqMjxNIaWR/dY1BCYYAeJfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFxEyI86;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DF460776CC;
	Fri, 13 Nov 2026 17:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFxEyI86
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2721F000C4;
	Fri, 13 Nov 2026 17:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591298;
	bh=Sibc+Ttsl4tZuZ+iHEe0JLpEQmjfVLcrM53jUfeatOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFxEyI86xJbvr8A0cAH6RNeSxooc6prNxQnL4c4zvIi+KSzM2hWSrsgqnWlhZ1h0v
	 8emlb7ChGoLc/ZTwyU2Qi5V7rxUwO3IjPpbHJpZbZBazRAXfBnXhYrGv9YjpNR4OvX
	 tIdkHBWohGOe8CjrZxitkwKNmEQNJzahBiK2QIOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 414/670] batman-adv: tt: send ROAM_ADV on each roamed back client
Date: Fri, 13 Nov 2026 10:49:38 -0500
Message-ID: <20261113153825.775222400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



