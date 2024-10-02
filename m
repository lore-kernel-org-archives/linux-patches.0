Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B951D0DDE;
	Wed,  2 Oct 2024 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880685; cv=none; b=RGCjRIdyVwS/idPZ34Y8Zu00Ue0jSJF0xLEFoir0NmVp0+bD+H6ETLV3MQf0216PJdsgy3dGggheL0AqHu+PjgLydnRPUZLU7HtsKRp5ceH1SFbDkmcu/Gm0nM6BQUmVt9EusEsSP0ZfkXhyklATn5psJGdHnQX06x+SIuw3S0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880685; c=relaxed/simple;
	bh=7Y5gFBjJuRgAqhq8f9SnZWnAIJbGJjDnQcnVc5VehQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TR3cn0Tl1IW9ud3TJMFupaDtB5GvPy4WRE0D0kAyzK6GZEpLydzAV0R5KXvlxx6Ynqs1zouQqhASlLKt1XTSPgvqFG0Y16VGoJzfVAoXX/sdzJ9bZvfNC/rPMvCZThhtT5ncVTpvP6LudbCb800VCfojHjOnLPF18V2kfN2A/k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acxCGrTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acxCGrTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF2DC4CEDF;
	Wed,  2 Oct 2024 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880685;
	bh=7Y5gFBjJuRgAqhq8f9SnZWnAIJbGJjDnQcnVc5VehQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acxCGrTuIngmso1N3IDosGCrv+pZbmzkaoEa3tRHWdFfJlNIWcBNllJBnGDkfP2K4
	 O3/nZv8g0tzShh30eQ6qgSO+SBc+CmHNVtyuEthHVmnaksBubmCB5CmNdr5pzon9v1
	 1/pVQnI3TeM4wLEju0neXeEBZU56zWIkh9+1Sq+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 536/538] thunderbolt: Fix minimum allocated USB 3.x and PCIe bandwidth
Date: Wed,  2 Oct 2024 15:02:55 +0200
Message-ID: <20241002125813.601152535@linuxfoundation.org>
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

commit f0b94c1c5c7994a74e487f43c91cfc922105a423 upstream.

With the current bandwidth allocation we end up reserving too much for the USB
3.x and PCIe tunnels that leads to reduced capabilities for the second
DisplayPort tunnel.

Fix this by decreasing the USB 3.x allocation to 900 Mb/s which then allows
both tunnels to get the maximum HBR2 bandwidth.  This way, the reserved
bandwidth for USB 3.x and PCIe, would be 1350 Mb/s (taking weights of USB 3.x
and PCIe into account). So bandwidth allocations on a link are:
USB 3.x + PCIe tunnels => 1350 Mb/s
DisplayPort tunnel #1  => 17280 Mb/s
DisplayPort tunnel #2  => 17280 Mb/s

Total consumed bandwidth is 35910 Mb/s. So that all the above can be tunneled
on a Gen 3 link (which allows maximum of 36000 Mb/s).

Fixes: 582e70b0d3a4 ("thunderbolt: Change bandwidth reservations to comply USB4 v2")
Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/usb4.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -2380,13 +2380,13 @@ int usb4_usb3_port_release_bandwidth(str
 		goto err_request;
 
 	/*
-	 * Always keep 1000 Mb/s to make sure xHCI has at least some
+	 * Always keep 900 Mb/s to make sure xHCI has at least some
 	 * bandwidth available for isochronous traffic.
 	 */
-	if (consumed_up < 1000)
-		consumed_up = 1000;
-	if (consumed_down < 1000)
-		consumed_down = 1000;
+	if (consumed_up < 900)
+		consumed_up = 900;
+	if (consumed_down < 900)
+		consumed_down = 900;
 
 	ret = usb4_usb3_port_write_allocated_bandwidth(port, consumed_up,
 						       consumed_down);


