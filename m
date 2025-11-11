Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0116930BBBF;
	Tue, 11 Nov 2025 01:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823330; cv=none; b=tAA6OrII6x3CAWnpHIr8ZVdTSSnTh8t/0oX7IBRHqoO/p3yQb+d3cfA/fcpsuNmJWhTU+xnTph6KEbrcbfVavL/lR5THZEOdn8Pr/nIdbReO5OA85uK2+WjS58GjC7FDZNVFEt3UpWeV9kjLzFsuX6L/AmZkVFQFPPYwwdeNWvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823330; c=relaxed/simple;
	bh=V8rCj03XCcLAxSyxvo582CJUFyJsMLIGQJ3s+AQ0flY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg8JWmea7bhUYq/Rki78WJJSu70amcei5zgz+aHwYiH9WQUC4jUtn2H9UMvtE326sTut/6qPa3G7YjapSDCSSWgJEWmcyWk0uHJ5WgGuLDjgA8obIMMxEQpg8m7KFatfNOX4it4zatA1PxLtjptM3QPYkY2Y7K7FOdTgI3u5MnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0xK9okP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0xK9okP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7C6C4CEFB;
	Tue, 11 Nov 2025 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823329;
	bh=V8rCj03XCcLAxSyxvo582CJUFyJsMLIGQJ3s+AQ0flY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0xK9okPORJmuRHr5H34eCp86Jfqd/7bHQ+X/JtzXgc6wamNdSVOv/ImNYW9bmBd/
	 sAYDqiq0OQPPWNty9eBmVzRSybLl5zX48GnX/woFAV+c+rzDXRPaFHctaoS+neGUAX
	 L4ah+qh4HN64oHglASLncR9uOjAeeZyPmHfyIUbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Oniszczuk <piotr.oniszczuk@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 277/849] wifi: rtw88: sdio: use indirect IO for device registers before power-on
Date: Tue, 11 Nov 2025 09:37:27 +0900
Message-ID: <20251111004543.122727774@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 58de1f91e033b1fface8d8948984583125f93736 ]

The register REG_SYS_CFG1 is used to determine chip basic information
as arguments of following flows, such as download firmware and load PHY
parameters, so driver read the value early (before power-on).

However, the direct IO is disallowed before power-on, or it causes wrong
values, which driver recognizes a chip as a wrong type RF_1T1R, but
actually RF_2T2R, causing driver warns:

  rtw88_8822cs mmc1:0001:1: unsupported rf path (1)

Fix it by using indirect IO before power-on.

Reported-by: Piotr Oniszczuk <piotr.oniszczuk@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/699C22B4-A3E3-4206-97D0-22AB3348EBF6@gmail.com/T/#t
Suggested-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Tested-by: Piotr Oniszczuk <piotr.oniszczuk@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250724004815.7043-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index cc2d4fef35879..99d7c629eac6f 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -144,6 +144,10 @@ static u32 rtw_sdio_to_io_address(struct rtw_dev *rtwdev, u32 addr,
 
 static bool rtw_sdio_use_direct_io(struct rtw_dev *rtwdev, u32 addr)
 {
+	if (!test_bit(RTW_FLAG_POWERON, rtwdev->flags) &&
+	    !rtw_sdio_is_bus_addr(addr))
+		return false;
+
 	return !rtw_sdio_is_sdio30_supported(rtwdev) ||
 		rtw_sdio_is_bus_addr(addr);
 }
-- 
2.51.0



