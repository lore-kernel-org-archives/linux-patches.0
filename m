Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E5047F53;
	Fri,  6 Dec 2024 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497135; cv=none; b=F9eWcP69uYmXut6nD7n4K8m8z15ZKAJnUzbreQMyRLWpph91375wv4SlpA58xjzBugpN98wbtHIKAg1T8mvrsRm1YwAOXoVUrWAJKR3aJnBGoGsmp8ZEuhIH5qWN84f42h8z9Jc4YXu4vt/zF4yniFCQsfQUwsBlBBnulWCpn/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497135; c=relaxed/simple;
	bh=eNuyNqXF5Ops9hpQje2L9it4NwVgKAn3KVDFy8JQtSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJbOgLMum2VU8k7eOOz22ZqWQOyvBkDo8yZrYIIRUpGkRfYi6I4gGmWYBVROQ7xE0JH10Uh21o6nuKMoNtfOU9h86cGdSX/2e2nADBppsKMHk9kTdCsAq6ds4boVytFuS7hIdqEi7jK2e2vLe6JNGWUCuBORcA+asSS18O/JSQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCO9QlYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCO9QlYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FEAC4CED1;
	Fri,  6 Dec 2024 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497135;
	bh=eNuyNqXF5Ops9hpQje2L9it4NwVgKAn3KVDFy8JQtSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCO9QlYY2ajiRGLsr18WgtjwEqC5q+I9Ty7/MdZlNx+d7aK9w1RqTFMgshMqRNL7V
	 /1408XedbMLI11rE3b7Rne/wRVxS3o2Lofjz73SeDngGgkmohqzzokgklOo2MxJJl6
	 4Dezwx8hSpX1z9QkV33o/WnuKNsNkNURe09vb+uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/676] wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss1
Date: Fri,  6 Dec 2024 15:29:57 +0100
Message-ID: <20241206143700.299829866@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit d50886b27850447d90c0cd40c725238097909d1e ]

In supported_vht_mcs_rate_nss1, the rate for MCS9 & VHT20 is defined as
{780,  867}, this does not align with firmware's definition and therefore
fails the verification in ath10k_mac_get_rate_flags_vht():

	invalid vht params rate 960 100kbps nss 1 mcs 9

Change it to {865,  960} to align with firmware, so this issue could be
fixed.

Since ath10k_hw_params::supports_peer_stats_info is enabled only for
QCA6174, this change does not affect other chips.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00309-QCARMSWPZ-1

Fixes: 3344b99d69ab ("ath10k: add bitrate parse for peer stats info")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/lkml/fba24cd3-4a1e-4072-8585-8402272788ff@molgen.mpg.de/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240711020344.98040-2-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 03e7bc5b6c0bd..cc7cf91f11147 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9119,7 +9119,7 @@ static const struct ath10k_index_vht_data_rate_type supported_vht_mcs_rate_nss1[
 	{6,  {2633, 2925}, {1215, 1350}, {585,  650} },
 	{7,  {2925, 3250}, {1350, 1500}, {650,  722} },
 	{8,  {3510, 3900}, {1620, 1800}, {780,  867} },
-	{9,  {3900, 4333}, {1800, 2000}, {780,  867} }
+	{9,  {3900, 4333}, {1800, 2000}, {865,  960} }
 };
 
 /*MCS parameters with Nss = 2 */
-- 
2.43.0



