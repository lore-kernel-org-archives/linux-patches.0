Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED087254863;
	Mon, 12 May 2025 17:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072709; cv=none; b=dPwCjWgw3UoXJGahOg/IaPlPup7ENOh1HxEgwtM3jdOoMj9Sla1OohWxkLs6Dq6hWKTknUcgoaQwgSL2KvqhpAl+rVQV8HmNiFVQFs7vpx2vDJZE2kWIL49icxA6NR5GbzwcgTB7KrrSzZMhM9q/jLHC7QmyG5PXfMOvrNvP1BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072709; c=relaxed/simple;
	bh=+yelJwimIs8J5FKp0q3r2q//6k14RWwsufbuElPWwAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dut9q4eD3KD7DGhzL9k13IxZbMatzkJi7tarbmJKoTUva9XwCqBGkC6k8t1TAIWgRn/nUkN8rg9epd0FeYX2dMQZV+LL/5S4rriM8Q9zudc4bpGPHZE4sL9vmutLLdTXe2P6cQdENvqDTf4c/JHF3D0I9Gk2rtjkas8TQ39PE7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvCXhmeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvCXhmeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6F6C4CEE7;
	Mon, 12 May 2025 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072708;
	bh=+yelJwimIs8J5FKp0q3r2q//6k14RWwsufbuElPWwAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvCXhmeOoha06gXaKqXWzpXkZ79rabQ5BpzhhKFhjh2KRfIY8h6iHIhYkud2U+li5
	 k0ilQOtveZiws3+3m7NuyygjJefKC4q9c/fAmVFNFmoJtHidYvtHttlYRfKR60bpqO
	 DH4NKCK1ZTHZvKpoKymlaeWj4a05/MxUyVOqWiNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 006/184] can: mcan: m_can_class_unregister(): fix order of unregistration calls
Date: Mon, 12 May 2025 19:43:27 +0200
Message-ID: <20250512172041.907512437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 0713a1b3276b98c7dafbeefef00d7bc3a9119a84 upstream.

If a driver is removed, the driver framework invokes the driver's
remove callback. A CAN driver's remove function calls
unregister_candev(), which calls net_device_ops::ndo_stop further down
in the call stack for interfaces which are in the "up" state.

The removal of the module causes a warning, as can_rx_offload_del()
deletes the NAPI, while it is still active, because the interface is
still up.

To fix the warning, first unregister the network interface, which
calls net_device_ops::ndo_stop, which disables the NAPI, and then call
can_rx_offload_del().

Fixes: 1be37d3b0414 ("can: m_can: fix periph RX path: use rx-offload to ensure skbs are sent from softirq context")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250502-can-rx-offload-del-v1-3-59a9b131589d@pengutronix.de
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2456,9 +2456,9 @@ EXPORT_SYMBOL_GPL(m_can_class_register);
 
 void m_can_class_unregister(struct m_can_classdev *cdev)
 {
+	unregister_candev(cdev->net);
 	if (cdev->is_peripheral)
 		can_rx_offload_del(&cdev->offload);
-	unregister_candev(cdev->net);
 }
 EXPORT_SYMBOL_GPL(m_can_class_unregister);
 


