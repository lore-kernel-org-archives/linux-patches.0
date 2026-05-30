Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E76426738C;
	Sat, 30 May 2026 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166273; cv=none; b=O/mc8PytHZDoDsN/MLj9u1RfvT4I4CBBXh9W8WgZQn7wjYsMx4eXO01/kZ9VPAD7YkAeETAnrD2udGccspjghQXNEp21A0NJvnPv8hfN9zd4eNTSujduaMDgtZiY6MVvsLSPLRfbY1NQQsFoOJdzZ9sNaTwFZodUd4Q2eOuZrO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166273; c=relaxed/simple;
	bh=ECYB+aGkzF9WsPzTrOzHVZ3e5r3TLPY75Ko3EfRxb8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2Z5G/sBicyRU8dyfJNwbhmBGXKWU+azuXvS5djVBHGjRi5c0HRpKWApQpzqyA78ofAH4QxXH5kMEsgEDYD5i30rVYnOyY+oSLWKPSe7VdZ5eRlgYvWxzzx+EBQuqKznffnTwKks7YqfGYO5/Gzh+eYAluWFTamRRG3l5/sLP4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xApAxu7h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xApAxu7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52E11F00893;
	Sat, 30 May 2026 18:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166272;
	bh=wcAtrrKPJNnaODl4VPVmRYURvmUbOZLVM+IROxTduIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xApAxu7h//IrPBt8YFySB+5fS+aLj/KWl5XU2cK4z/UBnBIR4pFwwjhG+ginEVhJa
	 eNmZjGRXwz1ysD+CPK3V09YVHFE6PviiMJmM85TXMDjbSqx4RCvM9hM+JcIv/rZcqQ
	 UZ3NK8aXlVH4NnOgS9m6nITiZim3yuBUfGFG3KJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 286/589] batman-adv: bla: put backbone reference on failed claim hash insert
Date: Sat, 30 May 2026 18:02:47 +0200
Message-ID: <20260530160232.464660348@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -728,6 +728,7 @@ static void batadv_bla_add_claim(struct
 
 		if (unlikely(hash_added != 0)) {
 			/* only local changes happened. */
+			batadv_backbone_gw_put(backbone_gw);
 			kfree(claim);
 			return;
 		}


