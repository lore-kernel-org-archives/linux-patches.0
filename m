Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C9A34BA50;
	Wed,  3 Dec 2025 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780236; cv=none; b=qFryn/g4+OTj/CKBIzVI0I0xLedTDAjJ1ZTIrTah3aRch8RtfuC0+OTOmr3D0aaEv8Rw77TeyvmaRvudyN1ZP9O5BzpfwzeV/6/S8TGZe/FF4TA5uBe2MAfXeS1SQExuDYR0dIzZIl4tIvx4jwHUUQHfBupw7av4rhtmREaZsKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780236; c=relaxed/simple;
	bh=wBt4C7eAH8/NoNwXmTb1Uvh5fOPwKoweOoOl/Kx1SWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAOh0VY9//dIMfzSrrETB4o1Mnyx+TR5uazQmhG6pj6JRVXwERPdT4AclcqbyLCUPYUuH44LAAGKkZKwlChuuWqp5GJvrVqAyB8MDARCSsrMviAOcQqznPDpg6vdi9pu8vq/T9tpy03rNJE8fogpt2rxqEdwHpPx/SAyFaiMCDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoWDhJId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoWDhJId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB61C4CEF5;
	Wed,  3 Dec 2025 16:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780236;
	bh=wBt4C7eAH8/NoNwXmTb1Uvh5fOPwKoweOoOl/Kx1SWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aoWDhJIdVpQ/nvVNmTmHUylW3UTp75yJILkHUrLYRWYEDx6vXz5G2E8yByiRvy65U
	 KIv07tX2wQKnRskAQl2Ng3uQQB31tqd0WqLnAxkqwqAse3FoEm8fRB1+g7ike4G/Mq
	 evj+XM8rGNN/HZ1BHopSuxv1icF849ur9N7Km+WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 464/568] bcma: dont register devices disabled in OF
Date: Wed,  3 Dec 2025 16:27:46 +0100
Message-ID: <20251203152457.698226521@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 44392b624b200..11fbae15a7884 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -293,6 +293,8 @@ static int bcma_register_devices(struct bcma_bus *bus)
 	int err;
 
 	list_for_each_entry(core, &bus->cores, list) {
+		struct device_node *np;
+
 		/* We support that core ourselves */
 		switch (core->id.id) {
 		case BCMA_CORE_4706_CHIPCOMMON:
@@ -310,6 +312,10 @@ static int bcma_register_devices(struct bcma_bus *bus)
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



