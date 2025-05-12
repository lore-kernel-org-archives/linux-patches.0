Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E171E505;
	Mon, 12 May 2025 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072734; cv=none; b=Ie+fEi+a/ca19OS86RYdssdfj+9oJ9iG9zvU0+ZxyX7KimwQ/2HgaK/NUvKlXi+HcpL9gsAvyxPzGz3BMTC5FU/0M8PXaxNG69CvZRS9IajZbrwfsT+D+tfYJb5KKxz9gLeVwaSd872fjKsCwhwQEVlewisaraF8/FpwkFz1mYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072734; c=relaxed/simple;
	bh=M8xtYIncJrbmT/mgSXC42ptPofs7kcJ0nk+yPWo+Ffo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQmjEmCC5S2QFECE8kOoatFc7JejQRDSS6tX8YH5IR6qP1tMG9xCD93Z7MvS2sh9iNtRdKCTBQcuHrsMzGxXMp6szr1dwE+JWFnZ6hSfP0NNshn9sdkJFJ9FyuuyM7OT8wsWoaAheDBj2ZnEoGX3IITKcdb2mHQRYMve2eAtmTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETKr+Ref; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETKr+Ref"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86FAC4CEE7;
	Mon, 12 May 2025 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072733;
	bh=M8xtYIncJrbmT/mgSXC42ptPofs7kcJ0nk+yPWo+Ffo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETKr+RefhVQ3V/m2EkUys+KKu6A0WrTGZ+M55YvK3w8EqIEhoVlKeKRLzj/zuw+GZ
	 1jSgH6QhA/S/GjkfTfZ6hnLt+nDY+fhnS+nbd0QeQ2h7NIvJ9D+Itn/k3WhaOZHwmF
	 hqEwkEWS4vo1Fs03878wsppAP8ei8m/KOFdY6iUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/184] net: dsa: b53: always rejoin default untagged VLAN on bridge leave
Date: Mon, 12 May 2025 19:44:01 +0200
Message-ID: <20250512172043.359782267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 25afafc4bfc7f..70a8f70d2c6d5 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2022,12 +2022,12 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
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



