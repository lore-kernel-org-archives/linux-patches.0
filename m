Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076EE2D9ECB;
	Wed, 30 Sep 2026 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794036; cv=none; b=O+iI3voinQDCusq6yt0pMbCRbMOF1CLN5aPAEFzba/hobUUXkq6CH8bMa8P9iu7aabkQ3AsG7QxT1+vwJ6M2JaOyyHyM/WBmqeCa8XdY0SfrnQ0x/U9qPbaRVf/LAGtNs8q7CbUayTW3tCEP8gEW/GUzwyi0dgleKfr7pAtQLLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794036; c=relaxed/simple;
	bh=y6XEtiLe8XbRtQhxfSQNEGicdJ2UhKKFa01v5sGDGr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOAPR4sGxp8g6LFndSR8S3jR8oZecjegStZpWlbrCz1y8aZAEhFmMFiMYqvANnORVRCTEr0DUPVIO+Yrx6Qg5ka6qPR8rWVlwtO81JgKY7HNHltn03gYbQQa8JTddRoG4d+NnBj/UWBYuspGCzvPpS5sSTzaFXWy3euPrlw8Aa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kg8YuWZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kg8YuWZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6045B1F000FF;
	Wed, 30 Sep 2026 18:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794034;
	bh=bP/dssZz+Mzri7zXV675Nv5ClXJ2cbN0Y40e2YSUw4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kg8YuWZA7FBHvQ08uP9tdW3VpDp4f+zGEl1ym2GtmFaVb5JgQ113IV9EEgdVir+Yn
	 q5F42JsnzidQtUrwz2gi646yWri1UqDH+4El76kUfJyPxJU4LH7zcrbMFPcf/TGdmS
	 zf3rYAJSZhgktyuB2d4F8xjBkcAF+r525kx94go0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rene Sapiens <rene.sapiens@linux.intel.com>,
	Pooja Katiyar <pooja.katiyar@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0070/1193] thunderbolt: Dont access path config space on Lane 1 adapters in tb_switch_reset_host()
Date: Wed, 30 Sep 2026 17:12:34 +0200
Message-ID: <20260930152435.821929446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pooja Katiyar <pooja.katiyar@intel.com>

[ Upstream commit 95c4379e37a0abea72dfd389cfe2c54452523690 ]

USB4 Lane 1 adapters do not have accessible path config space. Skip the
path config space cleanup in tb_switch_reset_host() for these ports. The
check is for USB4 switches only. Thunderbolt 1-3 Lane 1 adapters stay as
is because we do need to program their path config space.

Co-developed-by: Rene Sapiens <rene.sapiens@linux.intel.com>
Signed-off-by: Rene Sapiens <rene.sapiens@linux.intel.com>
Signed-off-by: Pooja Katiyar <pooja.katiyar@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/switch.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index df83383800a8e..e9a627a161c53 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1576,6 +1576,12 @@ static int tb_switch_reset_host(struct tb_switch *sw)
 				ret = tb_port_reset(port);
 				if (ret)
 					return ret;
+				/*
+				 * USB4 Lane 1 adapters do not have accessible
+				 * path config space.
+				 */
+				if (tb_switch_is_usb4(sw) && !port->usb4)
+					continue;
 			} else if (tb_port_is_usb3_down(port) ||
 				   tb_port_is_usb3_up(port)) {
 				tb_usb3_port_enable(port, false);
-- 
2.53.0



