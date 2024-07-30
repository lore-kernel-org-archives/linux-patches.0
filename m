Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C231A6161;
	Tue, 30 Jul 2024 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356852; cv=none; b=rP9nGh7uWDqzOAsmufBePYsul4Yk32WuMWfkrV5Y138IwluvM+5/sk5+RfbVQmqHu7aZIHq+iKRKP4s4KO+BtVfk82+rmvMk6tGqLKfpoat0HTjqNXJo/IqzLf02jdTmEImvG4Y/d9un/hKyqeufWvCtqhtAgdase6tAXoMQABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356852; c=relaxed/simple;
	bh=56f5E2qv9Q+7o5TUcbc+v5duY0KFW5vEo8lEuOJr3ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYQ8vMqlfNG6hyCPqzLy/W0LNQ3OWn1+NhYKtZpogmoi77j/WqD70aJsfCRyffT3Blkxv+e/RzLAQ45DM2AG3Ze+zKMFAPlYcdDqSdcbxaeKvKp62wOJI2K5EC7YaPhcHSRoQ5+BO2Qo/keNDJZzuYKGKVLQyHecgnOC3tdjtDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfWO1rzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfWO1rzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0814C32782;
	Tue, 30 Jul 2024 16:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356852;
	bh=56f5E2qv9Q+7o5TUcbc+v5duY0KFW5vEo8lEuOJr3ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfWO1rzTq56W77Wu9yI2wQ8LKBkR3YLN0k/+JPPpfXaMuPDrxD6rZ+toxOXLJe7Hp
	 iqUCCY79wWnQ2UWj/+eHyWB7k0OxzuCqDa4uCTNdBzNawVSteDQeM2HJcYMr7gObV5
	 CJ1cgDKiIe7mrfALlCxZhvOSBJZ2axxz8kRowMmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 193/809] wifi: cfg80211: handle 2x996 RU allocation in cfg80211_calculate_bitrate_he()
Date: Tue, 30 Jul 2024 17:41:09 +0200
Message-ID: <20240730151732.231812954@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit bcbd771cd5d68c0c52567556097d75f9fc4e7cd6 ]

Currently NL80211_RATE_INFO_HE_RU_ALLOC_2x996 is not handled in
cfg80211_calculate_bitrate_he(), leading to below warning:

kernel: invalid HE MCS: bw:6, ru:6
kernel: WARNING: CPU: 0 PID: 2312 at net/wireless/util.c:1501 cfg80211_calculate_bitrate_he+0x22b/0x270 [cfg80211]

Fix it by handling 2x996 RU allocation in the same way as 160 MHz bandwidth.

Fixes: c4cbaf7973a7 ("cfg80211: Add support for HE")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://msgid.link/20240606020653.33205-3-quic_bqiang@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index d262d37c15193..af6ec719567fc 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1524,7 +1524,9 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	if (WARN_ON_ONCE(rate->nss < 1 || rate->nss > 8))
 		return 0;
 
-	if (rate->bw == RATE_INFO_BW_160)
+	if (rate->bw == RATE_INFO_BW_160 ||
+	    (rate->bw == RATE_INFO_BW_HE_RU &&
+	     rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_2x996))
 		result = rates_160M[rate->he_gi];
 	else if (rate->bw == RATE_INFO_BW_80 ||
 		 (rate->bw == RATE_INFO_BW_HE_RU &&
-- 
2.43.0



