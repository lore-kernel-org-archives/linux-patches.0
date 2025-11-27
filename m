Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8D131281E;
	Thu, 27 Nov 2025 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255318; cv=none; b=HJrtJLgoplGwAK88zmbeJ20OgAH2ahy/QNidSTWukQHC3FWIa4uG4XUejfuQP+moS2vPBpp7b7LzhL1b8E7eSqhMzYxYT5Vxy/LswNFnyO6NFf8DtbrMil1H4q2o1/KZGosfkeZWAsFsPsAxo0/3QmKSiJXF44+wQueqxT7oURU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255318; c=relaxed/simple;
	bh=pqVfP9kM4umaxv+Hu7WsJ7Ggc6F0QXl15iTmuQE0OzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSyYLAV/zNBTGNBOzDAA1TCIbZmCOYRtS1dEFrEOwsLzat59UcIENr3eEE1MzyJKUpFJOK+K4mFqkYwA/YnknMKYeyezNZPWeRxlJKFt4Ngrggx5q8siR18L6YKTCPcI1gaWvdZq24fdatXHETMzRCTEWUceWP29s5lo5oqsKc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1UH7GKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1UH7GKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9887BC4CEF8;
	Thu, 27 Nov 2025 14:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255318;
	bh=pqVfP9kM4umaxv+Hu7WsJ7Ggc6F0QXl15iTmuQE0OzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1UH7GKVpakXIJhJ48X9S4rae2XmaV47V7VSJJnIPGkGH8ilqVJg4KCSZ9fkstQXY
	 YhoIr27ew+rtQ4YiO3lz/R/kB5C/qd+W0rvEHgdP2xz8EgprVJokETRmXdATAZUBpE
	 B0gYanp7x5QaVZH8oK98JPTQXkBOGz9oUsXEJVEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/112] bcma: dont register devices disabled in OF
Date: Thu, 27 Nov 2025 15:46:25 +0100
Message-ID: <20251127144035.879715310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



