Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FE73033F4;
	Wed, 28 Jan 2026 15:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615455; cv=none; b=I3qEr/FNOdHtBJsni+uRUgT95RPOlH9WjP+Qiv+zWzmVtPnDpW4Go89z/nhThMZY6J+4RvnrWwwqpK/CzxjgGIjWXmpWHKEr19md9DYrod1u2ZfHp/sDFi9C0DPBulJQCGAueG4rxxXsAshe/ifSxMpJdhP3VhRhOjgdzoPhlq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615455; c=relaxed/simple;
	bh=8bEYkkeM27xq1ln76w0J2gogAxCckDwrft2marES+Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uxzaq7qvV+D+93MK7cLy70qiso36ZDwNu+AN0XyTtFtQFcpFqccc5ICVTu6BgV0HVbVnSDrUSof9mqv3CIpgfMx9e1VPgEVHC3LYC38Iar2tVbo2diajuC+5+gaew2vcKwMaUKOV3fiiaBGNlUIhxzrVGaeuOIb4OHkI6gcUSTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vm/vHTR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vm/vHTR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5238DC4CEF1;
	Wed, 28 Jan 2026 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615454;
	bh=8bEYkkeM27xq1ln76w0J2gogAxCckDwrft2marES+Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vm/vHTR53YNitnChs/86p6BB2wZ4tg9qIGH1Nn+bPhuQc9oSVNHv6VUABx3BflVRZ
	 69f6QKz7KlIgjBRGY50Y8U9y6/boK2yXLi3BVdh4XonuIFqepHnjia0Q/eOKZHvkm9
	 wIBmnEy8jJjEL4Vh2Aown0DoSyFAyZqJjQ5JVku8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Wolf <wolf@yoxt.cc>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/227] ata: libata: Add DIPM and HIPM to ata_dev_print_features() early return
Date: Wed, 28 Jan 2026 16:21:00 +0100
Message-ID: <20260128145344.891933097@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 89531b68fc293e91187bf0992147e8d22c65cff3 ]

ata_dev_print_features() is supposed to return early and not print anything
if there are no features supported.

However, commit b1f5af54f1f5 ("ata: libata-core: Advertize device support
for DIPM and HIPM features") added additional features to
ata_dev_print_features() without updating the early return conditional.

Add the missing features to the early return conditional.

Fixes: b1f5af54f1f5 ("ata: libata-core: Advertize device support for DIPM and HIPM features")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Tested-by: Wolf <wolf@yoxt.cc>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 490cc0d628d3b..c41714bea77e8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2872,7 +2872,8 @@ static void ata_dev_config_lpm(struct ata_device *dev)
 
 static void ata_dev_print_features(struct ata_device *dev)
 {
-	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK) && !dev->cpr_log)
+	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK) && !dev->cpr_log &&
+	    !ata_id_has_hipm(dev->id) && !ata_id_has_dipm(dev->id))
 		return;
 
 	ata_dev_info(dev,
-- 
2.51.0



