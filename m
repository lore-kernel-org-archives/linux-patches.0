Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A708425333F;
	Tue, 29 Apr 2025 18:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950578; cv=none; b=ch24eBCihZrFV/qrEF9pBrADPoOzlMO+ddmqEPjB+V9PDtad01eyb6l2vL9CMbwHVi4tJcR1zI6hzeNhz0A3x0jQ27JkMRR0ivBO6/cytYPF1pqZp2Fvn5XK1GMlWLaggj+3YuIpBByITJ85f0Ej01UHALMQsQymYSTq8Y3T7XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950578; c=relaxed/simple;
	bh=RvZah6q3imZg1vQERBGbiL/2s8Ud6XfZIZFyNxxb8mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFq57QA1IgRo/MDqIKoMd5nID8G4z+LRfld8858GcSAn2+2oNO3v9uB7KDPp5US+JJYOrc3qeHKa6W+oAE2yVAK2t8n3Qm79MzmZcgXQW2BkCk8WOUCQrgE7mspo29AbSL2F5mj2CBSYTrO5ik625PSBP7tjg2mU6Sxgbwv5wzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yTJtoz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yTJtoz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306B0C4CEEA;
	Tue, 29 Apr 2025 18:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950578;
	bh=RvZah6q3imZg1vQERBGbiL/2s8Ud6XfZIZFyNxxb8mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yTJtoz7mf9UXK3+MDUVBIMijB4Hd5GIpVQ1iro10k/vhzOMY0D2gCYkEPS7Us+rX
	 WCC+nCVUuhz/32eqTLWL3wSPLOxFXnTWaP4q34K8INqXkPwUJxs6UsxS0qfiJpced0
	 umypBdGnjCpbeZ4Hcn4xxmAfSBZYfQuSUnJ01hZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Lynema <lyz27@yahoo.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/204] thunderbolt: Scan retimers after device router has been enumerated
Date: Tue, 29 Apr 2025 18:43:48 +0200
Message-ID: <20250429161105.157090048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7c3310a2b28a4..b92a8a5b2e8c9 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1370,11 +1370,15 @@ static void tb_scan_port(struct tb_port *port)
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
@@ -1424,6 +1428,14 @@ static void tb_scan_port(struct tb_port *port)
 	upstream_port = tb_upstream_port(sw);
 	tb_configure_link(port, upstream_port, sw);
 
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



