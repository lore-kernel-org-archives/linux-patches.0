Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5721F6691;
	Tue,  3 Dec 2024 15:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238433; cv=none; b=tlfS8cqpv4s2vBXp2/q8iyLMq9Q+8eLE+F/yT9VG+5gIRbqrGC+djVlmHGEKebNREaLc731FQ5hONjxliINybSxmXug5eVJRXXNB9bo0DUzIEgyXi82VJ9uH2EV4E9mDCLIgSBkRUJ3bfKBOfZK4GKy157j6xJB+8rDypObu+Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238433; c=relaxed/simple;
	bh=w1aczvYXMK6AC50lmmcKXOTZ4WI8xw+3kyHmBNhce4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBiKmZD5wnYzTyxeUZHeZe/m66+f27LwEGfXhK5Ya+yCB2nm3j2fBj21LUu4iQfws5SMCpRBCJd9TogzYJuV37gtRc2I1S0MC/ldziQ4KptF8tHyv9KgF1YO9YIuVq60SuN/CzvGnfLrCofs684oUA0KMAmFa9l9jJX1egMe6sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCgcXs2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCgcXs2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C466FC4CECF;
	Tue,  3 Dec 2024 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238433;
	bh=w1aczvYXMK6AC50lmmcKXOTZ4WI8xw+3kyHmBNhce4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCgcXs2zB/yL64M4CWvQcu9hittYoqSZ0/DKIs2sWa3D8RhFPscf7+gqHhEf8mzcx
	 E2D5NUxQiMgOi734RSREHa0utX7t1Jz3ohdw4G4mLaaREfmq/YVh8l6PpnkgTqL5ac
	 ejXIX7CWIHu+gjz0BqnGtPj2tyhlpVINXLlnvdwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 244/817] wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss2
Date: Tue,  3 Dec 2024 15:36:56 +0100
Message-ID: <20241203144005.291547730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 52db16ec5bae7bd027804265b968259d1a6c3970 ]

In supported_vht_mcs_rate_nss2, the rate for MCS9 & VHT20 is defined as
{1560, 1733}, this does not align with firmware's definition and therefore
fails the verification in ath10k_mac_get_rate_flags_vht():

	invalid vht params rate 1730 100kbps nss 2 mcs 9

and:

	invalid vht params rate 1920 100kbps nss 2 mcs 9

Change it to {1730,  1920} to align with firmware to fix the issue.

Since ath10k_hw_params::supports_peer_stats_info is enabled only for
QCA6174, this change does not affect other chips.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00309-QCARMSWPZ-1

Fixes: 3344b99d69ab ("ath10k: add bitrate parse for peer stats info")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/lkml/fba24cd3-4a1e-4072-8585-8402272788ff@molgen.mpg.de/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de> # Dell XPS 13 9360
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240711020344.98040-3-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3c34f3d8e5554..e62b251405fc0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9136,7 +9136,7 @@ static const struct ath10k_index_vht_data_rate_type supported_vht_mcs_rate_nss2[
 	{6,  {5265, 5850}, {2430, 2700}, {1170, 1300} },
 	{7,  {5850, 6500}, {2700, 3000}, {1300, 1444} },
 	{8,  {7020, 7800}, {3240, 3600}, {1560, 1733} },
-	{9,  {7800, 8667}, {3600, 4000}, {1560, 1733} }
+	{9,  {7800, 8667}, {3600, 4000}, {1730, 1920} }
 };
 
 static void ath10k_mac_get_rate_flags_ht(struct ath10k *ar, u32 rate, u8 nss, u8 mcs,
-- 
2.43.0



