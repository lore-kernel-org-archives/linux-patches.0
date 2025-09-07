Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D761CDFAC;
	Sun,  7 Sep 2025 20:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275620; cv=none; b=YftpOMv3wJDogvdPJtSrSBcByYN965qmZ8WkrwDOv5OKTfsx3hTBTuFJw1vCXf4MquTlSKBp3Q0cxBvyQ1JnK/hKeiX7G/Brs3OLheSk+Fk67gUCf40HH0xecXLEv0vEerWW2lLNrgak/UD8JRSDrEeDAloKIzbkdjPRJ8JmdI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275620; c=relaxed/simple;
	bh=W7wVPuhFVqICvKCN5QLPk1P8HXS3KwxLwp/onrZEUNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7X7cBUgLyCeftQBS0Nm7aAYdnor513ycuk00mFu6V4oKllFkJ2CTci0vnaNoe4O9tbBXOiQY7T3HjycMsv0mjLh44Zt8FWaSiuyiUpOPVQlo9KVuYwRuhU4qbT9yKmeVB9H755xGQzhpyFHwEolOtJDZQCNdXRXA85Od7mQ0ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaMLi3YI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaMLi3YI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B666DC4CEF0;
	Sun,  7 Sep 2025 20:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275620;
	bh=W7wVPuhFVqICvKCN5QLPk1P8HXS3KwxLwp/onrZEUNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaMLi3YITpDOalH4S+gzRSzSuGDjCM7fT5ZHGPDOBjieM17jR7kkmjS3s5ExUKlp7
	 VJSWRh05D9pmpXwlv5lIivNbpux0fIq0inSjo/SggzD7Uk/QAB6hPsC1M6yD5Sms3k
	 fPdfUTjAZX0E7MoIYGEizThaRG3YmGucl/s+BYYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/52] wifi: cw1200: cap SSID length in cw1200_do_join()
Date: Sun,  7 Sep 2025 21:57:32 +0200
Message-ID: <20250907195602.334250435@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



