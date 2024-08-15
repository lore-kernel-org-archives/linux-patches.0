Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D421993B9;
	Thu, 15 Aug 2024 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732788; cv=none; b=cf4gIEX436s4KRie690rPjKMzfHQBbi6q8YCaNscmnN2K+AJP8R1H956LJNrqjl+HnadSdi1hMNms7QhQ7s/dA+W876dfheBW+7JnxALE6ujupxwnPwSG2Emc6ytfBOz6N4s0vOoD04xaEEeZa+BYaXmPltpGsgc6+H6RDG+IK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732788; c=relaxed/simple;
	bh=xqvwKVonVQV+hSn68EwDpkm6sMhvrhpK8StF1GnsciI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcvpJG+d0oT/1GhXT/P/Xq/rPNruC0/GvH+iNFTbXwo4cPMmu2IwnYLoP4/RkhKCOKSyfJAvKQDch8xFiWgyH3IGhfpL61e5gWtdumpDqUGJESv+9S5CqizwlSkd84z+YPKbRoWs+8MCWhRZOGj3WZxL4EGvx4mKVpagLyeOiWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9UXrq3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9UXrq3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B6DC32786;
	Thu, 15 Aug 2024 14:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732788;
	bh=xqvwKVonVQV+hSn68EwDpkm6sMhvrhpK8StF1GnsciI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9UXrq3TnIR5u8k5a2pm+PRfvPsnPz2nC1J5XF0iL375irf1CGbsWq1Q5pATMpuvw
	 yz+DJCQJFKP0y5L6tYdbB2XJVibRnmgnYy3oxxIfEj1mcbKe7zvlaNuu3K2udd3O+D
	 7RL0PATkjenxB3ZxLF66nZO2GB78R52V9Fe7/X4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/352] net: usb: qmi_wwan: fix memory leak for not ip packets
Date: Thu, 15 Aug 2024 15:25:21 +0200
Message-ID: <20240815131929.293422546@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d2a8238e144a6..47cc54a64b56d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -216,6 +216,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			break;
 		default:
 			/* not ip - do not know what to do */
+			kfree_skb(skbn);
 			goto skip;
 		}
 
-- 
2.43.0



