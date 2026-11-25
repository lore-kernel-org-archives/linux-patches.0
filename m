Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619084;
	b=C2xAmPC6DHXsC6JdfhmduT/ys9Iiva3H9Kkn6LM1slRFqlGW0RQ35jTF6NmvDVqp57oX
	 hpw4/ggph3kPMC+o6BMVlHqlIbvyqJor+UTTdHD0Ung5zxIWbDKmernM8XSDcqvmrgfpH
	 NVfQ3IUJXzFxy6lQMLvCcQZA02wF6/Mkllxrt6vvZkXmCjRW83axLCTuadGslW4tvme4w
	 tWA2d4Ptet7zRQotn5ILpnKaMmaUFyz5s4lL4WY6agawdy1zAn/99sKy38kQTE080Rskq
	 GluyGixwtqE8pg3GJ8f2mEXBh4Pj6hR7ymF2NxWxX2MIDIikbWzxGLcAMoEhk3iRGWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iFdnbdi4UQWWuubD/mkNQpeX9pJo8ldSc9wNg90qrpY=;
	b=tjPlMgv7TL6AhG/Pw+hjo8BWBWuIw5/pi7hLk0g72UKH8sK05ArpQwENncevxMVVzUkS
	 sPqkpC26zv8EIlTmU5dp7l5QDjX3NFGQ+f6YvLGDZbjnv/q/uZlko4iVfO6C1o6u73Um8
	 Y9QfqV89FzDIImYpqdNyyBoz6EOv1kOaBORFN8nVB1U+GUapNdqITQnHzuPuTpKNIqKiW
	 Ko5bLtVzY2Xv0LOxVgfXEiGJ+SKNCO43oJTVtQlCP7/bE1fS8VR/aAk6gLE+8mA1cXlBP
	 mgyPkZOhSwt2kUOft8ivcw47NlqE1MZ6xdFNDqGnOAB4v7xa2Lao2jaeHEcFbSvCKWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15eMxui0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F91D606A31E;
	Wed, 25 Nov 2026 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15eMxui0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54791F000CF;
	Wed, 25 Nov 2026 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619084;
	bh=iFdnbdi4UQWWuubD/mkNQpeX9pJo8ldSc9wNg90qrpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15eMxui0Bf9x3iN+oe5EiFe0EC2/pL5q9KTlC44h0ha6smypoiBANybW619oYfazV
	 1GMupZ/kvSGLzTOkAZ/LTxKKMcKyPU+5Ng1aWcGSSOxy6C+jVcZ5AMr2TsPcGKv7Wv
	 ShgMWcqSib9ziLC/xRD7ZnFT5+2paxOeZNhCDVPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0483/1005] fbnic: Suspend phylink after taking the datapath down in ndo_stop
Date: Wed, 25 Nov 2026 15:30:21 +0100
Message-ID: <20261125143833.063298756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit b45b9c6b83e7a5ac440d36b46ed9b466788b3e5c ]

The fbnic_stop function calls the phylink_suspend function before the
fbnic_down function. With no BMC present that stops phylink, and the
fbnic_phylink_mac_link_down function disables the MAC and holds its Tx
and Rx clocks and FIFOs in reset. Only then does the fbnic_down function
stop the queues and wait for the Tx path to go idle, so anything still in
flight has to drain into a MAC that is no longer passing traffic, and the
fbnic_wait_all_queues_idle function can be left to time out and force a
flush. With a BMC present phylink leaves the link up but turns the carrier
off, which the phylink_suspend function notes assumes all packets have
already been sent.

It is also the reverse of how the interface comes up: the __fbnic_open
function resumes phylink last, and the fbnic_up function then enables the
queues and installs the host Rx filters.

Call the fbnic_down function first. The Tx path then drains with the link
still up, and Rx is still stopped first, as the fbnic_clear_rx_mode and
fbnic_clear_rules functions remove the host as a destination for its MAC
addresses in the RPC before the queues are disabled. The MAC IRQ is still
freed before phylink is suspended, so no link interrupt runs while the
link is taken down. The PM suspend path goes through ndo_stop and picks
up the same order.

Fixes: 6ede14a2c636 ("fbnic: Move phylink resume out of service_task and into open/close")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Fixes: 69684376eed5 ("eth: fbnic: Add link detection")
Link: https://patch.msgid.link/179381516644.9644.9042901965231900737.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 10bf99be3f244..9c205999b29a2 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -86,11 +86,11 @@ static int fbnic_stop(struct net_device *netdev)
 {
 	struct fbnic_net *fbn = netdev_priv(netdev);
 
+	fbnic_down(fbn);
+
 	fbnic_mac_free_irq(fbn->fbd);
 	phylink_suspend(fbn->phylink, fbnic_bmc_present(fbn->fbd));
 
-	fbnic_down(fbn);
-
 	fbnic_time_stop(fbn);
 	fbnic_fw_xmit_ownership_msg(fbn->fbd, false);
 
-- 
2.53.0



