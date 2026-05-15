Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BB53E00A3;
	Fri, 15 May 2026 16:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862191; cv=none; b=uN7QIZsiv9wgazs71/4rQn18GkcUy+yojef+UxIidzXvOUMuExlhS4VITW3/ocYYZr/zBEIWn1hSTJI/4eaeN4brGwsQ1UJ64NTBxUCzN+42jO9yE7qUy355k6GrWsxxDS3jc+XZWvyyIDcI7UdTjSWJSR6DVhikSdSf0U5azfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862191; c=relaxed/simple;
	bh=uO9CicmCeXkfOX6z/FuQkbBo6MFRJdu09hhOcs0pnMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQetkdN6sdt68q7vRELkGG9QLuUibnoMchToAF19v5RsxTFoJ2d+Fu6AeVv1JFstLavRdpeEEEoEgunp829RSVLivJ364xjV/ZBe7cSHYnTF4DejZXBt8dUdgrBfZvlIHh7NwJYTnA2WYFY4kicd5ItZzmLNE8PfpCO2Mj2OfXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVUrmdzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVUrmdzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B38C2BCB0;
	Fri, 15 May 2026 16:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862191;
	bh=uO9CicmCeXkfOX6z/FuQkbBo6MFRJdu09hhOcs0pnMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVUrmdzQfSJmqRYYXCj0S3intcktrw21f96xFGmjmVuNKBXiPO0PKE2SdMMJIFvQ9
	 ywkvIUFgj77MDcrwdNnqLD2RV2G/QdzCXUnm23ALky8lMc2UL/pWZ6AruWm6HAHV/D
	 TqjDO6YS6UFOOcOpEeQpuPQRW0tQdiEwAC72OtiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 142/188] batman-adv: bla: put backbone reference on failed claim hash insert
Date: Fri, 15 May 2026 17:49:19 +0200
Message-ID: <20260515154700.405377471@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

commit ba9d20ee9076dac32c371116bacbe72480eb356c upstream.

When batadv_bla_add_claim() fails to insert a new claim into the hash, it
leaked a reference to the backbone_gw for which the claim was intended.
Call batadv_backbone_gw_put() on the error path to release the reference
and avoid leaking the backbone_gw object.

Cc: stable@kernel.org
Fixes: 3db0decf1185 ("batman-adv: Fix non-atomic bla_claim::backbone_gw access")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -724,6 +724,7 @@ static void batadv_bla_add_claim(struct
 
 		if (unlikely(hash_added != 0)) {
 			/* only local changes happened. */
+			batadv_backbone_gw_put(backbone_gw);
 			kfree(claim);
 			return;
 		}


