Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9BD46F484;
	Tue, 21 Jul 2026 18:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658651; cv=none; b=IBv55BDrwT2cf0Z3BQY1eq3XHA8TQq/9GDXVJ2d5AWHAjuRaS8i5GV11H3Ws3KR6hlT79Ydl5hu5ALBWvkeP3nITj09tgHd82NzzDKDazHm7Hlbx7p3lq5WdfRk8N2+Wb/PLnzlzU2mkeuTMqQLEsbU98in/hcLGCUznueXuR5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658651; c=relaxed/simple;
	bh=RKnL7ovPb5SHYKnOlwqqPj3IqFjor6q8FDbAiEvWw4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EW4bAIUqKrv6ap82naUuNvZsnNMVTqxWY39JO8MnvpKoL+7XQFDcl/RJ2r+6qotEfouQXWux88a5oYHz9RN+XXV+hDblGkC32EOLMYCS8KnuPr3JyQwJY3RgwHFHqt6So4t8qOucVAkyGgb2yxkWVmH/D+bLkZKjkSbZkzZEBPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvPNMa2P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvPNMa2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0441F00AC4;
	Tue, 21 Jul 2026 18:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658649;
	bh=zeXmXpYq69CeD8cYsFxGxVgsBDdBqMAeKgjiPovp9/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvPNMa2PNxYd19X9YDhmoxSAKPTsn2HFe2Ue1+B8xaKM2N/gXiLPu5Q1SGxbkzUzL
	 aQ3k853Gr6HoFBM69L8eFztaiDGdA+Mm5tSAyTEZIyBCc0wkC/MszfYJViPY7R++pN
	 OMxjqm73+pZ/3uLilDT+oNA5W14IARdDynTt+6/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1206/1611] batman-adv: frag: fix primary_if leak on failed linearization
Date: Tue, 21 Jul 2026 17:22:02 +0200
Message-ID: <20260721152542.561166343@linuxfoundation.org>
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
@@ -545,7 +545,7 @@ int batadv_frag_send_packet(struct sk_bu
 	 */
 	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
 		ret = -ENOMEM;
-		goto free_skb;
+		goto put_primary_if;
 	}
 
 	/* Create one header to be copied to all fragments */


