Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9E220B00
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEt0tVY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC34DC433C9;
	Mon,  6 Nov 2023 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276813;
	bh=AAfjoUCq/7u3WA2VjfGa5jrFTtJmbzRvxqB4T81b8as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEt0tVY1N1qZgAmYQePLORdmJOnUzupweGtKgyiVWuUsph9nAJO0Yl8lz3E0QUS91
	 uR5JCrS4HRDpoqEYzqmvatVlHXVsn6SZHZjrksLaCJhEqmKKFCZUywJd0NVLIxqxe8
	 mKDHZflYTJ8KJEnbfzYZ/+j3Lof53Xg7aUoWW+O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Grant Grundler <grundler@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/74] r8152: Cancel hw_phy_work if we have an error in probe
Date: Mon,  6 Nov 2023 14:03:36 +0100
Message-ID: <20231106130302.271981192@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
References: <20231106130301.687882731@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit bb8adff9123e492598162ac1baad01a53891aef6 ]

The error handling in rtl8152_probe() is missing a call to cancel the
hw_phy_work. Add it in to match what's in the cleanup code in
rtl8152_disconnect().

Fixes: a028a9e003f2 ("r8152: move the settings of PHY to a work queue")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 8f8ad48ffb011..472b02bcfcbf4 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5779,6 +5779,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 out1:
 	tasklet_kill(&tp->tx_tl);
+	cancel_delayed_work_sync(&tp->hw_phy_work);
 	if (tp->rtl_ops.unload)
 		tp->rtl_ops.unload(tp);
 	usb_set_intfdata(intf, NULL);
-- 
2.42.0



