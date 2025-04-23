Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556BC2C10B9;
	Wed, 23 Apr 2025 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421884; cv=none; b=bXaii702GgFYAj7lGfo/9mB4n1pI3ZAP+3wYghTL8rkWgjo4o3zE+tM88DalD+TDfHYwG5yIB52wLIpZq/kZDzamt5vlIr1wFoNlYFwBNkubg6o5232NwhUzh3UvdIcu7TdBcaYac8AN2mkdCTWX9+1OSDfmMVtC4LYD0zIpNPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421884; c=relaxed/simple;
	bh=WQfWNi1r7Ec+RL5+WmMhR3+DsW3OlOhDQGBuKMoRQpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzVgqpPWgybXcqWZg0mJi5aNi0Zp18G4EYCuf4e1vyr9xE4V509KfG/a0rDPE29Kgp3FZA5z8TUXM3WQRzCr5uxUZEHWdr4cNC+PNkmoJzb+BLj4U6x83WpNwAWjawrKQnNXnfX8XQ7dZwVV33p+c5D2t3GEISb0wlAe2k9P+Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxb5AVKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxb5AVKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD50C4CEE2;
	Wed, 23 Apr 2025 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421884;
	bh=WQfWNi1r7Ec+RL5+WmMhR3+DsW3OlOhDQGBuKMoRQpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxb5AVKiNrwT8lc2nk10KF4e9mEMfsEllSwIaWAeYEkP+HyRBYFI9+cn2NULOfkGj
	 2bMCb5kDUdBnCWDtyB4WfiD3toN/2o/yWOaXw2WXtwQ7qnZPxA0E7MuW6GIC5NPwvh
	 NfgERvNaDhiXQCKq7tL21Tgzxd7mGuPjqCqY2GOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 239/393] HSI: ssi_protocol: Fix use after free vulnerability in ssi_protocol Driver Due to Race Condition
Date: Wed, 23 Apr 2025 16:42:15 +0200
Message-ID: <20250423142653.257989712@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Kaixin Wang <kxwang23@m.fudan.edu.cn>

commit e3f88665a78045fe35c7669d2926b8d97b892c11 upstream.

In the ssi_protocol_probe() function, &ssi->work is bound with
ssip_xmit_work(), In ssip_pn_setup(), the ssip_pn_xmit() function
within the ssip_pn_ops structure is capable of starting the
work.

If we remove the module which will call ssi_protocol_remove()
to make a cleanup, it will free ssi through kfree(ssi),
while the work mentioned above will be used. The sequence
of operations that may lead to a UAF bug is as follows:

CPU0                                    CPU1

                        | ssip_xmit_work
ssi_protocol_remove     |
kfree(ssi);             |
                        | struct hsi_client *cl = ssi->cl;
                        | // use ssi

Fix it by ensuring that the work is canceled before proceeding
with the cleanup in ssi_protocol_remove().

Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240918120749.1730-1-kxwang23@m.fudan.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hsi/clients/ssi_protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -401,6 +401,7 @@ static void ssip_reset(struct hsi_client
 	del_timer(&ssi->rx_wd);
 	del_timer(&ssi->tx_wd);
 	del_timer(&ssi->keep_alive);
+	cancel_work_sync(&ssi->work);
 	ssi->main_state = 0;
 	ssi->send_state = 0;
 	ssi->recv_state = 0;


