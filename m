Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6C51B424F;
	Sun,  7 Sep 2025 20:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275955; cv=none; b=mJM0pI4Wr5NWHzZ1E+8wHIybnZtonWUjjwySpBosREhshUHaUJUeKTRWyav0eT9tFBSPCXqlQLjX25zt1jxSzhF47ofcLw67w7QajzHqjIjk2a9LfU01DdBaXoKHQ842x42eLyIN+6vFvp90OvmV0eS9wth+FBNPKL7ppG7UlV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275955; c=relaxed/simple;
	bh=6t9gbSLkRkNe818WWzsrj5rrtal1VFgu8BZnoZnJsZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQPc0K2a1ruk8PkmbODmbGxi/96MMXHfEPz0PGfqv2uu0xrOGgO1bfkX4Qze3EZu983E+OGVMQkKpTYRh0EnaFvX3E18OjU3JxcBa+an5nOrk3jzLjAAqhf1sjkCpt3OpeOmQWRWWuJ4p50lHeXELrbEWXOXlcGSV/pnQ+vK/ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRipC7Fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRipC7Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AB5C4CEF0;
	Sun,  7 Sep 2025 20:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275955;
	bh=6t9gbSLkRkNe818WWzsrj5rrtal1VFgu8BZnoZnJsZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRipC7FjXkrsF4rv694XhjFJSzSMQifcgQECKo32F6dA6x1AE8kf0P2zGO0tXds/9
	 m3eO8b8HfoLU8yHbCJp6u2Y1X9uHFfnksD/tjbKZrVdJ47ywS6IUJ4Acw8wcV1Eaz7
	 Lq3wW7V6Z1K9K0IIKNlAOVyFYXH27rV3Wgjvq6Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/64] wifi: cw1200: cap SSID length in cw1200_do_join()
Date: Sun,  7 Sep 2025 21:58:00 +0200
Message-ID: <20250907195603.902418792@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f8f15f6742b8874e59c9c715d0af3474608310ad ]

If the ssidie[1] length is more that 32 it leads to memory corruption.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/e91fb43fcedc4893b604dfb973131661510901a7.1756456951.git.dan.carpenter@linaro.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 236022d4ae2a3..0f2d1ec34cd82 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -1289,7 +1289,7 @@ static void cw1200_do_join(struct cw1200_common *priv)
 		rcu_read_lock();
 		ssidie = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
 		if (ssidie) {
-			join.ssid_len = ssidie[1];
+			join.ssid_len = min(ssidie[1], IEEE80211_MAX_SSID_LEN);
 			memcpy(join.ssid, &ssidie[2], join.ssid_len);
 		}
 		rcu_read_unlock();
-- 
2.50.1



