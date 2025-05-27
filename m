Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8B7154C15;
	Tue, 27 May 2025 17:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365263; cv=none; b=CiCbG9eDAMrdhmsngP6vqc8bXq9EXIpSyyWkiccaAkM6W3UZdudaILrcbnWPDnI/WjV47n0yjqppMFbSTCSmQYptfTAJZ2bgaD2/MMgsGlf8i0SBexEExs2BikemLO0GZC5C1hYlFzOV6CNHow71Tbg31JdjkW8Jp828bklphto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365263; c=relaxed/simple;
	bh=v1/cRK5rIxk0anZGqx9yXhVeSAeXmBcrgKqG31GYfjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbsNHjcQy+CoCr8GgWHmGlw9XSFow4ER85dqdXbksDXIrz+0w3fUR44jHRv4nKwI+FzNDF6U4d8+XsQicNUeoSuXV9GEIZt1sdPGXpv9/yRAO3fCBBJqk6nmIkH7potx6G7yS9XtTncqRS6dVbtQ6Gxub4yNJ4nnne7OEC7wKRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DO5oPTbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DO5oPTbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CB4C4CEE9;
	Tue, 27 May 2025 17:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365263;
	bh=v1/cRK5rIxk0anZGqx9yXhVeSAeXmBcrgKqG31GYfjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DO5oPTbxHWqQtyKG+tf9/5j7RKmzqdTNELvi491hlQFZzFArptlSTMY3dAqnhFQwl
	 TInhCKUaIsTeeZ07SmH6uI3P6+f/9qLoHTxP2qx0r/9ciqoV2YANcSiZHUnPqon4LE
	 MF1tOIm5ZEWOQ2lCU0LG3LdnPL4e+q7gCnyFtbuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/626] wifi: rtw88: Fix rtw_desc_to_mcsrate() to handle MCS16-31
Date: Tue, 27 May 2025 18:23:33 +0200
Message-ID: <20250527162458.032099264@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



