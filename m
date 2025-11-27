Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7453928135D;
	Thu, 27 Nov 2025 15:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255946; cv=none; b=rdP3rxVPghVvsNPIZcRrk0fGvLAdlHLG/BJ6RzSyZChda4eZEgCZ0uOSGwq8JW4wKidOE54WFiQ1PetnpCZNQJuYnUvXfj6cpk7TrNBZs8oY/lSeLfjX/qSRagyOZOrhphpsBEzLdsLi3sHb9FNvwP1ftCE366NyRPAaOwTFuww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255946; c=relaxed/simple;
	bh=zSW6i8GQvJVec330s4nrHUvtKnf52843w3UR/tYFKhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jngKYC6LmQhtGn3ABu1z1o2nC8vT+dKrYeG1SdiFiFmN9XtsCreJZPjTq5Huy5gT03zQjgEjtQ7/MR/jEzqy5xyHSsVwqKC5FbsmLyE6u13yQPdrfAfDGLiObhwWOL9vtX1z/onaD6MzY816xmENq3AibxF0mYS7WfwucysI4mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u57MX+BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u57MX+BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED357C4CEF8;
	Thu, 27 Nov 2025 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255946;
	bh=zSW6i8GQvJVec330s4nrHUvtKnf52843w3UR/tYFKhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u57MX+BYE9dl8wsDQ60/4O426K0rnYY5rVXgh+OwpgJcZggTKdlPI5YZTZKknU3cg
	 ePHchDgpBvfO0yLxQm3fneTZ+jwWZtMCrpfQ76FsT6mfMwwsN/7Hv7+7mzBkkLz6bp
	 Y4toYD4/eOARfWC41nhjDaT3kXQOtscOnmvx2XVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 136/175] bcma: dont register devices disabled in OF
Date: Thu, 27 Nov 2025 15:46:29 +0100
Message-ID: <20251127144047.925670756@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 6ecfc821cf833..72f045e6ed513 100644
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



