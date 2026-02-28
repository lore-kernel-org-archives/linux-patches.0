Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9B933507A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302050; cv=none; b=bBqbiUX6nnWIRCwc4uwjXIS9jfx37uLFharsBbGJmDO7USNG6ZdY//k8LB13dq/84Z9EC4iY6jPpSggPFPiAkRGCn5y6vbkJ4OpGRYXveL0xoWtpIlmw8IIAoWoWhz7gcUMft2mk532JEbS1RfyPnXe3M9xPY+o4pRJW7FX/qNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302050; c=relaxed/simple;
	bh=RvhD8zbGihcWsqvIXbzWA1Ifvnrg/yMHIYBvGwHru/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOj8zYkQZhe0leZiI0kQa4iMu4s0i2v9JdDK+PigBlh43ej2CFHyRqgkd/EEJJiz+4AMQJSQHfK094cMeSI28O+1ajxVrbdaK8FEzu0KJPVOVzQOu6gFtXRfUqaDshneK7G09hA7zVWY/nkNKGN1VAqiDgVC+IYZUVeibkhxK9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRi1I/iE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRi1I/iE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29E9C19423;
	Sat, 28 Feb 2026 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302050;
	bh=RvhD8zbGihcWsqvIXbzWA1Ifvnrg/yMHIYBvGwHru/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRi1I/iE0m52vSfyNviNDVCyQwbocnZ1yWNu53POlmvpsl0czKmEg4zkghFtfLg9H
	 MUXqt2CIwea6uIOuELnKiWinJBhbrudF7nFMCXZ+leeNfQop2jVGdoz8jFrTrCGyay
	 WaPEQeAlJXIJ/Shdv2g6pjwN0lkA0rHoHltwFWhK+OQy9fL7WA+aEAW+zAir0it16p
	 VM2TilVpUbsyv/fPrsDNKPcqldG+gQL2qc2pPok5oHTJraCKuxTFbOdcijWS/0HZMC
	 6aX9ilNZxAkTe3c1HZWfz+XTLvOOiD7F0isv9zANNOBt1eNKR5ITIwd7CNyvEd1H3a
	 PuzbwgfBqp35A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexey Simakov <bigalex934@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/283] ACPICA: Fix NULL pointer dereference in acpi_ev_address_space_dispatch()
Date: Sat, 28 Feb 2026 13:02:46 -0500
Message-ID: <20260228180709.1583486-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit f851e03bce968ff9b3faad1b616062e1244fd38d ]

Cover a missed execution path with a new check.

Fixes: 0acf24ad7e10 ("ACPICA: Add support for PCC Opregion special context data")
Link: https://github.com/acpica/acpica/commit/f421dd9dd897
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3030574.e9J7NaK4W3@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/evregion.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index cf53b9535f18e..7788c27ccf461 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -163,7 +163,9 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 			return_ACPI_STATUS(AE_NOT_EXIST);
 		}
 
-		if (region_obj->region.space_id == ACPI_ADR_SPACE_PLATFORM_COMM) {
+		if (field_obj
+		    && region_obj->region.space_id ==
+		    ACPI_ADR_SPACE_PLATFORM_COMM) {
 			struct acpi_pcc_info *ctx =
 			    handler_desc->address_space.context;
 
-- 
2.51.0

