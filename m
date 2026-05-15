Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3855930569C;
	Fri, 15 May 2026 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862849; cv=none; b=SMb3Lh6eQQMs7IP1S6SqstgNxXXfeXE8+TCaNCbtY2vz0qhhDZ2cEV3SLicT4Ww8v5tpfZ7vfW00DpgB5skLnjgG35EJCRi+NJsNRqNhJZ1FyhUhlHP0S3a28D0SMHlaPBJjxEzEIyryzARlfJ5Trfi0IHCwPEBN8qhkHKsnz0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862849; c=relaxed/simple;
	bh=9B37TAfNIwbXS/NphVfElra9DI3K+h6NxFLjl+/8jPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aToDDtzVonBaRWrHJ10vxMt7rFoEDB4IHb4W8zlh5ubG+iC4VJQrQVOaYtivFxTjhsKor3Loi3kbHFehEQKOV+u6xFvYqM4ILYLyJBocPZO/Os01HEOWkqNjkyJu0qb97EVl6430YR4pgOPkD+Xsr5lS84jJbFKxbE3IY2DDuSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7gZWmBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7gZWmBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3065C2BCB0;
	Fri, 15 May 2026 16:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862849;
	bh=9B37TAfNIwbXS/NphVfElra9DI3K+h6NxFLjl+/8jPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7gZWmBWskRFnWgaO5N5m82DwSHUKbXwEM/fAU9vtWDPoMS6eI4/eYx9gvccuJ+J/
	 KyNAPz2S3Pi9DtppCkkcTXo/lNLPNxVnI9TA5Kli4y3NrIcmeicdE6fiXgknPfvwpQ
	 NnSGiMDKNSdflvlWNM0c1D+prZoQzYtc1cntUT2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 180/201] batman-adv: bla: put backbone reference on failed claim hash insert
Date: Fri, 15 May 2026 17:49:58 +0200
Message-ID: <20260515154702.475521066@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -723,6 +723,7 @@ static void batadv_bla_add_claim(struct
 
 		if (unlikely(hash_added != 0)) {
 			/* only local changes happened. */
+			batadv_backbone_gw_put(backbone_gw);
 			kfree(claim);
 			return;
 		}


