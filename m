Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437503E022C;
	Thu, 17 Sep 2026 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667478; cv=none; b=Mj7S4NOy/h7SiSj3aBUJzJr/kojBl4T2S9K3UHbtl6bMC7tAf7LQaoQF7J7rNhkOIIxo35mGPg5tCq5bCdOYIemKN/1VOCfpp3hD4pz6Kd0/RjtjWf5UJhUWk9HuUfbr70yXgmVaPXF33lD0WPqvFBwXjksrOulTB2xWVHoLJD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667478; c=relaxed/simple;
	bh=4vbs15YAYkBZE7t8hytmILlbs1+faRdF5LMvbV2k+z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5vW5CIn9OKmBFkqVG1E1BQE2xTwWxfBzCbcxhfpL+LHJPfHeO8vSmoDb3xTDkz7xrZCTDonvAA4nb1Wp6Hm+tTyzYms6+fPYeYvyD1NVEdNimvtADT8GMT4mwdZ6PXX5Ut4qrBIeb4ntqKgC/PJzRuJV0PE2GLvV7QD/3JTZTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KC4SWutj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KC4SWutj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE2B1F00893;
	Thu, 17 Sep 2026 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667476;
	bh=J6pVq9gIp9K8K8bQMqFk63Kt6Pmn8l92O8Y/GpcLVpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KC4SWutjmI/igfz8uVONU9CKhcgJvYrRV94Xvb0B5pLxAkrEosejUOhgeJlogoQbk
	 hD9BzvSmIVjqlX7VDKab2iUy8abNv/plmezN2z+AlRkp2uQehb941SbCLFatOvS+VN
	 lYNc4piRGc/Spi1vAMT3apMi3lUSa46H+qWL3Nw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rene Sapiens <rene.sapiens@linux.intel.com>,
	Pooja Katiyar <pooja.katiyar@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0106/1102] thunderbolt: Dont access path config space on Lane 1 adapters in tb_switch_reset_host()
Date: Thu, 17 Sep 2026 16:00:49 +0100
Message-ID: <20260917151542.160464692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 60818c1bec483..450ce8c355c40 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1561,6 +1561,12 @@ static int tb_switch_reset_host(struct tb_switch *sw)
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



