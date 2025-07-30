Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060FA277CAF;
	Wed, 30 Jul 2025 09:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869026; cv=none; b=PpKIGKzSGQF/VuTfNr2ef2b1iM9HqrIFwP2acR8ambtM+6Fj0F2aJSpeAOtaimBXquy7WWKRgWgrrgvnGs2hkQYEyBe1ZgqG7c0rssWy7qlxV8ZLIphE2qOm5rgCajagt5Fqpj4/aoThZN6Z8c2PTU59nNBHOcwOiKpimReh4hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869026; c=relaxed/simple;
	bh=c7fjIHT83/2l3Q4exOXv6h+zP+uMZ2jknDM3tpTZgHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh7Dt+kB8ArvlXvBiLafxUtjLRsKm8q+Pisvd09gzDX2DTYBipOBRaOTvJMI3bRE8aax9IYqofdmKZv7NUOtP9VL7FZGKHXScq3BLPQ3xvB3548O6nSW///8yLj+hR2q210qMf7bCRl1/Xcb95O9CAOIBv2mpgihJzBRY8gCm9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZRxB8lg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZRxB8lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF329C4CEF6;
	Wed, 30 Jul 2025 09:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869025;
	bh=c7fjIHT83/2l3Q4exOXv6h+zP+uMZ2jknDM3tpTZgHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZRxB8lgqWddvQ7R/ACPD3FioFbchSJr4DpTq7hbrgb8d5Ne5huXk3SSZeXgyhVvK
	 BuLf7dIm4cV6AyoMwnedrGEpcAp8pKS007KzkeDHZeonkPfceCSGNLBKoEKtg4w6YV
	 q/kRivoZj3Qqn6a4Gl5p1NfPbyBY9Bw3l5dfrZbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 19/92] staging: vchiq_arm: Make vchiq_shutdown never fail
Date: Wed, 30 Jul 2025 11:35:27 +0200
Message-ID: <20250730093231.358828398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6434cbdc1a6ef..721b15b7e13b9 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -393,8 +393,7 @@ int vchiq_shutdown(struct vchiq_instance *instance)
 	struct vchiq_state *state = instance->state;
 	int ret = 0;
 
-	if (mutex_lock_killable(&state->mutex))
-		return -EAGAIN;
+	mutex_lock(&state->mutex);
 
 	/* Remove all services */
 	vchiq_shutdown_internal(state, instance);
-- 
2.39.5



