Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9481D492E33;
	Wed,  9 Sep 2026 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962199; cv=none; b=OS9NdSYPJzPVErEdLHjnnZ80AnaEBrY/rdPq9oHcDMn7VvCJuH9xZmH19F3Vw2K+rkHDc8632k3qtcm0eWPpKeyHDNzyuO3h5VZ5i5PhNwdqmW6p54nKqf7S51+tviJIsGzSWhovvbsiuDLGW/WtF9c1cLADL/ncOxx5bfV0WDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962199; c=relaxed/simple;
	bh=jqW7BTvHSkzPmg9IcQbkv50BhK/b67hjd2PPpo9KhGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pY8gbd8+LU84TCaHADNPccAiCwcdvaasd78wGioQWU1BgooCJZfvyJOG3cp3pxprNUnEIepNsVKVORPw6tvKqwYgqRIF0mYh3pamU3SYkNj+o7vNjV0jZWYL54dHF+BEPgGgG7jHiPIIJPhpbj+Xzpomk80aTaeXTi+HrPVaySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hexotq6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hexotq6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC461F00A3A;
	Wed,  9 Sep 2026 13:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962198;
	bh=KuL1XfVwT8m//xZxCt9JnVPXPpVOnhmYq0YgrBBt0xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hexotq6Ex/9S18pe8T8mu1lJ1LnHKqDurFNQ28AhZf2eyGRIXkLO+kY4Rq41cWaIH
	 UdJUYU5D7LokosAoNp06zXi1goUSfQa8uzy94dsrGlaxBaGPdB6GwSDikSfDRQbII4
	 KXwNhTp0xEfrqTk5/zngYg/US8bfJ+NYsvTnrunI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.2 206/556] batman-adv: bla: prevent CRC corruptions after claim flush
Date: Wed,  9 Sep 2026 15:38:06 +0200
Message-ID: <20260909134237.636242937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 89f3502ff6878798be96461b2eebd64ba3c3874c upstream.

When batadv_bla_del_backbone_claims() tried to remove all claims of a
backbone, it sets the CRC to 0. It assumes that the it had the last
reference of the claims because batadv_claim_release() (which runs after
the last reference was released), is XORing the crc16 of the claim address
with the backbone CRC.

If there would be a parallel holder of any of these references, it could
happen that the backbone CRC is (0 ^ crc16(delayed_released_claim)). Which
is the wrong starting point for the new claims it may receive when the
remote answers the claim request from batadv_bla_send_request().

This reinitializations can be completely dropped to avoid this problem.
batadv_claim_release() will take care of fixing the backbone CRC.

Cc: stable@vger.kernel.org
Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -324,11 +324,6 @@ batadv_bla_del_backbone_claims(struct ba
 		}
 		spin_unlock_bh(list_lock);
 	}
-
-	/* all claims gone, initialize CRC */
-	spin_lock_bh(&backbone_gw->crc_lock);
-	backbone_gw->crc = BATADV_BLA_CRC_INIT;
-	spin_unlock_bh(&backbone_gw->crc_lock);
 }
 
 /**


