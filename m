Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0731E1DFC;
	Wed, 28 Jan 2026 15:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614996; cv=none; b=YOG8HnKg5P8up3VvSnVzyx1TwzF66djHoWlwUeng9kEcuSP93BkKNnl/u5tF9vGHes2laSMVxV8TlCBDoB0qPJhbYb8C0YyN5kDvaaO74aO6Lk/Mwj0qVxk4izzpICWn+p5iZYLlJ3uET9sBkrep8nKjQ2sZviHMxM0NSjQBto0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614996; c=relaxed/simple;
	bh=bUK1aUaXyKCWxJ/CWwgGPcSOmXnHFbXS1wUKJNrHQnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuP2jMPmfa/1PSEgIw8npzdYLHvVQCU5av+PeDTZrX6b+jXl+AilTsPT2v4981vpWvzwAGlRlclmvgVoc3wOAqr5vGjFMlRLxJazF5RKJDndXRLdARnyinwh44Bms1ht6UuYG2C2SIMlmajHbA4BwopqAdgDwfmgVawUAHxhjYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5ccmWcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5ccmWcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E5AC16AAE;
	Wed, 28 Jan 2026 15:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614996;
	bh=bUK1aUaXyKCWxJ/CWwgGPcSOmXnHFbXS1wUKJNrHQnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5ccmWcveB7kdZ6O/E8JiCQe4A9aNc0Ww6lwacUt64/wHsKm5qDOQodWlb5YIwxHZ
	 352yXoV2P+OnEYrI37qgJHmpOyo9ZO74xZ85s/ky9WGCWNk99TClC5IwpRBALM3Adu
	 RNjhG1lyK6cXml8P+7NPz9bC+wmS5MQV628IisO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Wolf <wolf@yoxt.cc>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/169] ata: libata: Add cpr_log to ata_dev_print_features() early return
Date: Wed, 28 Jan 2026 16:21:38 +0100
Message-ID: <20260128145334.564777055@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a6bee5e5243ad02cae575becc4c83df66fc29573 ]

ata_dev_print_features() is supposed to return early and not print anything
if there are no features supported.

However, commit fe22e1c2f705 ("libata: support concurrent positioning
ranges log") added another feature to ata_dev_print_features() without
updating the early return conditional.

Add the missing feature to the early return conditional.

Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Tested-by: Wolf <wolf@yoxt.cc>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 802967eabc344..864248ff1faf9 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2803,7 +2803,7 @@ static void ata_dev_config_cpr(struct ata_device *dev)
 
 static void ata_dev_print_features(struct ata_device *dev)
 {
-	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK))
+	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK) && !dev->cpr_log)
 		return;
 
 	ata_dev_info(dev,
-- 
2.51.0



