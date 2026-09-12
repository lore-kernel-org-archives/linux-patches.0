Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E353382CB;
	Sat, 12 Sep 2026 19:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242113; cv=none; b=o1yWiPPEYvrgHmVq+gHDxa6LAa5X5kXRACeFp+iSkHUEbLLDAu5hQTO7Md0vzQ2OO1pYr9Y91st7YsqIcALNE2Mre8u+6/N+A9nqWk5hGrDfqWM6Ocfi+Ae6SiTKbiw+TbWz3WhS/uDggJUPPaG+TKyiegZ4FVrcWotPYtFzNh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242113; c=relaxed/simple;
	bh=4tnpveNq5r5GHouquEJsyJ6eMIQJ+3sztnazv699SAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwxnLAbc8zOkUCeLHkkgDwyMRGW64hWkvYaY+ThLsJalcVxN1aq3RBcQzS/V9bUg4ae0U06uXHBTYbe2tOJnpd05wWR5pbAyMb6U5EfZmatKLHRAH2kEXRv9g3cX7jmwmkq8CCPHjgmM9c+s4S0saH1e2sVXKoRPlJd0oeowuYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPFAlIVR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPFAlIVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282C91F000FF;
	Sat, 12 Sep 2026 19:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242112;
	bh=udFt8GkAGLiolpdVmCb199I+7nlGR02zbRRYEx10E4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPFAlIVRllNfpQyguRVgqTs9htf+zQnuJd84hI9eHXhNJCegplyeJ0aDA9Yeu4zN9
	 cEm9I2MH7RemGD82G6KUjct6knxdRduRNn2bhlhBWKCGQ8rRs618XzS69mJlnPJFPI
	 /gat2HE/Wj7vxUdclmZutqyrPywTDb58GOtOo74U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 247/798] batman-adv: bla: prevent CRC corruptions after claim flush
Date: Sat, 12 Sep 2026 08:57:55 +0200
Message-ID: <20260912065522.819002499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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


