Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61C130E27;
	Mon, 12 Aug 2024 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479198; cv=none; b=mP8SjuHZOvKG7z3yidOzLJ2otUoYY1acC5YZ/qsxLLWLyusZPRFb3RNXhrf+WU8wQoBvEziqGJvSkyI7AtyWx8vse5d7M5G3Gm7o4/XvTu+NrjDmMRoy4Lb3p+/tnzhPDHx9OL3xpMqClygXiDxMRCTuRK3M29VKxt4tRfArHXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479198; c=relaxed/simple;
	bh=QkBxEe3IZ2FiXujbGfQcnmINnN/i2EB0RjrEIIhtQJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y2FIlLdfwOQVWSpLDY8Z7tKK0yZs6Cbhy2OEdNVH6qX01nujfvk4DkQtIRw9AKuK4ZZCJmeY9SZ6SvDGkz4RORZfwcNmXmmRN/xf6RlrCR48tU9xAepRQcyevqwGPOJF6PJOQ8q4c9HNOIFtnTdgWlqowxrYg3wleV7qP7JMo/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTKWVnKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTKWVnKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597B6C32782;
	Mon, 12 Aug 2024 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479198;
	bh=QkBxEe3IZ2FiXujbGfQcnmINnN/i2EB0RjrEIIhtQJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTKWVnKRwhWrGhHosKrYuXFRh7xDWLnO1FkK1muk39/wczCyGEmiYnAildoHtundn
	 gC3x4a8LrW0lY//gfLNkOOpIV20Ht2CV2/4ugSAZnioNhrG2pna2nvIjJkRIgCs1Sx
	 lz7QG9nWtxmGB+zQ/xRF4jk26pxg3P7uUY5Z0NXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/189] net: usb: qmi_wwan: fix memory leak for not ip packets
Date: Mon, 12 Aug 2024 18:01:09 +0200
Message-ID: <20240812160132.653325714@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index befbca01bfe37..b1380cf1b13ab 100644
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



