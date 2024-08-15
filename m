Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EFC176AD7;
	Thu, 15 Aug 2024 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731627; cv=none; b=PM6Gis6jfjS35ciZKnClbjO3PbNQGeWD9zdQduzK7gHAAdSTYoegKqJfvBT+b9k+PrIdVNftiowhfwgug+G6HAn7UX1hJYocjaH8bW4CoSAbFVmwxY3PLPzOdUACVZitAfp9SycoWNWq9THqxUatt/nJ8jhM0nRKpX0YdTxFVXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731627; c=relaxed/simple;
	bh=acfLIx3YC9kndQ1SkP3xWWnJ+dfnDTwXP4Ffnm/k3U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDvwUvWOno4Hpm/3579fnFJHWP3PQ4EOIvQlj9vvHWz98XPhYDq99lBXYUNKpP9WaIfrnNVBBu/GTEmQPyIux2v6zXg76aGZDXzEUo0Y1vhFxZsA/uHWfyP6/yRnJZ0gP3IGvdn2CdMGynHUrRuChl2xZznLFNF0FuzdD/BFTzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXROF7cD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXROF7cD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B162BC32786;
	Thu, 15 Aug 2024 14:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731627;
	bh=acfLIx3YC9kndQ1SkP3xWWnJ+dfnDTwXP4Ffnm/k3U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXROF7cDZIyCOLqvfkWXVEuVmR21mCnJabLGXTSKRiUc4zXO4m0Q9KqXO/UemtZbY
	 FDUO8WSVRikL5W5Ihh1D2x1B1UHThPPsDaBYxKlpI5TJVSZoRD0D564bKKj+Np4Qaf
	 zVQ861bMN5Zw9b8XUNeH4tfvsJ6k01gnc6bz0Rsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/259] net: usb: qmi_wwan: fix memory leak for not ip packets
Date: Thu, 15 Aug 2024 15:25:21 +0200
Message-ID: <20240815131910.038598241@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 7ab107544b777c3bd7feb9fe447367d8edd5b202 ]

Free the unused skb when not ip packets arrive.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 17aa52ed892b5..3e219cf4dd851 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -238,6 +238,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			break;
 		default:
 			/* not ip - do not know what to do */
+			kfree_skb(skbn);
 			goto skip;
 		}
 
-- 
2.43.0



