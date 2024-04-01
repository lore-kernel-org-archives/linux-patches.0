Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE05B47A7C;
	Mon,  1 Apr 2024 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987705; cv=none; b=nMvzJiWCYQ8wUckRXv2izsmN2vYdiKxLpxjysDNRmEW1rGkfisg71aCOTxFN9UUG/EDr8KkDreHTMRUEcjn7X3uN1T0FSm+S5FMfleeVq5Gj6V7vVYvR4y1z4W4g9hBYQmWuZtC3dvlEhnohv4iHHzC+mvo282L0gK0k6OHFYBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987705; c=relaxed/simple;
	bh=n9pCXxGvGQF8hM4Mc0k1YSoO6ALXLMGATB15bD5wSd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq+WmQf1xj37chTGAY5idF7cBwLUXHaGWtkSuAGg3NTvfnzqqL6G3tfs9tNiLTUu66inf8TQ7wrI1X7lt4HVJhqoAhg/hjckn9mCw59RXdEcUJcIPFQwVbhZnpS0WvdYzbmCmqPXKWFBv/0g5R3o4iWWQTVSbXUnSBop5p1vuto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2k0VVBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2k0VVBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352D2C433B1;
	Mon,  1 Apr 2024 16:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987705;
	bh=n9pCXxGvGQF8hM4Mc0k1YSoO6ALXLMGATB15bD5wSd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2k0VVBkG0MQoMBksXwGhcuTQpyqloe3AK+gbVYux8eX+s5f0asFhy2SUrxsbQfr+
	 Fauo/XnosNYbUrVhwZoME4azSDORsKxR01gfzpGX+MfVcakb/ZV3W/RF33kO9TOkLt
	 FCUx1kAZZumnGa+Rw7FlSGcyLDhiVhubhc6fW6Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aisheng Dong <aisheng.dong@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.8 368/399] usb: typec: tcpm: fix double-free issue in tcpm_port_unregister_pd()
Date: Mon,  1 Apr 2024 17:45:34 +0200
Message-ID: <20240401152600.162582140@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit b63f90487bdf93a4223ce7853d14717e9d452856 upstream.

When unregister pd capabilitie in tcpm, KASAN will capture below double
-free issue. The root cause is the same capabilitiy will be kfreed twice,
the first time is kfreed by pd_capabilities_release() and the second time
is explicitly kfreed by tcpm_port_unregister_pd().

[    3.988059] BUG: KASAN: double-free in tcpm_port_unregister_pd+0x1a4/0x3dc
[    3.995001] Free of addr ffff0008164d3000 by task kworker/u16:0/10
[    4.001206]
[    4.002712] CPU: 2 PID: 10 Comm: kworker/u16:0 Not tainted 6.8.0-rc5-next-20240220-05616-g52728c567a55 #53
[    4.012402] Hardware name: Freescale i.MX8QXP MEK (DT)
[    4.017569] Workqueue: events_unbound deferred_probe_work_func
[    4.023456] Call trace:
[    4.025920]  dump_backtrace+0x94/0xec
[    4.029629]  show_stack+0x18/0x24
[    4.032974]  dump_stack_lvl+0x78/0x90
[    4.036675]  print_report+0xfc/0x5c0
[    4.040289]  kasan_report_invalid_free+0xa0/0xc0
[    4.044937]  __kasan_slab_free+0x124/0x154
[    4.049072]  kfree+0xb4/0x1e8
[    4.052069]  tcpm_port_unregister_pd+0x1a4/0x3dc
[    4.056725]  tcpm_register_port+0x1dd0/0x2558
[    4.061121]  tcpci_register_port+0x420/0x71c
[    4.065430]  tcpci_probe+0x118/0x2e0

To fix the issue, this will remove kree() from tcpm_port_unregister_pd().

Fixes: cd099cde4ed2 ("usb: typec: tcpm: Support multiple capabilities")
cc: stable@vger.kernel.org
Suggested-by: Aisheng Dong <aisheng.dong@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240311065219.777037-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -6199,9 +6199,7 @@ static void tcpm_port_unregister_pd(stru
 	port->port_source_caps = NULL;
 	for (i = 0; i < port->pd_count; i++) {
 		usb_power_delivery_unregister_capabilities(port->pd_list[i]->sink_cap);
-		kfree(port->pd_list[i]->sink_cap);
 		usb_power_delivery_unregister_capabilities(port->pd_list[i]->source_cap);
-		kfree(port->pd_list[i]->source_cap);
 		devm_kfree(port->dev, port->pd_list[i]);
 		port->pd_list[i] = NULL;
 		usb_power_delivery_unregister(port->pds[i]);


