Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232131DC1A7;
	Mon, 12 May 2025 17:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071029; cv=none; b=mBI6mqGhSTvpoweXLmfztOeF3Ls2LOyrkVMgSyvryT+txGfmnkFhLfU5SZ/uuZ4NxWMkQGbx3tglBbTY0c6KxO0dOs+X/xhRXaNw+qTBCJwYoJWOeYPAK2gbIgiZO3slAMcwT0/aKCiJd+9E0bkWdvhJ0jFaFWop4XK7Wggd0jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071029; c=relaxed/simple;
	bh=l3N0Dv2hlZGIKea/beiRW2cL3DIu+MhwcHRfvlL2sv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXpRnFCCVlOh6GvoLzWlZPk03NkWvVF3/opfdGax2wWiPVlsrkwpkNYnksas1iZ7TLKtkzY6C5HSZAjo+KR4tagxddjmOmZ8RxeKb8HiKFu7Ush8n6a17MaB5taonFmzAyXk3wj97gbUkOa1CvzJW2dafvyBPQXmJGOhvl+tVb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVVjz/Z9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVVjz/Z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F20C4CEE7;
	Mon, 12 May 2025 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071028;
	bh=l3N0Dv2hlZGIKea/beiRW2cL3DIu+MhwcHRfvlL2sv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVVjz/Z9YSA8cm0uOvbbTHfwxk3W1Tju9IwDlfG35eOKu6tpkefar01WAPm5cF3ur
	 pCyQpFpU6ypJIssKSU1pXE2+0xSiAJrtDXvo5ncJYfxh3ZzSzfNfsVQfC/TKEnYhbH
	 IG8z+kkHQfjZFgj5dQ9eAMwR+7sWg6/lT2fjYTgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/54] net: dsa: b53: always rejoin default untagged VLAN on bridge leave
Date: Mon, 12 May 2025 19:29:25 +0200
Message-ID: <20250512172016.184468195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 37b3a46b060f5..429ea5056235f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1961,12 +1961,12 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
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



