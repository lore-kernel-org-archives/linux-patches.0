Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED15214388F;
	Tue, 23 Apr 2024 21:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908513; cv=none; b=lzE48oJOrk9ufWSfDQrgLdnFEZE3B15NXipY8qWKJEqgl6zpXwioBiirwCPbbRdt1ZMU7b5Zt38mbsqcsDowcmTCF1xJ2rHKDhL/2pwWOWmeilyfm2ug1shZGXUX7l1ji/HxvbA8oAese+kyT/9v3Fykoai2AilDDtlet5BAk4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908513; c=relaxed/simple;
	bh=Ax5zhEh6PVBl34KIaMMrgHOLdegsdxENFIZndI/EBQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5bqG0Qphqoun9FXjapRDc761MaLa1USDuP6tYlz6lFNS8OAADWm5zBb1nLxb1gK1sff+Y0HaoiB0zJKpdfseaIbFaTl25japEBitrvRhsebKPMUdFJ52O56JDq0q6xe5FflttIq7L6sJpMl4FtBou3BWYqKJ0rvsAdRchpj26o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVOJoUOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVOJoUOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D4BC3277B;
	Tue, 23 Apr 2024 21:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908512;
	bh=Ax5zhEh6PVBl34KIaMMrgHOLdegsdxENFIZndI/EBQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVOJoUObgziPIg3spXt5voEIV9y9E0ziu0ueAgvcjDmSONqtQBMbI7ozeMD0Ga4Ky
	 dZY9LwKbp65sxlOV5NN/O5o+JTsavIHam2gAhRyLxCwzoFphI4JrI6wDbBuUgeCxO4
	 S0M6XcVjCP4sqo3TNoKcrWorGm1X3XN671LkdwMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.8 098/158] thunderbolt: Fix wake configurations after device unplug
Date: Tue, 23 Apr 2024 14:38:40 -0700
Message-ID: <20240423213859.134210488@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Fine <gil.fine@linux.intel.com>

commit c38fa07dc69f0b9e6f43ecab96dc7861a70c827c upstream.

Currently we don't configure correctly the wake events after unplug of device
router. What can happen is that the downstream ports of host router will be
configured to wake on: USB4-wake and wake-on-disconnect, but not on
wake-on-connect. This may cause the later plugged device not to wake the
domain and fail in enumeration. Fix this by clearing downstream port's "USB4
Port is Configured" bit, after unplug of a device router.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -3180,22 +3180,29 @@ void tb_switch_unconfigure_link(struct t
 {
 	struct tb_port *up, *down;
 
-	if (sw->is_unplugged)
-		return;
 	if (!tb_route(sw) || tb_switch_is_icm(sw))
 		return;
 
+	/*
+	 * Unconfigure downstream port so that wake-on-connect can be
+	 * configured after router unplug. No need to unconfigure upstream port
+	 * since its router is unplugged.
+	 */
 	up = tb_upstream_port(sw);
-	if (tb_switch_is_usb4(up->sw))
-		usb4_port_unconfigure(up);
-	else
-		tb_lc_unconfigure_port(up);
-
 	down = up->remote;
 	if (tb_switch_is_usb4(down->sw))
 		usb4_port_unconfigure(down);
 	else
 		tb_lc_unconfigure_port(down);
+
+	if (sw->is_unplugged)
+		return;
+
+	up = tb_upstream_port(sw);
+	if (tb_switch_is_usb4(up->sw))
+		usb4_port_unconfigure(up);
+	else
+		tb_lc_unconfigure_port(up);
 }
 
 static void tb_switch_credits_init(struct tb_switch *sw)


