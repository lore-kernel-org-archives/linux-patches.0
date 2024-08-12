Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196D2186E51;
	Mon, 12 Aug 2024 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479858; cv=none; b=Biq4u+76cbzG5RacWEI6luToiB8p0zLCM6+PNqE7375q2RRTg7j7CW0bk993yEBSKrTfCmmilhOCFVjYSUNTo1XU+nJ4GRpeiB+AIi5mZQBi2BvHiWmPrnlgLq905tnU9wM7rLp5os+dowLM+CcMS2Om0YGcUa832nzBKoeJGTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479858; c=relaxed/simple;
	bh=TPrOuDOGOvuWYcGjdfyDwoZV5byHWYTvpoa3s+F2wyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ruG8dvNzB59mnBdtshtDfsLr+s3faFwH4jYgaTVFNcKViyBRbrWuMpkC2r7cZGGafrs136vSO1I3LuL0aRlnoVsYZze9phPRStm43LFpd1QKscPjrBijkb+ZiCibshQJwX76GxzZfalKnaWA8jokUTbA9ip++ZhLdghRoQ/OweE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrTDFCjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrTDFCjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95211C32782;
	Mon, 12 Aug 2024 16:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479858;
	bh=TPrOuDOGOvuWYcGjdfyDwoZV5byHWYTvpoa3s+F2wyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrTDFCjEeE3ySKCQ36dc6SLVzm3xV7++M0sSPtTMieAgqfcMRjXb1NGaAm6r+uWI6
	 hEKJYbmKZd+emExjo0izbbe7EjeYRI/e7f8HUi2FBJmxM1kl8tnXkoL7mFjKHXdaG0
	 uXezS6LHMQT+2xMp6glBeBiFzyQ0Nnrvne4edxvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 023/263] net: usb: qmi_wwan: fix memory leak for not ip packets
Date: Mon, 12 Aug 2024 18:00:24 +0200
Message-ID: <20240812160147.429271587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 386d62769dedb..cfda32047cffb 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -201,6 +201,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			break;
 		default:
 			/* not ip - do not know what to do */
+			kfree_skb(skbn);
 			goto skip;
 		}
 
-- 
2.43.0



