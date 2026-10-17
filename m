Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A1D3B6C06;
	Sat, 17 Oct 2026 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256527; cv=none; b=m8sGFsw43puEZI1orZLGpmDZO2yioDFzBf3Zqkuj3hed/LOCtjrkp+QUTxhFQ7zQsWYLY+Pm9ZWWPt7a8kbMPKywxVpT/JFgQ06HkRuRXBbmkBTpE7uNVRlBl2OhYyJouUiyzeDYNhz20U5LdozDqbVdKxKowxuwJRTFuvWh2yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256527; c=relaxed/simple;
	bh=fZKt0/YuyySw+AcXUQbmw+EXuXFsop+KpAlVuZx5Q2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fiut/3lsyA0guClXW6NyDHJkIS5Hzxp28xtSBZ6leQdcg7LQoXQSWuvbtuONvqSCHm9UePn3KFy+3E/mLMAInLH/q+BBdiN0bGJea9Spo/F3WzCbhT8rbI7vjK2bF2s5g+ycWGyIBBy3dVXM8NgGdQ5uTtc5B+33nwlYKGBMJK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fo3sMmG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fo3sMmG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9258C1F000C4;
	Sat, 17 Oct 2026 17:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256526;
	bh=X8tlTff9rZ3qd0YvZzMVFe3DeQ6oT+kDUsJY97pDvdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fo3sMmG9XQiYu5CjUko+SdfK7VCeoHIyBvzrOvNCavusDaox0pn+335fvBxMvN14e
	 oFcedTb9YqxxAj8Q/+VJzhUcduhzYSFlIT0TAx2wcneMh8t+nVTdO2HjamAucKwoO5
	 J3LfkGhgFrt9GpPQjJe9vk++LnQRsqcBduxOlk/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 0266/1674] usb: typec: anx7411 - stop the IRQ before destroying the workqueue
Date: Sat, 17 Oct 2026 17:42:18 +0200
Message-ID: <20261017160437.951993372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 469600d5d292b1482c90dd6853555821d11b8c5f upstream.

The IRQ is devm-managed, so it can still queue plat->work while
remove() is tearing the queue down. Disable it first.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable <stable@kernel.org>
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260910011150.2966843-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1571,8 +1571,11 @@ static void anx7411_i2c_remove(struct i2
 	anx7411_partner_unregister_altmode(plat);
 	anx7411_unregister_partner(plat);
 
-	if (plat->workqueue)
+	if (plat->workqueue) {
+		disable_irq(plat->intp_irq);
+		cancel_work_sync(&plat->work);
 		destroy_workqueue(plat->workqueue);
+	}
 
 	if (plat->spi_client)
 		i2c_unregister_device(plat->spi_client);


