Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6049C14B081;
	Thu, 11 Apr 2024 10:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831624; cv=none; b=bII9/tDAK1VfXWOqjNfQFTR0MXqPt6dQ10RBwzjA566XgqVYchpZna4M1VhpccVajkbFTFMbjALVWs7QWdpSSrhETIu0knMJv9zE4TpqNPU210hGFa2lMLHiB/s2oMZiFxckOj6aP/MHLRPE4SN9DzdvlLtHWOC1WXFXHzdB1QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831624; c=relaxed/simple;
	bh=QFEtAaG0rwTp5XuDprMiBrczFRrKEn9L3KofHjP8mnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUwZ7DP4NWhNT/8DNZ9c5bGmUMFo5EmIgwY9n/992k4hYYLZqCM5VI/F5N3KIxXe7WGs3r8Rhslx82HzUIVbMIYR9WTv0/ZexrNPdkhCTCFpX9MAb14szRio8OIulS0aNKxxfALv9XScJOMZo774mVH3+HR4bXB0MeIps6Ap67A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NY1BjSD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NY1BjSD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6B5C433C7;
	Thu, 11 Apr 2024 10:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831624;
	bh=QFEtAaG0rwTp5XuDprMiBrczFRrKEn9L3KofHjP8mnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NY1BjSD/8FEyUCJebiGKncEDKE4NsnWDUPE8meRjitE2Q4lfy9KLjgbEr/3mgpbMD
	 brVruRL6zBO8p5ZHT4SrA0YcG6WLQvmSxWjq2zXDJg4dyI7Ik+hHN3z4iEs2X+D6t+
	 0x7sAM1OWEd5XxjoqZUOVkZlDSJXxp1fhD/VzEck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/294] drm/etnaviv: Restore some id values
Date: Thu, 11 Apr 2024 11:53:55 +0200
Message-ID: <20240411095437.862263090@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian Gmeiner <cgmeiner@igalia.com>

[ Upstream commit b735ee173f84d5d0d0733c53946a83c12d770d05 ]

The hwdb selection logic as a feature that allows it to mark some fields
as 'don't care'. If we match with such a field we memcpy(..)
the current etnaviv_chip_identity into ident.

This step can overwrite some id values read from the GPU with the
'don't care' value.

Fix this issue by restoring the affected values after the memcpy(..).

As this is crucial for user space to know when this feature works as
expected increment the minor version too.

Fixes: 4078a1186dd3 ("drm/etnaviv: update hwdb selection logic")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Gmeiner <cgmeiner@igalia.com>
Reviewed-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_drv.c  | 2 +-
 drivers/gpu/drm/etnaviv/etnaviv_hwdb.c | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.c b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
index a9a3afaef9a1c..edf9387069cdc 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
@@ -511,7 +511,7 @@ static struct drm_driver etnaviv_drm_driver = {
 	.desc               = "etnaviv DRM",
 	.date               = "20151214",
 	.major              = 1,
-	.minor              = 3,
+	.minor              = 4,
 };
 
 /*
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c b/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c
index 167971a09be79..e9b777ab3be7f 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c
@@ -73,6 +73,9 @@ static const struct etnaviv_chip_identity etnaviv_chip_identities[] = {
 bool etnaviv_fill_identity_from_hwdb(struct etnaviv_gpu *gpu)
 {
 	struct etnaviv_chip_identity *ident = &gpu->identity;
+	const u32 product_id = ident->product_id;
+	const u32 customer_id = ident->customer_id;
+	const u32 eco_id = ident->eco_id;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(etnaviv_chip_identities); i++) {
@@ -86,6 +89,12 @@ bool etnaviv_fill_identity_from_hwdb(struct etnaviv_gpu *gpu)
 			 etnaviv_chip_identities[i].eco_id == ~0U)) {
 			memcpy(ident, &etnaviv_chip_identities[i],
 			       sizeof(*ident));
+
+			/* Restore some id values as ~0U aka 'don't care' might been used. */
+			ident->product_id = product_id;
+			ident->customer_id = customer_id;
+			ident->eco_id = eco_id;
+
 			return true;
 		}
 	}
-- 
2.43.0



