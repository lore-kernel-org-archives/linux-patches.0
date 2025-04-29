Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E5240C03;
	Tue, 29 Apr 2025 18:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949970; cv=none; b=WlTn0jGGBvsJVSFp5hEydMA8q0AP2Mr/f32VIJ3nYXH4JNHfdblGgk88aiGyPZ0VGLc69Kcq4J2tbgSTCPYZF8+qmafoVddcKhmxpgmhShaNwwAXUF0iCVMC2zp/jwlbd+dC3szDWHaOjgggLoy+bDgvMiRc4TdnRO61sOb0D+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949970; c=relaxed/simple;
	bh=rB2+jNARo4qHbCMhqm1OhL6QPde4khc9NPJp8hIhngI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsuwK+iA0ly77nr6SDov+IjaepieOt1655wbjS1/AGwja8BYHHZdvf8eSMyPq5FLTmUwl6xAxnbDaNEypYN7YAGpbINE5tzS/xGOH9whUG9Z9+H99FJXbOPk4qBZP6Vnx2dXwhSWGpSytr0DjGCsn7mfHjIbtbQn+7u2U4no3T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6tkc8rF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6tkc8rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1516C4CEE9;
	Tue, 29 Apr 2025 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949970;
	bh=rB2+jNARo4qHbCMhqm1OhL6QPde4khc9NPJp8hIhngI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6tkc8rFT4UaegwCdkaAFs+5GzotDQwcO3aB44xRwyqE5++oO4nmVQukvRC+Dzviu
	 WchpiE3HkPdWulMhzINL6jH8WdZ+64TX0+rv2cpAcz9mp3EUw/j4ne7mDGBWbOEzYD
	 8xppgpQ00QNidDL6oO5eZXo1wHz5uuZhADCgcEjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Lynema <lyz27@yahoo.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/167] thunderbolt: Scan retimers after device router has been enumerated
Date: Tue, 29 Apr 2025 18:43:42 +0200
Message-ID: <20250429161056.351216157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 75749d2c1d8cef439f8b69fa1f4f36d0fc3193e6 ]

Thomas reported connection issues on AMD system with Pluggable UD-4VPD
dock. After some experiments it looks like the device has some sort of
internal timeout that triggers reconnect. This is completely against the
USB4 spec, as there is no requirement for the host to enumerate the
device right away or even at all.

In Linux case the delay is caused by scanning of retimers on the link so
we can work this around by doing the scanning after the device router
has been enumerated.

Reported-by: Thomas Lynema <lyz27@yahoo.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219748
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index c592032657a1e..0668e1645bc50 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -640,11 +640,15 @@ static void tb_scan_port(struct tb_port *port)
 		goto out_rpm_put;
 	}
 
-	tb_retimer_scan(port, true);
-
 	sw = tb_switch_alloc(port->sw->tb, &port->sw->dev,
 			     tb_downstream_route(port));
 	if (IS_ERR(sw)) {
+		/*
+		 * Make the downstream retimers available even if there
+		 * is no router connected.
+		 */
+		tb_retimer_scan(port, true);
+
 		/*
 		 * If there is an error accessing the connected switch
 		 * it may be connected to another domain. Also we allow
@@ -704,6 +708,14 @@ static void tb_scan_port(struct tb_port *port)
 	tb_switch_lane_bonding_enable(sw);
 	/* Set the link configured */
 	tb_switch_configure_link(sw);
+	/*
+	 * Scan for downstream retimers. We only scan them after the
+	 * router has been enumerated to avoid issues with certain
+	 * Pluggable devices that expect the host to enumerate them
+	 * within certain timeout.
+	 */
+	tb_retimer_scan(port, true);
+
 	/*
 	 * CL0s and CL1 are enabled and supported together.
 	 * Silently ignore CLx enabling in case CLx is not supported.
-- 
2.39.5



