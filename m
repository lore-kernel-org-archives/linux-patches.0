Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ACE208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJlYhlBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5730C433C9;
	Tue, 31 Oct 2023 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774595;
	bh=qCnTs5awM401N3syw/+jv6DlbW03gZuIjEBkCiKcuv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJlYhlBqZpf0pv2vpaDv7E5nNHTgRxFg8JqlIImPNjFvcPc8UTfberaNb4u4lbdE/
	 bMlYr03Ni9rPiLTEbt9j4QKqxW62VnYkGqTn3rA76eFX9uHucb6jDqdQkpoBhsm5OE
	 sQKR+N6Cfbyur6JxdJ4sftPNi7eNpWWZRybRg7yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Grant Grundler <grundler@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 063/112] r8152: Run the unload routine if we have errors during probe
Date: Tue, 31 Oct 2023 18:01:04 +0100
Message-ID: <20231031165903.317724983@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 5dd17689526971c5ae12bc8398f34bd68cd0499e ]

The rtl8152_probe() function lacks a call to the chip-specific
unload() routine when it sees an error in probe. Add it in to match
the cleanup code in rtl8152_disconnect().

Fixes: ac718b69301c ("net/usb: new driver for RTL8152")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index bf83ce5317cea..86fbad8c2264c 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9802,6 +9802,8 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 out1:
 	tasklet_kill(&tp->tx_tl);
+	if (tp->rtl_ops.unload)
+		tp->rtl_ops.unload(tp);
 	usb_set_intfdata(intf, NULL);
 out:
 	free_netdev(netdev);
-- 
2.42.0



