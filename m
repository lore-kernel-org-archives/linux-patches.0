Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C6519E7F5;
	Thu, 15 Aug 2024 13:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728855; cv=none; b=tkzkXsvAWw5V7EfcMvyrnvr+w6fMv1cBzbDORZ4M2qGMamq4PgBJ4Gv8v0nGV9rwLgsEioYDkZPERB3i2RWddYyzeHtId8e7YKD4D+FLAzhqTWDCbBRyTw41yUtnU8Z+2tiJzbhXtAMYm0NqRj6wmE46jHO3HzCJkQwWgwbrnJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728855; c=relaxed/simple;
	bh=f/cYt7z+9W7sF4Tqdsx2HM1NJl8W2cBCqkJgMXqtNyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sIZ8+zzayGQWsHkvytMc0fMdoR0Q/G/KKpzoHNPNRYj3QhqD/vTmrQsU+SH5M6C3tw8jePpS/2WAS9rOWHsFGWIMH94Jp7sxg8R9BXqZJ3cbgWghVkgzakaJJrIQj2U4LNpcIeDIQu902/I62FnZzXhj3nLlMXzUvUuJPlRcLTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrUdAAPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrUdAAPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00E6C32786;
	Thu, 15 Aug 2024 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728855;
	bh=f/cYt7z+9W7sF4Tqdsx2HM1NJl8W2cBCqkJgMXqtNyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrUdAAPecKgoE1wVqAAGTLXnHAgxoQ1ppnps76CIVLMQfFQwiKb+IBH1iuXceMzjp
	 DTTWl0x2yMHpErVYEzNyLwgeEVOcyYtwd1nr7vK85q/zPtqZ7KwM2WEa64KWTPBu1k
	 J5HuCqyoHA4nFapD2Rp3Q1HZVZfbv1MM7awoXydA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/196] net: usb: qmi_wwan: fix memory leak for not ip packets
Date: Thu, 15 Aug 2024 15:24:08 +0200
Message-ID: <20240815131857.087241397@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3c65549a8688a..881240d939564 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -241,6 +241,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			break;
 		default:
 			/* not ip - do not know what to do */
+			kfree_skb(skbn);
 			goto skip;
 		}
 
-- 
2.43.0



