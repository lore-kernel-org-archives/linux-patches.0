Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF14145FFB;
	Thu, 13 Jun 2024 11:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279387; cv=none; b=O7e9aIT9n01mEYm5VONGwxpjt5MHActNriP8SxyxXm7VczFNHkebVTE6TBSaxLatuzaG0MVHWsaEgZ/aK+1oqvdyspHs85ciZ++QCngM41yOCbrdmfPiKcYuXdeEaxYiSGdHk8+zMnqnYDco/HECUHTyJ7KfGYDaQhmO83skoqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279387; c=relaxed/simple;
	bh=GP06yhy/WyqS/ItOGH4PxJwPc1rOk+DA9bPIa+IwSgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsyHjm8po2l2qlGHYXEBbirIqV8zOyAPC5w7P4YamL7kxSbNgRdp6HhFQ1v4uhpV2I9liyZlXTkOMQSTi1z7gjI9QIkzciOvf9AOH4N8mRa0iinBgTDPTl+LX58FW4pZmUohyhGONHO6md9QNGyUHEFHr2jKBhX2bj+FJG7Fn5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFcaqRwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFcaqRwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D872DC2BBFC;
	Thu, 13 Jun 2024 11:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279387;
	bh=GP06yhy/WyqS/ItOGH4PxJwPc1rOk+DA9bPIa+IwSgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFcaqRwf1kFBcszzR4152zHpZgbrdiEds5i9uDwG8hJWQ39lx5yb10f4M2bbTqFfU
	 wcRBB/mQsUwDJRQgFygIp/rqAlC1jZkBTfR97TIDEDYcmCLZPJ9IPF2k8Yeh3RFwd2
	 Gp0gflNThwi2rhOC2nUsFES5rqIZkF8l5+didIFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.9 028/157] wifi: rtlwifi: rtl8192de: Fix 5 GHz TX power
Date: Thu, 13 Jun 2024 13:32:33 +0200
Message-ID: <20240613113228.505406754@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit de4d4be4fa64ed7b4aa1c613061015bd8fa98b24 upstream.

Different channels have different TX power settings. rtl8192de is using
the TX power setting from the wrong channel in the 5 GHz band because
_rtl92c_phy_get_rightchnlplace expects an array which includes all the
channel numbers, but it's using an array which includes only the 5 GHz
channel numbers.

Use the array channel_all (defined in rtl8192de/phy.c) instead of
the incorrect channel5g (defined in core.c).

Tested only with rtl8192du, which will use the same TX power code.

Cc: stable@vger.kernel.org
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/c7653517-cf88-4f57-b79a-8edb0a8b32f0@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -892,8 +892,8 @@ static u8 _rtl92c_phy_get_rightchnlplace
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < ARRAY_SIZE(channel5g); place++) {
-			if (channel5g[place] == chnl) {
+		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {
+			if (channel_all[place] == chnl) {
 				place++;
 				break;
 			}


