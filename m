Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371B61D1727;
	Wed,  2 Oct 2024 14:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880665; cv=none; b=QjAnv/nFVPS1XOTRehjACgAEab/KzW52W3onAssMcc9zzIIgRFuWePRkBL5y6hqgp8L61XngBHvvDO6c8HG2poDXnIV5kL5efuYh7q4Y/Q+ssdryDrEp7hBojF64gRXelLW/f6g6sPKOnIXZ6150lDjlQnWpU1eWX7T994nmh7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880665; c=relaxed/simple;
	bh=FJHOsy5iku1+rQlylrL3k8UPOPPVoJtU6A23WVgT1vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoUuXhIvsQI8RfPKo7ShB6wkGHZrau4I3jQXnLpJc8IrzcJLJeWoojbN501KyDI1/NnNw4CrpeuOzPtUOqqOQ2i3ruX+SeQC+Ip3+/NC1Tf9byHKegF2JaCa0Egl/VobPwmMZTAEm8/JAc+KmedOWXD04sAcEWcyEZsaoKrJ8H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MABrHyLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MABrHyLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66A0C4CECD;
	Wed,  2 Oct 2024 14:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880665;
	bh=FJHOsy5iku1+rQlylrL3k8UPOPPVoJtU6A23WVgT1vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MABrHyLqH676d2uZQLXUq9K/rb1LO0lWbZAK2OKXd604EYvgyro5smsdYs0BJ4YJr
	 PETPJdtvTbHwP/FxCtHtjW29RXGltDG1lTWjA2w9e9dnGppSGsw58JDgysTpKCRzgj
	 XLvIyr8kAG0bQ3p7quMOrPp43pVOFE+YA0KaZeew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 505/538] thunderbolt: Create multiple DisplayPort tunnels if there are more DP IN/OUT pairs
Date: Wed,  2 Oct 2024 15:02:24 +0200
Message-ID: <20241002125812.374244099@linuxfoundation.org>
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

[ Upstream commit 8648c6465c025c488e2855c209c0dea1a1a15184 ]

Currently we only create one DisplayPort tunnel even if there would be
more DP IN/OUT pairs available. Specifically this happens when a router
is unplugged and we check if a new DisplayPort tunnel can be created. To
cover this create tunnels as long as we find suitable DP IN/OUT pairs.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1282,18 +1282,13 @@ static struct tb_port *tb_find_dp_out(st
 	return NULL;
 }
 
-static void tb_tunnel_dp(struct tb *tb)
+static bool tb_tunnel_one_dp(struct tb *tb)
 {
 	int available_up, available_down, ret, link_nr;
 	struct tb_cm *tcm = tb_priv(tb);
 	struct tb_port *port, *in, *out;
 	struct tb_tunnel *tunnel;
 
-	if (!tb_acpi_may_tunnel_dp()) {
-		tb_dbg(tb, "DP tunneling disabled, not creating tunnel\n");
-		return;
-	}
-
 	/*
 	 * Find pair of inactive DP IN and DP OUT adapters and then
 	 * establish a DP tunnel between them.
@@ -1321,11 +1316,11 @@ static void tb_tunnel_dp(struct tb *tb)
 
 	if (!in) {
 		tb_dbg(tb, "no suitable DP IN adapter available, not tunneling\n");
-		return;
+		return false;
 	}
 	if (!out) {
 		tb_dbg(tb, "no suitable DP OUT adapter available, not tunneling\n");
-		return;
+		return false;
 	}
 
 	/*
@@ -1398,7 +1393,7 @@ static void tb_tunnel_dp(struct tb *tb)
 	 * TMU mode to HiFi for CL0s to work.
 	 */
 	tb_increase_tmu_accuracy(tunnel);
-	return;
+	return true;
 
 err_free:
 	tb_tunnel_free(tunnel);
@@ -1413,6 +1408,19 @@ err_rpm_put:
 	pm_runtime_put_autosuspend(&out->sw->dev);
 	pm_runtime_mark_last_busy(&in->sw->dev);
 	pm_runtime_put_autosuspend(&in->sw->dev);
+
+	return false;
+}
+
+static void tb_tunnel_dp(struct tb *tb)
+{
+	if (!tb_acpi_may_tunnel_dp()) {
+		tb_dbg(tb, "DP tunneling disabled, not creating tunnel\n");
+		return;
+	}
+
+	while (tb_tunnel_one_dp(tb))
+		;
 }
 
 static void tb_enter_redrive(struct tb_port *port)


