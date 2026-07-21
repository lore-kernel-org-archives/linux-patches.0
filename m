Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5BB3368A5;
	Tue, 21 Jul 2026 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667159; cv=none; b=NMh9jv+6tHg9gCl9L/dZtz+NyqTR4D3MQraZrs7KrjFaJqZuVweZ79Hos5rcruwzf7U5p44zOydJ7UKhvoOeZ35VdzearPdHe9qhdHiMyaARuZ8URDMqewVUE+nj71VlscpV3llgT/imED+HlBj+cVzEO1GyJyzjgxJGRzdKids=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667159; c=relaxed/simple;
	bh=+1cGegMSZryCmwtopzeV9+6fPOiF0V004ZfpgssxZ9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYmSHHEdnNGTT5iAbmjr9Iu+W8sYJ9nj8HpcAuqYJgSJqQEgnnbu0TROGOvBDUatcbA8QElxB//m4bU76mhr5rcuKv7mjqDJ+N0K7hl5FuRtXCVme2CZ6KHNTW1wojlavFH3nfMLMIWx5d0zjJPI1Xy4gm08zJOST7A24mPpKdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jM/kvcvb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jM/kvcvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF65B1F000E9;
	Tue, 21 Jul 2026 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667157;
	bh=nZiwWDe89EGxRDpzQxUenKWbFGhdcKsIS5qPyEhu0iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jM/kvcvbaD9+ac/7Efl4zRdntlfXjWBc2CFWTzH+AwqoE80H8UbZ112n18FGYWgsY
	 ZPPOmiQUdVbUq5vSYHgsoy2s1NKegROCkIwUlugSEIFciYN/bE77IqyjeDamCf/XK7
	 QFJ15KjC2oPkVThKhI/A7YcSrKMt25bk0ps1hIkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0954/1266] batman-adv: frag: fix primary_if leak on failed linearization
Date: Tue, 21 Jul 2026 17:23:11 +0200
Message-ID: <20260721152503.175723313@linuxfoundation.org>
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

commit 353d2c1d5492e53ae34f490a84494124dc3d3531 upstream.

If the skb has a frag_list, it must be linearized before it can be split
using skb_split(). But when this step failed, it must not only free the skb
but also take care of the reference to the already found primary_if.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a063f2fba3fa ("batman-adv: Don't skb_split skbuffs with frag_list")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -551,7 +551,7 @@ int batadv_frag_send_packet(struct sk_bu
 	 */
 	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
 		ret = -ENOMEM;
-		goto free_skb;
+		goto put_primary_if;
 	}
 
 	/* Create one header to be copied to all fragments */


