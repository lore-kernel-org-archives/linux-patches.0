Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E72119F485;
	Tue, 27 Aug 2024 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770667; cv=none; b=BgPkGHFILzA7oDCGML27whbxP+nrsNxDSPkVAehBiAfTOucHi+YKQGxpqSlhdsE/D+8si/JgyvuhaYeONq/S0ijAVbKE3QYgVSH8cUXZrWxAGT3LpREnud4b/9ty+5raCud4pTbJ86+6KJbKuxgn0B2DM1ZZ03pd7j2Yl/rt7Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770667; c=relaxed/simple;
	bh=cqgeuON9WvRw1scvtbCKJwGG5+h29C+u/JFcCKZAwBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tisd8SXHhYSM04xySgvdaiL9YFpE9d86wyrzrflba8JXRuqORDq7A7swuRNUR5XF2gNE0P7P1SzAc70cOjvgFroYN4s26vmWpmhsVhrYDRhk4/L/LnABmZDp3sbcKI6xtEyFNXihFrspF8i3QOQDnil7czsU39LwpgV1RNuxMf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8R6oLdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8R6oLdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C9AC61044;
	Tue, 27 Aug 2024 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770666;
	bh=cqgeuON9WvRw1scvtbCKJwGG5+h29C+u/JFcCKZAwBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8R6oLdqEVE8blvyTZgqLk296bfIVvIQXOLekJsD0a0r+Nwh3LfgFzezcxjUQOyPq
	 +8vccLsJnidjg2WCL/xa4th2YTsXOSIhbGnJDkHW3I/BH7uukoRFWWGZ0wIXg0FEsq
	 bZIpbxFgEdrXQorzCyOdZZUhFHb/3B/WFeLhiX20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Whitaker <foss@martin-whitaker.me.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 298/341] net: dsa: microchip: fix PTP config failure when using multiple ports
Date: Tue, 27 Aug 2024 16:38:49 +0200
Message-ID: <20240827143854.732962896@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Martin Whitaker <foss@martin-whitaker.me.uk>

commit 6efea5135417ae8194485d1d05ea79a21cf1a11c upstream.

When performing the port_hwtstamp_set operation, ptp_schedule_worker()
will be called if hardware timestamoing is enabled on any of the ports.
When using multiple ports for PTP, port_hwtstamp_set is executed for
each port. When called for the first time ptp_schedule_worker() returns
0. On subsequent calls it returns 1, indicating the worker is already
scheduled. Currently the ksz driver treats 1 as an error and fails to
complete the port_hwtstamp_set operation, thus leaving the timestamping
configuration for those ports unchanged.

This patch fixes this by ignoring the ptp_schedule_worker() return
value.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/7aae307a-35ca-4209-a850-7b2749d40f90@martin-whitaker.me.uk
Fixes: bb01ad30570b0 ("net: dsa: microchip: ptp: manipulating absolute time using ptp hw clock")
Signed-off-by: Martin Whitaker <foss@martin-whitaker.me.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Link: https://patch.msgid.link/20240817094141.3332-1-foss@martin-whitaker.me.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_ptp.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -266,7 +266,6 @@ static int ksz_ptp_enable_mode(struct ks
 	struct ksz_port *prt;
 	struct dsa_port *dp;
 	bool tag_en = false;
-	int ret;
 
 	dsa_switch_for_each_user_port(dp, dev->ds) {
 		prt = &dev->ports[dp->index];
@@ -277,9 +276,7 @@ static int ksz_ptp_enable_mode(struct ks
 	}
 
 	if (tag_en) {
-		ret = ptp_schedule_worker(ptp_data->clock, 0);
-		if (ret)
-			return ret;
+		ptp_schedule_worker(ptp_data->clock, 0);
 	} else {
 		ptp_cancel_worker_sync(ptp_data->clock);
 	}


