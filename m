Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9FC446845;
	Thu, 30 Jul 2026 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428195; cv=none; b=F1fDr7OCF3brqvVzbzpcKiTsptqlAd5IHG43Ff9BCrV4xW4k/UESkCBT6ImgW0WeC9VMVvYanagPK6LLH1GBEkY6j3U93P5wStAddDUQKoRb94t/b1e2myLQ5JWnYUeZazm0MTPiVKMKZGm2mLuOOdYUGce38t2HSGz2mQW6szk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428195; c=relaxed/simple;
	bh=c+aXiVt8wQWUFNPYwZJtOmbgjoK9HXaZP/xELiLGVPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dY+cQdq3tJsvDzr3i7JKDpBPYDk3GP9Kyb3n1htzsC/kQlsvPmsrOfa0K0P4ZeP5KiMoTEIjD5VAGnSld9ztBR94ud9k2xQcVTH/3SQN7nmwaLiHhDgEM6XPJejPbLlsiZZyJtvkUN2aGiT6thQOKZUR8j6Pd+85AEs9lDfnIkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygsxFDhC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygsxFDhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701051F00AC4;
	Thu, 30 Jul 2026 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428185;
	bh=TYhgD/2uRJ9Dy5pLTx3muyztNEUCxaFmAOJCdEipEtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ygsxFDhCQ2vpVAPscVmTURI3gvjmG+xq3+G7nLYeWagUENFAF5raPAhFDRavVEyu/
	 ahQPCQSOca6WKzrIjyoeRq/foPYpAxDa+h6phAg0+fKBfElOadgGizP50A3G/nC7uI
	 XdUFBkMymYoZhi0jmcMB8fPAkGsG+ZQUfFapZCjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 434/484] thunderbolt: Handle lane bonding of Gen 4 XDomain links properly
Date: Thu, 30 Jul 2026 16:15:31 +0200
Message-ID: <20260730141432.908938777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit 36b6ad6ad0350554e611a8cb754ccd40857416a8 ]

Gen 4 links come up as bonded already so we are not supposed to initiate
lane bonding on them. However, we should still update the port
structures accordingly. Split these into their own functions to make it
easier to follow.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c      |    2 -
 drivers/thunderbolt/xdomain.c |   49 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 3 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -539,8 +539,6 @@ static void tb_port_unconfigure_xdomain(
 		usb4_port_unconfigure_xdomain(port);
 	else
 		tb_lc_unconfigure_xdomain(port);
-
-	tb_port_enable(port->dual_link_port);
 }
 
 static void tb_scan_xdomain(struct tb_port *port)
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1903,6 +1903,50 @@ struct device_type tb_xdomain_type = {
 };
 EXPORT_SYMBOL_GPL(tb_xdomain_type);
 
+static void tb_xdomain_link_init(struct tb_xdomain *xd, struct tb_port *down)
+{
+	if (!down->dual_link_port)
+		return;
+
+	/*
+	 * Gen 4 links come up already as bonded so only update the port
+	 * structures here.
+	 */
+	if (tb_port_get_link_generation(down) >= 4) {
+		down->bonded = true;
+		down->dual_link_port->bonded = true;
+	} else {
+		xd->bonding_possible = true;
+	}
+}
+
+static void tb_xdomain_link_exit(struct tb_xdomain *xd)
+{
+	struct tb_port *down = tb_xdomain_downstream_port(xd);
+
+	if (!down->dual_link_port)
+		return;
+
+	if (tb_port_get_link_generation(down) >= 4) {
+		down->bonded = false;
+		down->dual_link_port->bonded = false;
+	} else if (xd->link_width > TB_LINK_WIDTH_SINGLE) {
+		/*
+		 * Just return port structures back to way they were and
+		 * update credits. No need to update userspace because
+		 * the XDomain is removed soon anyway.
+		 */
+		tb_port_lane_bonding_disable(down);
+		tb_port_update_credits(down);
+	} else if (down->dual_link_port) {
+		/*
+		 * Re-enable the lane 1 adapter we disabled at the end
+		 * of tb_xdomain_get_properties().
+		 */
+		tb_port_enable(down->dual_link_port);
+	}
+}
+
 /**
  * tb_xdomain_alloc() - Allocate new XDomain object
  * @tb: Domain where the XDomain belongs
@@ -1953,7 +1997,8 @@ struct tb_xdomain *tb_xdomain_alloc(stru
 			goto err_free_local_uuid;
 	} else {
 		xd->needs_uuid = true;
-		xd->bonding_possible = !!down->dual_link_port;
+
+		tb_xdomain_link_init(xd, down);
 	}
 
 	device_initialize(&xd->dev);
@@ -2022,6 +2067,8 @@ void tb_xdomain_remove(struct tb_xdomain
 
 	device_for_each_child_reverse(&xd->dev, xd, unregister_service);
 
+	tb_xdomain_link_exit(xd);
+
 	/*
 	 * Undo runtime PM here explicitly because it is possible that
 	 * the XDomain was never added to the bus and thus device_del()


