Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8258D1C3BE0;
	Mon, 12 May 2025 17:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071896; cv=none; b=Vrbh8iEDDAwN//EHRRksr1JwgrCO4iRoWUMLZbV2b858Vz5PohBJ2f93IddSbwPBB3d8EbEEmemrbwIIZlD/t34oBt2rKA/nXNp7jV30w/WWMrGqDvCE733nUUzt8uf7u6jnXUjMHPaY7JOFAz+GkW7XuoScibfGsgCfFahM3QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071896; c=relaxed/simple;
	bh=XW9/uvafHxmP731Os4B0Aabau+SuvUBeK3gcc97b/WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPDwKUk0MB+v1GP8udUEUEtDjGSqBY9/R2ISLThWknmYbNDYxfmrQ9r0kQM3Ej5k+t8qhHKpr7bP6P4IkvjSU3Xh2FiVFBv5vodSPp4T0CItnuCMYykIdBi8L3eLA6v9YRl7AnKg1HaXjCNEmS5nwAeMh6RJxb0kGkf20z9Xpf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4My/0Pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4My/0Pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13606C4CEE7;
	Mon, 12 May 2025 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071896;
	bh=XW9/uvafHxmP731Os4B0Aabau+SuvUBeK3gcc97b/WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4My/0PzS+//TzzBplYdqUcfSKtss/OKn4iocAcdniLxaTusJfTBPz3hmDBuLwrRb
	 IfXieMPbD4XWiiyQ1e8BUOJmR1XrAP+5X71GvcQIjeIK8s/35OtJpMUlXENsak2QZj
	 MJvkhCGFRm2j4x/x86qPRD8G5uiS09+hXTnCR3X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 039/197] net: dsa: b53: always rejoin default untagged VLAN on bridge leave
Date: Mon, 12 May 2025 19:38:09 +0200
Message-ID: <20250512172045.962741609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 13b152ae40495966501697693f048f47430c50fd ]

While JOIN_ALL_VLAN allows to join all VLANs, we still need to keep the
default VLAN enabled so that untagged traffic stays untagged.

So rejoin the default VLAN even for switches with JOIN_ALL_VLAN support.

Fixes: 48aea33a77ab ("net: dsa: b53: Add JOIN_ALL_VLAN support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-7-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 9745713e0b10d..305e3b5c804a2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2021,12 +2021,12 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 		if (!(reg & BIT(cpu_port)))
 			reg |= BIT(cpu_port);
 		b53_write16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, reg);
-	} else {
-		b53_get_vlan_entry(dev, pvid, vl);
-		vl->members |= BIT(port) | BIT(cpu_port);
-		vl->untag |= BIT(port) | BIT(cpu_port);
-		b53_set_vlan_entry(dev, pvid, vl);
 	}
+
+	b53_get_vlan_entry(dev, pvid, vl);
+	vl->members |= BIT(port) | BIT(cpu_port);
+	vl->untag |= BIT(port) | BIT(cpu_port);
+	b53_set_vlan_entry(dev, pvid, vl);
 }
 EXPORT_SYMBOL(b53_br_leave);
 
-- 
2.39.5



