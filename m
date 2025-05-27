Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A70724C07D;
	Tue, 27 May 2025 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367455; cv=none; b=m6OJ9tnzROVgTy4aGSNrtcXKXbmB6pvG6lVRAiozcBMC6YXwaa/DsvZBhB1AC79pgh+swTzQLlCV6V0GSQQ6ErLoQSKYUS/P6/j19cKN0nWQoyOIsIWPo44jdt7h3NR6lcxHowMII98hFsAN/N4s2KCSWGwjpeabYwY8ah4HSsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367455; c=relaxed/simple;
	bh=kJPDypCI6zRpoQduameoKB0lyx1k+yHi5muz8efo24c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX8gd63ni2fETxDjQ0EtEykRVDGVyt/sJu0+9O1fH6yc7WbnFfJHg6835cidbtju7SDQN7Ownpcim66MMsisRxH1D9MC2oO8bWeR8px79xg/JlLLNFSxlmt6YUi54cwt4rmowhK4/XFeBhpwUq78CwanZ2yuy8QfJPgJ5ZL6hSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFCnVjGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFCnVjGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC2EC4CEE9;
	Tue, 27 May 2025 17:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367455;
	bh=kJPDypCI6zRpoQduameoKB0lyx1k+yHi5muz8efo24c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFCnVjGJVxcRm0lARjhHmShUZCdGX1RHTDWWaM9qVz2lxC8gUvpSzPMol0Ouh1wc1
	 rp3UtpV01+Nn7QWYt9Zs2ROt1uOTyDTmB+glpJW+QSw7dEkL5pmsnMZ0cCT0IZ5xvf
	 rj+6MPO/mZ83ypa/9EF6aP5JuAr1XycXdxutBUnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 394/783] wifi: rtw88: Fix rtw_desc_to_mcsrate() to handle MCS16-31
Date: Tue, 27 May 2025 18:23:11 +0200
Message-ID: <20250527162529.137198369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 86d04f8f991a0509e318fe886d5a1cf795736c7d ]

This function translates the rate number reported by the hardware into
something mac80211 can understand. It was ignoring the 3SS and 4SS HT
rates. Translate them too.

Also set *nss to 0 for the HT rates, just to make sure it's
initialised.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/d0a5a86b-4869-47f6-a5a7-01c0f987cc7f@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/util.c b/drivers/net/wireless/realtek/rtw88/util.c
index e222d3c01a77e..66819f6944055 100644
--- a/drivers/net/wireless/realtek/rtw88/util.c
+++ b/drivers/net/wireless/realtek/rtw88/util.c
@@ -101,7 +101,8 @@ void rtw_desc_to_mcsrate(u16 rate, u8 *mcs, u8 *nss)
 		*nss = 4;
 		*mcs = rate - DESC_RATEVHT4SS_MCS0;
 	} else if (rate >= DESC_RATEMCS0 &&
-		   rate <= DESC_RATEMCS15) {
+		   rate <= DESC_RATEMCS31) {
+		*nss = 0;
 		*mcs = rate - DESC_RATEMCS0;
 	}
 }
-- 
2.39.5



