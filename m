Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D34A57D215;
	Wed,  9 Sep 2026 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963631; cv=none; b=ll6LkXqmooqUrqGBAaf9F9ogWZn4rQlEkS601DK9r62zj4aYJJ50Rp3gM8l8ROQQskazkyoXK9xcr0x7LrGAfxCMgLKUPydMz4AZXxWZ5L61bwj9ffOvfiExm6fjuFtc+iS2aBiwoJE6ejmHPPdtDZPbthvgA7sYE4nPRIfrYZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963631; c=relaxed/simple;
	bh=dhofkNOc3gNIynbD4rfYigg8O/B3v6YEZaxG4GVegB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cek2Kzj46RPZ3VIokW8329rRQGEIPsjD5R8TWch5anD+P7ZW4yo2wTFjo6/nMOD8tWWDB6O47fRvBrJiBgBEsSiNQsbZWFZODfv528qSx8+DjPK3KFdf5L5VdaxdZHZNAKT0yWroco462LGtsn/Jagqvrh4IZot7W4PcTj9pri8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKG79uLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKG79uLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D851F00A3A;
	Wed,  9 Sep 2026 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963630;
	bh=qgVprzRlBFEDrWjChN9+y4ImM5vtdGV10PNcpzFT6/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKG79uLGnl2QWHrAtdQdzuRI/RqRV6AzXml6VqyHU/JV3034/QpQz3ZObBeLNoMNx
	 c5rQzrHj8fud+/janUKNExlG79CATtneljJaV78OysvfXFWn5qylJIIN8iOiLa1ptn
	 bKWHFwWDLdDE05WWsbcqvqfPDsVv6qjvpCusvm5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 145/583] batman-adv: bla: prevent CRC corruptions after claim flush
Date: Wed,  9 Sep 2026 15:37:10 +0200
Message-ID: <20260909134243.196529506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


