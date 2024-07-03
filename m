Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D59A13D61B;
	Wed,  3 Jul 2024 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005915; cv=none; b=UEySCGMDxWgKzLQb/3UKqt98hLgVL/qVPV0qjc3b5buoJkMlbznc7f9yBmuIFsFz3WDDQvB7DODIO2ad3Wf3+SvmbKxUBC+ck9bCaxu0M3IJetePKqKc47+uvPF/7zTNKPtRG7+CWat4Wl1HoeNLAmfsPPXEQaO9g+gY1lEqgFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005915; c=relaxed/simple;
	bh=QqpGqPCPqY/Kwz22uDMjGFqC2Nyornygjfqr+kLe67o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meOhdRzNf8LBNZ15oToAwyddUG0hhIz8LMDiAgVM9m07hJT0vK02DbjZxnhTt8MwKg1la0sf6gBxPlgy9w0kFByTysE74IKP/ljC1UxGPqjkFOYkzY0m0azcPOwAAyj3vJB8f9l0HioeAwoPixD4/Dv+6iDIc1xFGiKNVmaNNJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FypmWHId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FypmWHId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99601C2BD10;
	Wed,  3 Jul 2024 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005915;
	bh=QqpGqPCPqY/Kwz22uDMjGFqC2Nyornygjfqr+kLe67o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FypmWHIddFS8g68GWEZmhL4AhKtK4F+RLRE3hq3kXvOjmINwt+4xi3LMbC1d95rxJ
	 y73fn3kQYPetaWqWpwAogRIM5jpRZAfEqyvpwIPHxRIFzjg0LiBBcssr7VvqwoVieZ
	 dmBBjyTO9bFS7zo2On+NxhYjamOIymeSd4tyspno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/356] wifi: rtlwifi: rtl8192de: Fix 5 GHz TX power
Date: Wed,  3 Jul 2024 12:39:34 +0200
Message-ID: <20240703102922.118526843@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit de4d4be4fa64ed7b4aa1c613061015bd8fa98b24 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index d835a27429f0f..56b5cd032a9ac 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -892,8 +892,8 @@ static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < ARRAY_SIZE(channel5g); place++) {
-			if (channel5g[place] == chnl) {
+		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {
+			if (channel_all[place] == chnl) {
 				place++;
 				break;
 			}
-- 
2.43.0



