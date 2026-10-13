Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C98442390;
	Tue, 13 Oct 2026 11:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892074; cv=none; b=jXen8aSwX5vG3NVnxHoGMq6mpwvz6xD/Od/gcVixOs3rUJYNUfNLOgnDevpcXYHVZRiGVMIcNgYgZqQAQkLqvTYQgPQ0wrhIQ3SyKd2KKyJP5Qp7MJhg/mfsJEgDVlwWG+sZGgQ3/cVv2slfBIO9MQ1HMZPISKYdupNk/LsrQCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892074; c=relaxed/simple;
	bh=mwGxKhLIdu9z2HmjOwURnefZyS+upCUTKqoA2YFGB8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tzebf4eoiYQIjTnwf803A8n/5OQc7kUmbPE+B79p5U4/h1tT+c/rXW0SbQgKa+ydYEcPFzLbVw5814nD5L04EG9VodkOYGZcTsji7l2DTJaQmwI/6gWSTFPTcM9AqyHLx7hkcVsEHLXmRzm7sH1N7DtCrSLShdB427J1hx7qHmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMRFmUD6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMRFmUD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AF41F000FF;
	Tue, 13 Oct 2026 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892072;
	bh=+UXWVnzgGmAOEYboY5AcR4pqdZ7RpFC8rV8tbgz4l30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMRFmUD6t0W6tbbjoZF76kpe/RpOEBQJm0DcC+kdihejNTcgqa0IXl+lHMHkx1F8Y
	 5KXoncKK/wQICBi153c+rbGAabtYc2fyzA8MHYCuaGJUB3EmThyAFVer1tAIyM4/ws
	 zUCZGX1MN5fYPES7D9zlYrAf281U9dpFOPx4HgRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Herrera <javier.herrera@afronta.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 051/281] e1000e: add system to disable K1 list
Date: Tue, 13 Oct 2026 13:36:07 +0200
Message-ID: <20261013112856.291499544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Nguyen <anthony.l.nguyen@intel.com>

commit 1d6500523b8d5112afe0118173ebc8c1ca23784e upstream.

Javier reports seeing packet loss issues related to the re-enablement
of K1; disabling it makes the issues go away. Add the reported system
to have K1 disabled by default.

Reproduction steps (from the Link):
Plug the cable and ping the default gateway on the LAN. No suspend/resume
involved, machine freshly booted and on AC power. Nothing e1000e-related in
dmesg apart from the link up/down messages; no "Hardware Unit Hang".

Default (K1 enabled):

  $ ping -c 30 192.168.10.1
  --- 192.168.10.1 ping statistics ---
  30 packets transmitted, 18 received, 40% packet loss, time 29734ms
  rtt min/avg/max/mdev = 0.211/0.315/0.384/0.046 ms

The lost packets are spread over the run (seq 6, 8, 9, 11, 13, 14, 16, 19,
20, 24, 25, 30), not a single burst. DHCP on this link also takes 1-2
minutes to get a lease, consistent with incoming packets being dropped.

With K1 disabled at runtime:

  # ethtool --set-priv-flags enp0s31f6 disable-k1 on
  $ ethtool --show-priv-flags enp0s31f6
  Private flags for enp0s31f6:
  s0ix-enabled: on
  disable-k1  : on

  $ ping -c 30 192.168.10.1
  --- 192.168.10.1 ping statistics ---
  30 packets transmitted, 30 received, 0% packet loss, time 29713ms
  rtt min/avg/max/mdev = 0.169/0.251/0.468/0.054 ms

  $ ping -c 30 192.168.10.1
  --- 192.168.10.1 ping statistics ---
  30 packets transmitted, 30 received, 0% packet loss, time 29677ms
  rtt min/avg/max/mdev = 0.101/0.222/0.360/0.064 ms

I have only compile tested this, but Javier has tested that disabling K1
on his system (Lenovo ThinkPad P14s Gen 5 (Intel), I219-LM [8086:550a])
resolves his issues.

Cc: stable@vger.kernel.org
Fixes: 578294b8b60d ("e1000e: Reconfigure PLL clock gate timeout and re-enable K1 on Meteor Lake")
Reported-by: Javier Herrera <javier.herrera@afronta.com>
Link: https://lore.kernel.org/intel-wired-lan/CAKRuCQLWEcci9hPgNUmvq44Bd2H30T5_vP=exMjsknXMN5Yh9A@mail.gmail.com/
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20261001222443.3500206-7-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 844f31ab37ad..c282f65199e4 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -67,6 +67,13 @@ static const struct dmi_system_id disable_k1_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro 16 Plus PB16250"),
 		},
 	},
+	{
+		.ident = "Lenovo ThinkPad P14s Gen 5",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad P14s Gen 5"),
+		},
+	},
 	{}
 };
 
-- 
2.56.0



