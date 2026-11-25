Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622091;
	b=GWCawRvntHuaztCjlUfE+DOnr1Js7IOgzYuFfqk388Rr/85IUnT9X1119D4uJgfxtNnZ
	 7P+LxdXpdKlhP2XtYNm7Rz/rLSdis07tErX02GlK9S+a7JW87HTBzQJymkeMYG5o1WnUq
	 H7hhbiKUDPeQJJssvkFwYUScqrp+ffwqABC4K0Xvc9qbH4XzpjEgCm+sJxOcBHYqh9C0R
	 vYQ7MNk3r3nso2mQMfQKnU2O6IcFlMsIjBteGqEfT5rUm+bGv21fEMgA+ay7gaQaTBKDq
	 ph6FSCVVVyXr5UJH5wcKaF7l5189JEAdXkGmrYA2jCU9OKLH9nMqaiVCrdvkZEu7vig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x9g2AbPWdzMsBUqSg+ykvwcSJ659EuVPvapccYz5y08=;
	b=o2TX6StrzsEEv0prvQZYUtmc59ANJkZqyX+9zo1U7fGM8vyS93wLx+68l/9oQ4rW12f3
	 ekWrP8SAUDZ6c6IMUqrpRytv20HFcK3S+YHt2xZKJS/VuvOT2m2HudLkbMVaPE/UComqW
	 9dshcxeRGS3Dh438w2BUbeyQe0lVmGXv42DFP6xqQYt5SaUTkcrHgpDjHR9EDcUmCDLZ6
	 2HJax9gkYK8nIRm00LgDNlUi/puG280MWXUtl/lb0QIRKKI2xo3aG2rNdFzaXq+7PvJkE
	 Wj+WW7gdyd6F7BXr40D5bTgvTI+vh7p2NVakG3EtAjA6zGG51aGQNz+4HccFvFPT5+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I85lW6dz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45D5606A323;
	Wed, 25 Nov 2026 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I85lW6dz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDC71F000C4;
	Wed, 25 Nov 2026 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622091;
	bh=x9g2AbPWdzMsBUqSg+ykvwcSJ659EuVPvapccYz5y08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I85lW6dzFSD3O1mRpPSmnWY2a3Oe9H2i7NJgfa8k82BqWnfk8/FDP7ikW8X2WWzvF
	 oDpZ6mRkCfLEWP3ARQmQZyr2qziW6rPZOxwL6OO25V3FFnouvu6z+sS4lbrEK2e3P2
	 Jt67sThVAK8YVEeNkQUhgN4kR0WMT6ioiCmeU2Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 427/990] fbnic: Suspend phylink after taking the datapath down in ndo_stop
Date: Wed, 25 Nov 2026 15:29:54 +0100
Message-ID: <20261125143832.098405621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bd738155adb2d..8e97c4e7f32b4 100644
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



