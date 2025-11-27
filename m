Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC3D28D8E8;
	Thu, 27 Nov 2025 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255018; cv=none; b=EUVHhAMYOb4GDurgXbObtPVaQzvnDoFluwzT2mwS2N3L94Ma8CGPQ5G7YOjSGkhoGfKnlCS1TkGEtXZal5TNxFI7st3pQnH2bGgb5SR3MzTN1U87Adawxc/g3Fz32sVYiFsJmNR6cbGTA3T36NCyFIr8PbxAhYvLM+72GijnDBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255018; c=relaxed/simple;
	bh=NipJ5OPeKjushSC6D7xGBZWhs85S7LvIx2YP5zt0A3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q3IGpCBaDOff9abgsOM6uWXH/hHYZ7t4acBGmH4PqpqLodvVMyNGJrmz3uO4Y6e3XMjtgmECJKGieHFB2fFTUweJhPVOmzDO/1hII3jqJxa93qWDa6tZuJCfvP+z6mqkxW+E/CSdvDJao/aLui8ELtO/M/JxmVeGkdGwixh5tz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0f/Zel7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0f/Zel7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96856C4CEF8;
	Thu, 27 Nov 2025 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255018;
	bh=NipJ5OPeKjushSC6D7xGBZWhs85S7LvIx2YP5zt0A3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0f/Zel79O01S/eZ3l29ZsNS7GwDX7OxHm+m22K4qcZUYkpDqqrysNi3m45Um37jo
	 uQ1eVy1UGPPPmFm+tuwQpMKa6yIDJjheeTaRlB4qjSaZUWt/MhegWNivt8T+r2xMiJ
	 BuTh4jZUY8r09RMhL5h1N1Ph7JrVAiO0m3yla+44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 58/86] bcma: dont register devices disabled in OF
Date: Thu, 27 Nov 2025 15:46:14 +0100
Message-ID: <20251127144029.951485166@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit a2a69add80411dd295c9088c1bcf925b1f4e53d7 ]

Some bus devices can be marked as disabled for specific SoCs or models.
Those should not be registered to avoid probing them.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251003125126.27950-1-zajec5@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bcma/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 7061d3ee836a1..c69c05256b59f 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -294,6 +294,8 @@ static int bcma_register_devices(struct bcma_bus *bus)
 	int err;
 
 	list_for_each_entry(core, &bus->cores, list) {
+		struct device_node *np;
+
 		/* We support that core ourselves */
 		switch (core->id.id) {
 		case BCMA_CORE_4706_CHIPCOMMON:
@@ -311,6 +313,10 @@ static int bcma_register_devices(struct bcma_bus *bus)
 		if (bcma_is_core_needed_early(core->id.id))
 			continue;
 
+		np = core->dev.of_node;
+		if (np && !of_device_is_available(np))
+			continue;
+
 		/* Only first GMAC core on BCM4706 is connected and working */
 		if (core->id.id == BCMA_CORE_4706_MAC_GBIT &&
 		    core->core_unit > 0)
-- 
2.51.0



