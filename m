Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6B71411C5;
	Thu, 13 Jun 2024 12:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282896; cv=none; b=BMtah7qDXwDWdF8Uf9zaAtp74MSuMW71fx00X9s3Gpdb/RkexFaii221pCdxbz+iPzwMfqO33tXJkHwH5E585xZBOVBXM2SaU1vft4MI/yQdC+kKWbygnWYrEX9/19Z0UG3fxlg3f+qa654Lbg8IluejtjeCS+7HqIjFZ3PYI/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282896; c=relaxed/simple;
	bh=nMCXXIKkC04B/y/Kwu/sVXv5ohKROlp7C8VJjx7hn4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYHevfN2NdlCKmoVrBJu3nOByars8uWYpOQ76eC0B8W+gkh10k2zR+6C27zWBs4RQMlAkTuZbMQbr3AjS9vd7TKy09PzmoqkLQD/atiPYvOGI/5KoUTDfSFCO0haO+reXcTJG9xoJrrhyRAKxOB3N6dfcadIUCIpW0olOBERFT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oult8meV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oult8meV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA80DC2BBFC;
	Thu, 13 Jun 2024 12:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282896;
	bh=nMCXXIKkC04B/y/Kwu/sVXv5ohKROlp7C8VJjx7hn4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oult8meV4LybAY2iLzueDM8klSLLaaH7GNMrO8SZMJRa6IuLorFUeJTkatuxEDmER
	 nlj7O9RiiHFOFB2hTcLPjp9lHmmYHPj3MVRpjpGlYX6kjpO6k3qTjJWkgwAWF3tdtl
	 Px1Wk/DSghE5s7c7RRgCx1bON7gCl1G++LhrxGdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.1 30/85] wifi: rtlwifi: rtl8192de: Fix 5 GHz TX power
Date: Thu, 13 Jun 2024 13:35:28 +0200
Message-ID: <20240613113215.309449920@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


