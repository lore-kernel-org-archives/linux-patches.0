Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE6B2DB788;
	Sat, 12 Sep 2026 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221728; cv=none; b=gpXHbN0M2CDsz60hevDW6kGr50JC6noVraREXMTsWoDge33ln5q/D0eUfsu04m6QsptkpGDVcGR+jyoAzzHe2q+0IRMq+CWyxHOxr+DqWeCsGx7GkPEw84BojZ7PJIjN5FNRxRmH8ZGj6yk4qFigHewGgpQfrzd9iLVFWZsH6pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221728; c=relaxed/simple;
	bh=AvzUZHjxOUYKV1ExT6uFgAJVwhEL71pHp8GmZQ8Uzwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3+Pw5PN4F9+5zGkMRm8w2Rg37dJORnLhQTFP3RF3+7SBMhT96HntdTag4+sYShcSjFDcu8rgZJGYrFUxT856DZx4HIvuHu+lBdE6dFa/v+vHtIVewc83HVhxuIuNcf5JwTNqYHDi+GgAh9dGuvASX8o9LGUMfG4g8BFofHAEls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18KIiEqx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18KIiEqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6661F00893;
	Sat, 12 Sep 2026 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221723;
	bh=GcvN1ArYc6F0l2PgdznvuprHBPaYi4r9vfsTpo0h+TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18KIiEqxqtUiO0rI75sELlrPSNqrdkcbwwhq6JsKavif5Lq+UbfhRSv9Akemlx0yq
	 Q9/BVfL7Sj19aX6syXbPPJbgt56G2kBdH0lKOeuu/nn7EIDDpnLG3exzKUQ3QqRlai
	 LsXpfUShT3TbjVfxHDi/9lh1HUxAIBRxbb2IBuXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0398/1424] batman-adv: bla: prevent CRC corruptions after claim flush
Date: Sat, 12 Sep 2026 08:47:10 +0200
Message-ID: <20260912065616.199516140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


