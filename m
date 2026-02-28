Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF77371449;
	Sat, 28 Feb 2026 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301471; cv=none; b=uvEGI5ALD2rYp7Yc3h7UJaBNWC6OEKSPU8ff/B5LCsbYotlTInTFCJRhWNP4tkpI9L22U6C3lVK2ulMbVvcs55S0OysgRHJRPlZtsjmEKQzY2W5O/Ea/81kWV3iD2gX1OWZ5XYBpB3MR+VPiIQ0FJR7anUZ4DOvdEUGNhtV6LXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301471; c=relaxed/simple;
	bh=PcxMPwpxFZ+J2wZVU9y8X8w9Nr5Lk9irTFl+JPZeKz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSdyftn0km795k6vCeVyJZuzMVsaeeS4Ix5QqSKJ4JPy7yr3++gFjx/R+3ENn4FaqDnoVumTn1Z4NBfutUyIVi6fIGaskDpt7Gznfd/Z2ADVbXYynzrwP34NYIwGFH0jbcm6Wj3I8uJ7Z2Z3HjOFNOADxxGWdRZP8P7SveAVjUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUB1Jk/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUB1Jk/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871C2C19423;
	Sat, 28 Feb 2026 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301471;
	bh=PcxMPwpxFZ+J2wZVU9y8X8w9Nr5Lk9irTFl+JPZeKz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUB1Jk/3okdz0WisQzTAT0+u9HKI8AiIwYPkGldJ3dzj75IjzQaSrIwo0mzAW5i87
	 L+4G0tgALGrD+zTsiA27HtOW7rGYXsmX+kSiBLdrK2MWnU9c9BZX5Z3yfrYakPdgeV
	 J37lvN0D0QXIG0Jo2McA0pRCGRngV2AuelzOriP+tCSG+x6B29gRSHBbiPCSCWxs8X
	 trwmypGs6iSTGIx6MDiOSyOYvxT190cSd3REycQ9pSCWLYAgc1ZOvaptGiBvQ1XhCe
	 N36k1irqwWDM2FrU8r4BOJzj+Ua3b3fK/11mNeNylvcTigBQV+oTvLVwtOf9ba95TE
	 SS/eWYvq9kv5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Peng Fan <peng.fan@nxp.com>,
	stable@vger.kernel.org,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 656/752] remoteproc: imx_rproc: Fix invalid loaded resource table detection
Date: Sat, 28 Feb 2026 12:46:07 -0500
Message-ID: <20260228174750.1542406-656-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 26aa5295010ffaebcf8f1991c53fa7cf2ee1b20d ]

imx_rproc_elf_find_loaded_rsc_table() may incorrectly report a loaded
resource table even when the current firmware does not provide one.

When the device tree contains a "rsc-table" entry, priv->rsc_table is
non-NULL and denotes where a resource table would be located if one is
present in memory. However, when the current firmware has no resource
table, rproc->table_ptr is NULL. The function still returns
priv->rsc_table, and the remoteproc core interprets this as a valid loaded
resource table.

Fix this by returning NULL from imx_rproc_elf_find_loaded_rsc_table() when
there is no resource table for the current firmware (i.e. when
rproc->table_ptr is NULL). This aligns the function's semantics with the
remoteproc core: a loaded resource table is only reported when a valid
table_ptr exists.

With this change, starting firmware without a resource table no longer
triggers a crash.

Fixes: e954a1bd1610 ("remoteproc: imx_rproc: Use imx specific hook for find_loaded_rsc_table")
Cc: stable@vger.kernel.org
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20260129-imx-rproc-fix-v3-1-fc4e41e6e750@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 8424e6ea5569b..7ef99eac37f1a 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -608,6 +608,10 @@ imx_rproc_elf_find_loaded_rsc_table(struct rproc *rproc, const struct firmware *
 {
 	struct imx_rproc *priv = rproc->priv;
 
+	/* No resource table in the firmware */
+	if (!rproc->table_ptr)
+		return NULL;
+
 	if (priv->rsc_table)
 		return (struct resource_table *)priv->rsc_table;
 
-- 
2.51.0

