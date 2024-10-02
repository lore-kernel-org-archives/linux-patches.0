Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89C11D0B8C;
	Wed,  2 Oct 2024 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880600; cv=none; b=El4p5YsIL2Oa61eHr/Sry1zxrsjEq0wloQQBvLbbd5qJmRKJPSDLMI3eE84BVlq4O1wlcLazo2zDM3nrqG7RCdIhEff3OYlJ7ZulA49u8avyp3+hQ4Fu1rxaOJ5AEeYWSKuhF6HiHnbuO7CctOn105JqoJ6axwa7Ds9onQVeX3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880600; c=relaxed/simple;
	bh=ym8VxZia2JUMfiJO2/IoPI86R4RkTHrLzhWaK83mmdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3oU+YyifiS4VObFqj9CaVOV2LIsQ7i8MpcVqJHRWdjR7aujAqcM//y6Urjvxent7dDmHZYfgIh2GHFyRQFdxe9C/B3M0s9Pf4Sfsn9fnJ0cv9EwKHN3xp9BNAGdxIlAPK0yCLyQqyaM68VovlpiCloSVMjHENS36cj07YoznMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMLkc2v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMLkc2v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614FEC4CECE;
	Wed,  2 Oct 2024 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880600;
	bh=ym8VxZia2JUMfiJO2/IoPI86R4RkTHrLzhWaK83mmdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMLkc2v3UFkh2CEXdKUNyIc+Y61IHHNNbJX82VM9G60QgDhvdEhhZ09m9Y7BurdBB
	 UVxfsjFVHtSFd+RA/uzTzCUxxkT24yeVDKFNipNWjBOM7t8S9KNkzoF5hRV2oQbSsS
	 hzsL954lpzqMNPrcNt4OrVaEyDO9S6VFHQEKZEdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 515/538] thunderbolt: Improve DisplayPort tunnel setup process to be more robust
Date: Wed,  2 Oct 2024 15:02:34 +0200
Message-ID: <20241002125812.773040222@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit b4734507ac55cc7ea1380e20e83f60fcd7031955 ]

After DisplayPort tunnel setup, we add verification that the DPRX
capabilities read process completed. Otherwise, we bail out, teardown
the tunnel, and try setup another DisplayPort tunnel using next
available DP IN adapter. We do so till all DP IN adapters tried. This
way, we avoid allocating DP IN adapter and (bandwidth for it) for
unusable tunnel.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |   84 ++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 41 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1699,49 +1699,15 @@ static struct tb_port *tb_find_dp_out(st
 	return NULL;
 }
 
-static bool tb_tunnel_one_dp(struct tb *tb)
+static bool tb_tunnel_one_dp(struct tb *tb, struct tb_port *in,
+			     struct tb_port *out)
 {
 	int available_up, available_down, ret, link_nr;
 	struct tb_cm *tcm = tb_priv(tb);
-	struct tb_port *port, *in, *out;
 	int consumed_up, consumed_down;
 	struct tb_tunnel *tunnel;
 
 	/*
-	 * Find pair of inactive DP IN and DP OUT adapters and then
-	 * establish a DP tunnel between them.
-	 */
-	tb_dbg(tb, "looking for DP IN <-> DP OUT pairs:\n");
-
-	in = NULL;
-	out = NULL;
-	list_for_each_entry(port, &tcm->dp_resources, list) {
-		if (!tb_port_is_dpin(port))
-			continue;
-
-		if (tb_port_is_enabled(port)) {
-			tb_port_dbg(port, "DP IN in use\n");
-			continue;
-		}
-
-		in = port;
-		tb_port_dbg(in, "DP IN available\n");
-
-		out = tb_find_dp_out(tb, port);
-		if (out)
-			break;
-	}
-
-	if (!in) {
-		tb_dbg(tb, "no suitable DP IN adapter available, not tunneling\n");
-		return false;
-	}
-	if (!out) {
-		tb_dbg(tb, "no suitable DP OUT adapter available, not tunneling\n");
-		return false;
-	}
-
-	/*
 	 * This is only applicable to links that are not bonded (so
 	 * when Thunderbolt 1 hardware is involved somewhere in the
 	 * topology). For these try to share the DP bandwidth between
@@ -1801,15 +1767,19 @@ static bool tb_tunnel_one_dp(struct tb *
 		goto err_free;
 	}
 
+	/* If fail reading tunnel's consumed bandwidth, tear it down */
+	ret = tb_tunnel_consumed_bandwidth(tunnel, &consumed_up, &consumed_down);
+	if (ret)
+		goto err_deactivate;
+
 	list_add_tail(&tunnel->list, &tcm->tunnel_list);
-	tb_reclaim_usb3_bandwidth(tb, in, out);
 
+	tb_reclaim_usb3_bandwidth(tb, in, out);
 	/*
 	 * Transition the links to asymmetric if the consumption exceeds
 	 * the threshold.
 	 */
-	if (!tb_tunnel_consumed_bandwidth(tunnel, &consumed_up, &consumed_down))
-		tb_configure_asym(tb, in, out, consumed_up, consumed_down);
+	tb_configure_asym(tb, in, out, consumed_up, consumed_down);
 
 	/* Update the domain with the new bandwidth estimation */
 	tb_recalc_estimated_bandwidth(tb);
@@ -1821,6 +1791,8 @@ static bool tb_tunnel_one_dp(struct tb *
 	tb_increase_tmu_accuracy(tunnel);
 	return true;
 
+err_deactivate:
+	tb_tunnel_deactivate(tunnel);
 err_free:
 	tb_tunnel_free(tunnel);
 err_reclaim_usb:
@@ -1840,13 +1812,43 @@ err_rpm_put:
 
 static void tb_tunnel_dp(struct tb *tb)
 {
+	struct tb_cm *tcm = tb_priv(tb);
+	struct tb_port *port, *in, *out;
+
 	if (!tb_acpi_may_tunnel_dp()) {
 		tb_dbg(tb, "DP tunneling disabled, not creating tunnel\n");
 		return;
 	}
 
-	while (tb_tunnel_one_dp(tb))
-		;
+	/*
+	 * Find pair of inactive DP IN and DP OUT adapters and then
+	 * establish a DP tunnel between them.
+	 */
+	tb_dbg(tb, "looking for DP IN <-> DP OUT pairs:\n");
+
+	in = NULL;
+	out = NULL;
+	list_for_each_entry(port, &tcm->dp_resources, list) {
+		if (!tb_port_is_dpin(port))
+			continue;
+
+		if (tb_port_is_enabled(port)) {
+			tb_port_dbg(port, "DP IN in use\n");
+			continue;
+		}
+
+		in = port;
+		tb_port_dbg(in, "DP IN available\n");
+
+		out = tb_find_dp_out(tb, port);
+		if (out)
+			tb_tunnel_one_dp(tb, in, out);
+		else
+			tb_port_dbg(in, "no suitable DP OUT adapter available, not tunneling\n");
+	}
+
+	if (!in)
+		tb_dbg(tb, "no suitable DP IN adapter available, not tunneling\n");
 }
 
 static void tb_enter_redrive(struct tb_port *port)


