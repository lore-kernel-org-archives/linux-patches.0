Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BA018B0A;
	Wed, 25 Feb 2026 01:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983340; cv=none; b=Px8DZ7rDAg2JhPvOMkguWpP7WcHZnfFGxb8x8FZZSkP1K+iTUoqlXCUH+0yxtvXZWGdpP3hrl9tJ5PE4p628eCDsKE+gNmAiJkF9tw3TDukHleW3nVNfUfRYRmEz7EJQfYIQsn+DWQmC/d0aXe3+29ZvSfFnxN2XHvz3ZoIHWGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983340; c=relaxed/simple;
	bh=+sCBBlUVKPO9w99KSTTPAwhFmFjgan1j6w82oNYIBs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is0emx4fTwi/eOo8KSMmy3HI+QX0vaDrB+9ETBjwEMJyffKhDyaKx2/2UFV6gWSGouaKK5i+Tx5SCVKtkgCwTh/y++8KEzBRmVsTxKmepCqm5L+vJdueHpzwAQ5QSb68MFdtNkhUJHWNmP2jYTTREikAUyhoAsHqXrWT8T4pgnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQnuPkL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQnuPkL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F242FC116D0;
	Wed, 25 Feb 2026 01:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983340;
	bh=+sCBBlUVKPO9w99KSTTPAwhFmFjgan1j6w82oNYIBs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQnuPkL96nq1JObaSX2Wlj5RlBoONbVv60SFiHQyn50RzhodH2W0AipgwZFCsN/8j
	 lTon1ZryPm48JOnRA/+6yKgbCnk5987A+XklzT9+a1fJqpc4AeB37Nod0ZLJ2cxfxH
	 7+Fa0/C89MQzfEO1XaG1bC/1W0zsu1Cu/EfGK2Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Raag Jadav <raag.jadav@intel.com>,
	Jani Partanen <jiipee@sotapeli.fi>,
	Lucas De Marchi <demarchi@kernel.org>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 469/781] mtd: intel-dg: Fix accessing regions before setting nregions
Date: Tue, 24 Feb 2026 17:19:38 -0800
Message-ID: <20260225012411.323268329@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 779c59274d03cc5c07237a2c845dfb71cff77705 ]

The regions array is counted by nregions, but it's set only after
accessing it:

[] UBSAN: array-index-out-of-bounds in drivers/mtd/devices/mtd_intel_dg.c:750:15
[] index 0 is out of range for type '<unknown> [*]'

Fix it by also fixing an undesired behavior: the loop silently ignores
ENOMEM and continues setting the other entries.

CC: Gustavo A. R. Silva <gustavoars@kernel.org>
CC: Raag Jadav <raag.jadav@intel.com>
Reported-by: Jani Partanen <jiipee@sotapeli.fi>
Closes: https://lore.kernel.org/all/caca6c67-4f1d-49f1-948f-e63b6b937b29@sotapeli.fi
Fixes: ceb5ab3cb646 ("mtd: add driver for intel graphics non-volatile memory device")
Signed-off-by: Lucas De Marchi <demarchi@kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/mtd_intel_dg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/devices/mtd_intel_dg.c b/drivers/mtd/devices/mtd_intel_dg.c
index 2bab30dcd35fd..7f751c48a76d4 100644
--- a/drivers/mtd/devices/mtd_intel_dg.c
+++ b/drivers/mtd/devices/mtd_intel_dg.c
@@ -770,6 +770,7 @@ static int intel_dg_mtd_probe(struct auxiliary_device *aux_dev,
 
 	kref_init(&nvm->refcnt);
 	mutex_init(&nvm->lock);
+	nvm->nregions = nregions;
 
 	for (n = 0, i = 0; i < INTEL_DG_NVM_REGIONS; i++) {
 		if (!invm->regions[i].name)
@@ -777,13 +778,15 @@ static int intel_dg_mtd_probe(struct auxiliary_device *aux_dev,
 
 		char *name = kasprintf(GFP_KERNEL, "%s.%s",
 				       dev_name(&aux_dev->dev), invm->regions[i].name);
-		if (!name)
-			continue;
+		if (!name) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
 		nvm->regions[n].name = name;
 		nvm->regions[n].id = i;
 		n++;
 	}
-	nvm->nregions = n; /* in case where kasprintf fail */
 
 	ret = devm_pm_runtime_enable(device);
 	if (ret < 0) {
-- 
2.51.0



