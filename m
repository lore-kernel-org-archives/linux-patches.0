Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E9F471249;
	Sat, 12 Sep 2026 15:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228242; cv=none; b=Tz2nj51+g6sqL1zGQAKzN28WAFVVpy3kAAtqpCUe9T0JrfGUabYS+w3SLATiwJ/rl9R06PPcubAz2O7wNlEawU0WPDe+1gXSDwPJoYxQiFukOUtatuV1WCuA9E3ECkftnPkq0ur3uqHkA25p7MJOHbKtedolaLSCrVeI1/xzUKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228242; c=relaxed/simple;
	bh=KB0v3TmGoHViFOAJX33C360rUAd+rYtWJIZvq2GLFL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCUkVCjKBoZVA25LsKD1cTvbs7osRWeMnwg918vyF3LTpyEa42BxqYCUJ1YnUpWTPx0i1svAmLkF3fj7kBxV3BNQ99vqrSYd4ksXBf5zKPEP7S69zf3hggUyF1MKT7EdycsjXhikmQtkwKDpES0SPfuWS/Xnu601ptFC1nak1Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzfMLDhx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzfMLDhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0391F000FF;
	Sat, 12 Sep 2026 15:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228240;
	bh=Z6r5f+33C1siGTdrbiAsvl19AFmU9/4EonUFT0eEcjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PzfMLDhxhBK/kTU6dLXaIgsgk82P5079plNju+BInhIEd3tLVfbdZqcTRcNuaE1R9
	 gn4MdYTZIYBcb6/GzO3oe/P9wa0PXY/f1CzA0jXQ3gO5whWFtXdmaA86jUvWciI8cE
	 JD2tFIhMRGFOZ2eLmsb1hD3gfoSer7Z2+ClS/Qp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0328/1191] batman-adv: bla: prevent CRC corruptions after claim flush
Date: Sat, 12 Sep 2026 08:50:56 +0200
Message-ID: <20260912065555.593299796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -323,11 +323,6 @@ batadv_bla_del_backbone_claims(struct ba
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


