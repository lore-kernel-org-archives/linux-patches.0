Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15241167DB7;
	Wed, 30 Jul 2025 09:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868221; cv=none; b=MuI5USuXwVKnAfPvQLY87yfRpyNyVOv6oRSuXPE1F86+GhpfRyGlgNZGH6vQU0QqXokDCxOGOtjJj4xdbzZE6idwSdBEldoWDbxuKyFo0isBJp511aEmh4Aq3KQdzdHnjweN8tsv9VtfeZ7fqiKql8jdOE8KpX1OKiwE0ZNICEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868221; c=relaxed/simple;
	bh=hJYG803vIwK1rLWL2/0Y8/bc+oNA/9fx3SNJ0ECvP1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSEroPj77gTYzPCORjV7KR9h2Y41lOGK7+Dm6l7tpXaDaaDu4NKhjfUvMTWAwc1WVCtwt68SLvY7VmqMNYZrUhcQ2a+f6bvT7fIhr+xmdcr+EB3QfOLQkAzs4ab2vjRd3EEiD/zJJBkPDDkKWnpVJWuJnsxRufFZA30367a+N4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJwcEK1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJwcEK1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373DEC4CEE7;
	Wed, 30 Jul 2025 09:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868220;
	bh=hJYG803vIwK1rLWL2/0Y8/bc+oNA/9fx3SNJ0ECvP1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJwcEK1m73s1LtN8kKIz0pxpprdWz28OWW8WQvIC0dcAcIQlnPo7GjhRJWuHANBrg
	 qPfcE1OwFnjv7eBnjEkxMST6ZtQt/5u0jEn+Vg/VwGUHE+YV93wtkpNnY8uzR5vinF
	 +ygcoj+VeawXPs4PA53GitLzd80x5mnaE7bOrneg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/76] staging: vchiq_arm: Make vchiq_shutdown never fail
Date: Wed, 30 Jul 2025 11:35:03 +0200
Message-ID: <20250730093227.250959402@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit f2b8ebfb867011ddbefbdf7b04ad62626cbc2afd ]

Most of the users of vchiq_shutdown ignore the return value,
which is bad because this could lead to resource leaks.
So instead of changing all calls to vchiq_shutdown, it's easier
to make vchiq_shutdown never fail.

Fixes: 71bad7f08641 ("staging: add bcm2708 vchiq driver")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250715161108.3411-4-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 92aa98bbdc662..6028558f96111 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -720,8 +720,7 @@ int vchiq_shutdown(struct vchiq_instance *instance)
 	int status = 0;
 	struct vchiq_state *state = instance->state;
 
-	if (mutex_lock_killable(&state->mutex))
-		return -EAGAIN;
+	mutex_lock(&state->mutex);
 
 	/* Remove all services */
 	vchiq_shutdown_internal(state, instance);
-- 
2.39.5



