Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D782DF73;
	Mon,  8 Apr 2024 13:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581662; cv=none; b=Hr7BId38hvxK3S/yyizo9oEtTOTMB1fAoFs94lLnSCencgENDyqV/S/gbzXZzO12RGp2LbPgKhQJ72jSrSf2EtzuGpP+3vaN89nXqOC2NrwQIn1gAHKairSVv+niRUNe1bMjP240YuY2iacNCiFVJax+kkt0lPYYAyi63X1ByG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581662; c=relaxed/simple;
	bh=RAbQW4PvDT8Hr+6UNtacFEER65GiaNyZx4nS5H87ul4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t51oILWP9KelCIv8NmAV6Eui1813FaxT82Qf847ZsOoU8B5hH4+SolSgPsPghEPpT9mEe+IPH3jjTh3+xnwJXvRMHlO8tg9jZ1QYarcFZgEz05atMbiwcBe/+pdq9iJORGVaZIf7vM8FwCC96ZBeipctKHi16zv1S8qKHIL92Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvUF28T+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvUF28T+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4902FC43141;
	Mon,  8 Apr 2024 13:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581662;
	bh=RAbQW4PvDT8Hr+6UNtacFEER65GiaNyZx4nS5H87ul4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvUF28T+MDFWpy9TU6bWVSRQALSawRMuUwK5DgbV4BUuIkc4Norgo3jvb00dX1mo6
	 yAsmSZRFtxHiUrp/RJ7MUh7PQktn9C8PRnEuaMWhcVohAHYz0GrnPPZdu5pIuyJfms
	 JtSPRtho1GFza9q5ht93i9f7YSlNdilNO6hDZQEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/690] drm/etnaviv: Restore some id values
Date: Mon,  8 Apr 2024 14:48:57 +0200
Message-ID: <20240408125402.090400436@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7dcc6392792df..c45e5158fdff9 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
@@ -488,7 +488,7 @@ static const struct drm_driver etnaviv_drm_driver = {
 	.desc               = "etnaviv DRM",
 	.date               = "20151214",
 	.major              = 1,
-	.minor              = 3,
+	.minor              = 4,
 };
 
 /*
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c b/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c
index f2fc645c79569..212e7050c4ba6 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c
@@ -135,6 +135,9 @@ static const struct etnaviv_chip_identity etnaviv_chip_identities[] = {
 bool etnaviv_fill_identity_from_hwdb(struct etnaviv_gpu *gpu)
 {
 	struct etnaviv_chip_identity *ident = &gpu->identity;
+	const u32 product_id = ident->product_id;
+	const u32 customer_id = ident->customer_id;
+	const u32 eco_id = ident->eco_id;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(etnaviv_chip_identities); i++) {
@@ -148,6 +151,12 @@ bool etnaviv_fill_identity_from_hwdb(struct etnaviv_gpu *gpu)
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



